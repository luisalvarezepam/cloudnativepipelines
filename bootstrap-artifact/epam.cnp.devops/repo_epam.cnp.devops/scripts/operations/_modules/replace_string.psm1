function Format-Text {
    param (
        [string]$dir,
        [string]$input_string,
        [string]$output_string
    )
    Write-Host "Add Access Token to Git URL in files in directory $($dir):"
    $files = Get-ChildItem "$dir\/*.*" -Recurse -Filter "*.*"
    foreach ($file in $files) {
      $content = [System.IO.File]::ReadAllText($file.FullName) -replace "$input_string","$output_string"
      [System.IO.File]::WriteAllText($file.FullName, $content)
      Write-Host "Processing $file ..."
    }
}