################################################################################################################################
# This script provides synchronization needed files from multiple remote repositories to one local repository,
# keeping required file structure in the local repository.  
#-------------------------------------------------------------------------------------------------------------------------------
# INPUT PARAMETERS:
#-------------------------------------------------------------------------------------------------------------------------------
# - org                     The URI of the organization where the project located.
#                           example: "https://dev.azure.com/ORGANIZATION-NAME/"
#-------------------------------------------------------------------------------------------------------------------------------
# - project                 The project from which you want to get a list of repositories.
#                           example: "ProjectName"
#-------------------------------------------------------------------------------------------------------------------------------
# - token                   The value of the PAT token created in the Azure DevOps with needed permissions.
#-------------------------------------------------------------------------------------------------------------------------------
# - sourceBranch            The source branch name of the remote repository.
#                           example: "main"
#-------------------------------------------------------------------------------------------------------------------------------
# - configFile              The path where configuration file located. The configuration file shoul be in JSON format.
#                           example: /scripts/_configuration/configuration_file.json
#-------------------------------------------------------------------------------------------------------------------------------
# - outputPath              The path where the files frome remote repositories will download.
#                           example: "/home/output"
#-------------------------------------------------------------------------------------------------------------------------------
# - local_dir               The path in the local repository where files should store.
#                           example: "/home/local"
################################################################################################################################

param (

    [parameter (Mandatory=$true)]
    [string]$org,

    [parameter (Mandatory=$true)]
    [string]$project,

    [parameter (Mandatory=$false)]
    [string]$token = $env:token,

    [parameter (Mandatory=$true)]
    [string]$sourceBranch,

    [parameter (Mandatory=$true)]
    [string]$configFile,

    [parameter (Mandatory=$true)]
    [string]$outputPath,

    [parameter (Mandatory=$true)]
    [string]$local_dir
)

### Set default script error action
$ErrorActionPreference = 'Stop'

Import-Module ./scripts/operations/_modules/dowload_remote_repos_files.psm1
Import-Module ./scripts/operations/_modules/synchronize_folders.psm1
Import-Module ./scripts/operations/_modules/replace_string.psm1

$authHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))}

$config = Get-Content $configFile | ConvertFrom-Json

############ Copy repositories and files #############

## Show if downloading files succeeded or some files are missed.
$env:downloadSucceeded = $true

$synch_check = $false

$varRepos = @()
$repoToCopyList = $null
$fileList = $null


$repos = Get-AzDoRepos -org $org -project $project -authHeader $authHeader
if ($config.repos -eq "all") {
    $repoToCopyList = $repos.value
}
elseif ($null -ne $config.repos.include) {
    $repoToCopyList = $repos.value | Where-Object {$config.repos.include.name -contains $_.name}
}
elseif ($null -ne $config.repos.exclude) {
    $repoToCopyList = $repos.value | Where-Object {$config.repos.exclude -notcontains $_.name}
}
else {
    Write-output ("Repository list hasn't been configured. Repositories are not going to be copied")
}

# Get parameters of each repository.
foreach ($repo in $repoToCopyList)
{

    # Get file list from each repository (from branch $sourceBranch).
    $files = Get-AzDoRepoFileList -org $org -project $project -repoName $repo.name -branch $sourceBranch -authHeader $authHeader
    if ($null -eq $config.repos.include)
    {
        if ($config.files -eq "all")
        {
            $filelist = $files
        }
        elseif ($null -ne $config.files.include)
        {
            $fileList = $files | Where-Object {$_.path -match $config.repos.files.include}
        }
        elseif ($null -ne $config.files.exclude)
        {
            $filelist = $files | Where-Object {$_.path -notmatch $config.repos.files.exclude}
        }
        else
        {
            Write-output ("The file list hasn't been configured for '$($_.name)' repository. Files are not going to be copied")
        }
    }
    else
    {
        if (($config.repos.include | Where-Object {$_.name -eq $repo.name}).files -eq "all")
        {
            $fileList = $files
        }
        elseif ($null -ne ($config.repos.include | Where-Object {$_.name -eq $repo.name}).files.include) {
            $include_files = ($config.repos.include | Where-Object {$_.name -eq $repo.name}).files.include
            $filelist = $files | Where-Object {$_.path -match $include_files}
        }
        elseif ($null -ne ($config.repos.include | Where-Object {$_.name -eq $repo.name}).files.exclude) {
            $exclude_files = ($config.repos.include | Where-Object {$_.name -eq $repo.name}).files.exclude
            $fileList = $files | Where-Object {$_.path -notmatch $exclude_files}
        }
        else {
            Write-output ("The file list hasn't been configured for '$($repo.name)' repository. Files are not going to be copied")
        }
    }

    # Download files.
    $relativePath = ("{0}\{1}" -f $outputPath, $repo.name) -replace " "

    $arguments = @{
        org = $org
        project = $project
        repoName = $repo.name
        branch = $sourceBranch
        authHeader = $authHeader
        fileList = $fileList
        relativePath = $relativePath
    }

    $env:downloadSucceeded = Get-AzDoRepoFiles @arguments
    $varRepos += @{
        name = $repo.name
        isDefaultRepo = ($repo.name -eq $project)
        files = $fileList.path
    }
}

Write-Output ("Repositories copied.`n")

########################## Compare the content between local and remote repos ##########################

## Get the remote folders' list
Write-Host "`n---- Processing. Compare the files. ----`n"

foreach ($repo in $repoToCopyList)
{
    Write-Host "The repo name is $($repo.name)"
    if ($repo.name -eq "epam.alz.terraform")
    {
        Write-Host "`n---- Replace the reference in the source strings. ----`n"
        Format-Text -dir "$outputPath/$($repo.name)" -input_string "\?ref=.+" -output_string '?ref=develop"'
        Write-Host "`n---- Replace the path in the source strings"
        Format-Text -dir "$outputPath/$($repo.name)" -input_string "git::https://EPMC-ACM@dev.azure.com/EPMC-ACM/AzureLandingZone/_git" `
        -output_string "git::https://EPMC-ACM@dev.azure.com/EPMC-ACM/epam.cnp.devops/_git/epam.cnp.devops//iac/terraform"
    }
    if (!(Test-Path "$local_dir/$($repo.name)"))
    {
        Write-Host "`n---- Creating... The folder $local_dir/$($repo.name) ----`n"
        New-Item "$local_dir/$($repo.name)" -itemType Directory
        Write-Host "`n---- Synchronizing folders... '$local_dir/$($repo.name)' and '$outputPath/$($repo.name)' ----`n"
        if ($synch_check -eq $false)
        {
            $synch_check = Compare-RefToDifFolders -remote_dir "$outputPath/$($repo.name)" -local_dir "$local_dir/$($repo.name)"
        }
        else
        {
            Compare-RefToDifFolders -remote_dir "$outputPath/$($repo.name)" -local_dir "$local_dir/$($repo.name)"
        }
    }
    else
    {
        Write-Host "`n---- Synchronizing folders... '$local_dir/$($repo.name)' and '$outputPath/$($repo.name)' ----`n"
        if ($synch_check -eq $false)
        {
            $synch_check = Compare-RefToDifFolders -remote_dir "$outputPath/$($repo.name)" -local_dir "$local_dir/$($repo.name)"
        }
        else
        {
            Compare-RefToDifFolders -remote_dir "$outputPath/$($repo.name)" -local_dir "$local_dir/$($repo.name)"
        }
    }
}

Write-Host "##vso[task.setvariable variable=SYNCH_CHECK;isOutput=true]$synch_check"

########################## Collects all parameters ##########################
Write-Host "`n---- Collect parameters ----`n"
$wrappedData = @{
    repositories = $varRepos
}

$wrappedData | ConvertTo-Json -Depth 20 | Out-file "$outputPath/copied_files.json"

### Check if script succeeded
if ($env:downloadSucceeded -eq $true) {
    Write-Output "Collecting data successfully finished."
}
else {
    throw ("Collecting data finished but some files are missed. Please rerun the script.")
}