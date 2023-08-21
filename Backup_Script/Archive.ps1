# Set the source folder path
$sourceFolder = "C:\path\to\source\folder"

# Set the destination folder path (FTP folder)
$destinationFolder = "C:\path\to\destination\folder"

# Set the file extensions of the log files
$logFileExtensions = @(".log", ".txt")  # Add or modify extensions as needed

# Set the log file path
$logFilePath = "C:\path\to\log\folder\script_log.txt"

# Function to create the archive folder for a given path
function CreateArchiveFolder($archivePath) {
    $archiveFolder = [System.IO.Path]::GetDirectoryName($archivePath)
    if (-not (Test-Path -Path $archiveFolder)) {
        New-Item -Path $archiveFolder -ItemType Directory -Force
        Write-Host "Created folder: $archiveFolder"
    }
}

# Function to archive and compress log files
function ArchiveAndCompressLogFiles {
    # Get all log files in the source folder and its subfolders
    Get-ChildItem -Path $sourceFolder -Recurse | Where-Object {
        $logFileExtensions -contains $_.Extension -and $_.PSIsContainer -eq $false
    } | ForEach-Object {
        $logFileName = $_.Name
        $sourcePath = $_.FullName
        $relativePath = $sourcePath.Substring($sourceFolder.Length)
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $relativePath

        # Check if the log file exists in both source and destination folders
        if ((Test-Path -Path $sourcePath) -and (Test-Path -Path $destinationPath)) {
            $compressedFileName = [System.IO.Path]::ChangeExtension($logFileName, "zip")
            $compressedFilePath = Join-Path -Path $destinationPath -ChildPath $compressedFileName
            CreateArchiveFolder $compressedFilePath
            Compress-Archive -Path $sourcePath -DestinationPath $compressedFilePath -Force
            Write-Host "Archived and compressed: $sourcePath -> $compressedFilePath"
        }
    }
}

# Call the function to perform the archiving and compression for each log file
ArchiveAndCompressLogFiles

# Write log content to the log file
$scriptLogContent = "Script executed on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$scriptLogContent += "`r`n"
$scriptLogContent += "-------------------"
$scriptLogContent += "`r`n"
$scriptLogContent += Get-Content -Path $logFilePath
$scriptLogContent | Out-File -FilePath $logFilePath -Force
