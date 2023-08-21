# Set the source folder path
$sourceFolder = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\D"

# Set the destination folder path
$destinationFolder = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\FTP"

# Set the archive folder path
$archiveFolder = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\Arc"

# Set the log file path
$logFilePath = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\script_log.txt"


# Copy files from source to destination folder
Copy-Item -Path "$sourceFolder\*" -Destination $destinationFolder -Recurse -Force


# Function to create the archive folder for a given path
function CreateArchiveFolder($archivePath) {
    $archiveFolder = [System.IO.Path]::GetDirectoryName($archivePath)
    if (-not (Test-Path -Path $archiveFolder)) {
        New-Item -Path $archiveFolder -ItemType Directory -Force
        Write-Host "Created folder: $archiveFolder"
    }
}

# Function to archive and compress log files
function ArchiveAndCompressFiles {
    # Get all files in the destination folder
    Get-ChildItem -Path $destinationFolder | Where-Object {
        $_.PSIsContainer -eq $false
    } | ForEach-Object {
        $fileName = $_.Name
        $filePath = $_.FullName
        $archiveFileName = [System.IO.Path]::ChangeExtension($fileName, "zip")
        $archiveFilePath = Join-Path -Path $archiveFolder -ChildPath $archiveFileName

        # Check if the file exists in both source and destination folders
        $sourceFilePath = Join-Path -Path $sourceFolder -ChildPath $fileName
        if ((Test-Path -Path $filePath) -and (Test-Path -Path $sourceFilePath)) {
            CreateArchiveFolder $archiveFilePath
            Compress-Archive -Path $filePath -DestinationPath $archiveFilePath -Force
            Write-Host "Archived and compressed: $filePath -> $archiveFilePath"
        }
    }
}

# Call the function to perform the archiving and compression for each file
ArchiveAndCompressFiles

# Write log content to the log file
$scriptLogContent = "Script executed on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$scriptLogContent += "`r`n"
$scriptLogContent += "-------------------"
$scriptLogContent += "`r`n"
$scriptLogContent += Get-Content -Path $logFilePath
$scriptLogContent | Out-File -FilePath $logFilePath -Append -Force
