################################################################################################################################
# This module provides folders synchronization including file structure and file content.
#-------------------------------------------------------------------------------------------------------------------------------
# FUNCTIONS:
#-------------------------------------------------------------------------------------------------------------------------------
# Compare-RefToDifFolders         This function provides folders synchronization including file structure and file content.
#-------------------------------------------------------------------------------------------------------------------------------
# INPUT PARAMETERS:
#-------------------------------------------------------------------------------------------------------------------------------
# - remote_dir                   The reference directory path.
#                                examples: -remote_dir "C:\Documents\Reference_Dir"
#                                          -remote_dir "/home/reference_dir"
#-------------------------------------------------------------------------------------------------------------------------------
# - local_dir                    The difference directory path.
#                                examples: -local_dir "C:\Documents\Difference_Dir"
#                                          -local_dir "/home/difference_dir"
#-------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------
# Compare-Files                  This function provides file comparison, including file existence and file content 
#                                synchronization
#-------------------------------------------------------------------------------------------------------------------------------
# INPUT PARAMETERS:
#-------------------------------------------------------------------------------------------------------------------------------
# - remote_dir                   The reference directory path.
#                                examples: -remote_dir "C:\Documents\Reference_Dir"
#                                          -remote_dir "/home/reference_dir"
#-------------------------------------------------------------------------------------------------------------------------------
# - local_dir                    The difference directory path.
#                                examples: -local_dir "C:\Documents\Difference_Dir"
#                                          -local_dir "/home/difference_dir"
#-------------------------------------------------------------------------------------------------------------------------------
# - folder                       The folder path where file comparison will provide.
#                                example: -folder "C:\Documents\example_folder"
#                                         -folder "/home/example_folder"
################################################################################################################################
function Compare-Files {
    param (
        [string]$folder,
        [string]$remote_dir,
        [string]$local_dir
    )
    $files_copied = $false
    Write-Host "`n---- Processing... Compare the files lists. ----`n"
    $remote_files = Get-ChildItem $folder -Force | Where-Object {$_.Mode -notmatch "d"}
    if ($null -ne $remote_files)
    {
        $local_files = Get-ChildItem $folder.Replace("$remote_dir", "$local_dir") -Force | Where-Object {$_.Mode -notmatch "d"}
        if ($null -eq $local_files)
        {
            foreach ($file in $remote_files)
            {
                Write-Host "`n---- Copy file '$file' to '$($folder.Replace("$remote_dir", "$local_dir"))'"
                Copy-Item $file -Destination $folder.Replace("$remote_dir", "$local_dir") -Recurse -Force
                $files_copied = $true
            }
        }
        else
        {
            $compare_file_list = Compare-Object -ReferenceObject ($remote_files).Name -DifferenceObject ($local_files).Name -IncludeEqual
            if ($compare_file_list | Where-Object {$_.SideIndicator -eq '=>'})
            {
                foreach ($file in ($compare_file_list | Where-Object {$_.SideIndicator -eq '=>'}))
                {
                    Write-Host "`n---- Removing file '$($file.InputObject)' from '$($folder.Replace("$remote_dir", "$local_dir"))' ----`n"
                    Remove-Item "$($folder.Replace("$remote_dir", "$local_dir"))/$($file.InputObject)" -Force
                    $files_copied = $true
                }
            }
            elseif ($compare_file_list | Where-Object {$_.SideIndicator -eq '<='})
            {
                foreach ($file in ($compare_file_list | Where-Object {$_.SideIndicator -eq '<='}))
                {
                    Write-Host "`n---- Copying file '$($file.InputObject)' to '$($folder.Replace("$remote_dir", "$local_dir"))'. ----`n"
                    Copy-Item "$folder/$(($file).InputObject)" -Destination $folder.Replace("$remote_dir", "$local_dir") -Recurse -Force
                    $files_copied = $true
                }
            }
            else
            {
                Write-Host "`n---- Files lists in the '$folder' and  '$($folder.Replace("$remote_dir", "$local_dir"))' are the same. ----`n"
            }
            Write-Host "`n---- Processing... Compare files. ----`n"
            foreach ($file in $remote_files)
            {
                $destination = $file.FullName.Replace("$remote_dir", "$local_dir")
                if (($null -ne (Get-Content $file.FullName)) -and ($null -ne (Get-Content $file.FullName.Replace("$remote_dir", "$local_dir"))))
                {
                    $comparefiles = Compare-Object -ReferenceObject (Get-Content $file.FullName) -DifferenceObject (Get-Content $file.FullName.Replace("$remote_dir", "$local_dir")) -IncludeEqual
                    if ($comparefiles.SideIndicator.Contains('<=') -or $comparefiles.SideIndicator.Contains('=>'))
                    {
                        Write-Host "`n---- Copying '$($file.Name)' to '$($file.FullName.Replace("$remote_dir", "$local_dir"))' ----`n"
                        Copy-Item $file.FullName -Destination $destination.Replace("$($file.Name)", "") -Recurse -Force
                        $files_copied = $true
                    }
                    else
                    {
                        Write-Host "`n---- The file '$($file.Name)' exists in '$destination' and equal to '$($file.FullName)'."
                    }
                }
                elseif (($null -eq (Get-Content $file.FullName)) -xor ($null -eq (Get-Content $file.FullName.Replace("$remote_dir", "$local_dir"))))
                {
                    Write-Host "`n---- The file '$($file.FullName)' have no content ----`n"
                    Write-Host "`n---- Copying '$($file.Name)' to '$($file.FullName.Replace("$remote_dir", "$local_dir"))' ----`n"
                    Copy-Item $file.FullName -Destination $destination.Replace("$($file.Name)", "") -Recurse -Force
                    $files_copied = $true
                }
                else
                {
                    Write-Host "`n---- The files '$($file.FullName)' and '$($file.FullName.Replace("$remote_dir", "$local_dir"))) are the same and emty ----`n"
                }
            }
        }
    }
    else
    {
        Write-Host "`n---- There are no files in the '$folder' ----`n"
    }
    return ($files_copied)    
}

function Compare-RefToDifFolders {
    param (
        [string]$remote_dir,
        [string]$local_dir
    )
    $ErrorActionPreference = 'Stop'
    $folders_copied = $false
    $files_copied = $false
    $remote_file_structure = (Get-ChildItem $remote_dir -Recurse -Force | Where-Object {$_.Mode -match "d"}).FullName
    if ($null -eq $remote_file_structure)
    {
        Write-Host "`n---- There are no subfolders in the '$remote_dir'. ----`n ---- Processing... Compare files. ----`n"
        $files_copied = Compare-Files -folder $remote_dir -remote_dir $remote_dir -local_dir $local_dir
    }
    else
    {
        Write-Host "`n---- There are some subfolders in the '$remote_dir' ----`n ---- Synchronizing files and file structure. ----`n"
        foreach ($folder in $remote_file_structure)
        {
            if (!(Test-Path $folder.Replace("$remote_dir", "$local_dir")))
            {
                Write-Host "`n---- Copying the folder '$folder' to the '$($folder.Replace("$remote_dir", "$local_dir"))'. ----`n"
                Copy-Item $folder -Destination $folder.Replace("$remote_dir", "$local_dir") -Recurse -Force
                $folders_copied = $true
            }
            else
            {
                Write-Host "`n---- The folder '$folder' exists in the '$($folder.Replace("$remote_dir", "$local_dir"))'. ----`n"
                if ($files_copied -ne $true)
                {
                    $files_copied = Compare-Files -folder $folder -remote_dir $remote_dir -local_dir $local_dir
                }
                else
                {
                    Compare-Files -folder $folder -remote_dir $remote_dir -local_dir $local_dir
                }
            }
        }
    }
    if ($folders_copied -eq $true -or $files_copied -eq $true)
    {
        Write-Host "`n---- Some folders or files were modified in the '$local_dir'. ----`n"
        $env:modified = $true
    }
    else
    {
        Write-Host "`n---- There were no folders and files modified in the '$local_dir'. ----`n"
        $env:modified = $false
    }
    return ($env:modified)
}