############################################################################################################################################################
# This module provides data retrieval from Azure DevOps repositories, which includes a list of remote repositories, 
# a file list for each repository, and file downloads from each repository.
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# FUNCTIONS:
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# Get-AzDoRepos             This function provides Azure DevOps repository list retrieval.
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# INPUT PARAMETERS:
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - org                     The URI of the organization where the project located.
#                           example: -org "https://dev.azure.com/ORGANIZATION-NAME/"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - project                 The project from which you want to get a list of repositories.
#                           example: -project "ProjectName"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - authHeader              The header to authorized to the Azur DevOps organization
#                           example: -authHeader  @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":PAT_TOKEN"))}
#                           PAT_TOKEN is the value of the PAT token created in the Azure DevOps with needed permissions, 
#                                     recommended to pass as the environment variable .
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - apiVersion              The API version.
#                           example: -apiVersion "6.0"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# Get-AzDoRepoFileList      The function provides Azure DevOps repository files list retrieval.
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# INPUT PARAMETERS:
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - org                     The URI of the organization where the project located.
#                           example: -org "https://dev.azure.com/ORGANIZATION-NAME/"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - project                 The project from which you want to get a list of repositories.
#                           example: -project "ProjectName"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - authHeader              The header to authorized to the Azur DevOps organization
#                           example: -authHeader  @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":PAT_TOKEN"))}
#                           PAT_TOKEN is the value of the PAT token created in the Azure DevOps with needed permissions, 
#                                     recommended to pass as the environment variable .
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - apiVersion              The API version.
#                           example: -apiVersion "6.0"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - repoName                The repository name from which you want to get a list of files.
#                           example: -repoName "example.repo"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - branch                  The source branch name of the repository.
#                           example: -branch "main"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# Get-AzDoRepoFiles         The function downloads files from the repository.
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# INPUT PARAMETERS:
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - org                     The URI of the organization where the project located.
#                           example: -org "https://dev.azure.com/ORGANIZATION-NAME/"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - project                 The project from which you want to get a list of repositories.
#                           example: -project "ProjectName"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - authHeader              The header to authorized to the Azur DevOps organization
#                           example: -authHeader  @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":PAT_TOKEN"))}
#                           PAT_TOKEN is the value of the PAT token created in the Azure DevOps with needed permissions, 
#                                     recommended to pass as the environment variable .
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - apiVersion              The API version.
#                           example: -apiVersion "6.0"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - repoName                The repository name from which you want to get a list of files.
#                           example: -repoName "example.repo"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - branch                  The source branch name of the repository.
#                           example: -branch "main"
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - fileList                The list of the files which you want to download.
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
# - relativePath            The path where the files will download.
############################################################################################################################################################

### Gets repositories from AzDO project.
function Get-AzDoRepos {

    param (
        [string]$org,
        [string]$project,
        [hashtable]$authHeader,
        [string]$apiVersion = "6.0"
    )


    $uri = "{0}/{1}/_apis/git/repositories?api-version={2}" -f $org, $project, $apiVersion

    $attempt = 0
    do {
        $attempt ++
        $errorDetected = $null
        try { $result = Invoke-RestMethod -Uri $uri -Method Get -Headers $authHeader -ContentType "application/json" -ErrorAction Stop -ErrorVariable restError }
        catch { $errorDetected = $true; Start-Sleep -Seconds 1 }
    }
    while (($null -ne $errorDetected) -and ($attempt -lt 4))
    if ($null -ne $errorDetected) { throw($restError.ErrorRecord) }

    return ($result)
}

### Get file list from AzDO repository branch
function Get-AzDoRepoFileList {
    param (
        [string]$org,
        [string]$project,
        [string]$repoName,
        [hashtable]$authHeader,
        [string]$branch,
        [string]$apiVersion = "5.1"
    )

    if ( $null -eq $branch ) {
        $uri = "{0}/{1}/_apis/git/repositories/{2}/items?recursionLevel=Full&api-version={3}" -f $org, $project, $repoName, $apiVersion
    }
    else {
        $uri = "{0}/{1}/_apis/git/repositories/{2}/items?recursionLevel=Full&versionDescriptor.versionType=branch&versionDescriptor.version={4}&api-version={3}" `
               -f $org, $project, $repoName, $apiVersion, $branch
    }

    $attempt = 0
    do {
        $attempt ++
        $errorDetected = $null
        try { $itemList = Invoke-RestMethod -Uri $uri -Method Get -Headers $authHeader -ErrorAction Stop -ErrorVariable restError }
        catch { $errorDetected = $true; Start-Sleep -Seconds 1 }
    }
    while (($null -ne $errorDetected) -and ($attempt -lt 4))
    if ($null -ne $errorDetected) { throw($restError.ErrorRecord) }

    $fileList = $itemList.value | Where-Object -Property isFolder -ne "true"

    return ($fileList)
}

### Download all files from AzDo repo
function Get-AzDoRepoFiles {
    param (
        [string]$org,
        [string]$project,
        [string]$repoName,
        [hashtable]$authHeader,
        [string]$branch,
        [array]$fileList,
        [string]$apiVersion = "5.1",
        [string]$relativePath = ("temp_{0}" -f $repoName) -replace " "
    )

    $ErrorActionPreference = 'Stop'

    $fileList | ForEach-Object -Parallel {

        $uriFilePath = $_.url -replace "^.*items//","/" -replace "[?]versionType.*$" -replace "[+]","%2B"
        if ( $null -eq $using:branch ) {

            $uri = "{0}/{1}/_apis/git/repositories/{2}/items?scopePath={3}&download=true&versionType=Branch&versionOptions=None&api-version={4}" `
                   -f $using:org, $using:project, $using:repoName, $uriFilePath, $using:apiVersion
        }
        else {
            $uri = "{0}/{1}/_apis/git/repositories/{2}/items?scopePath={3}&download=true&versionDescriptor.versionType=branch&versionDescriptor.version={5}&api-version={4}" `
                   -f $using:org, $using:project, $using:repoName, $uriFilePath, $using:apiVersion, $using:branch
        }

        $tempPath = ("{0}{1}" -f $using:relativePath, $_.path) -replace "/","\"
        New-Item -Path $tempPath -Force | Out-Null

        # 10 attempts to download each file
        $downloadSucceeded = $true

        $invokeArgs = @{
            Uri = $uri
            Method = "Get"
            Headers = $using:authHeader
            ContentType = "application/octet-stream"
            OutFile = $tempPath
        }
        try { Invoke-RestMethod @invokeArgs -MaximumRetryCount 10 -RetryIntervalSec 1 -ErrorAction Stop }
        catch {
            $attempt = 1
            do {
                Start-Sleep -Seconds 2

                $downloadSucceeded = $true
                $downloadErr = $null

                try { Invoke-RestMethod @invokeArgs -MaximumRetryCount 10 -RetryIntervalSec 1 -ErrorVariable downloadErr -ErrorAction Stop }
                catch { $downloadSucceeded = $false }
                $attempt += 1
            }
            while ( ($downloadSucceeded -eq $false) -and ($attempt -lt 10) )
        }

        if ($downloadSucceeded -eq $true) { Write-Host ("File '{0}' downloaded." -f $tempPath) }
        else {
            $env:downloadSucceeded = $false
            throw ("Can't download file '{0}'.`n{1}" -f $tempPath, $downloadErr.ErrorRecord)
        }
    } -ThrottleLimit 64

    return ($env:downloadSucceeded)
}