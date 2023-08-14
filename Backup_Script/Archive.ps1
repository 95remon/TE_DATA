# Set the source folder path
$sourceFolder = "C:\path\to\source\folder"

# Set the archive folder path
$archiveFolder = "C:\path\to\archive\folder"

# Set the file extension of the log files
$logFileExtension = ".log"

# Function to create the archive folder for a given path
function CreateArchiveFolder($archivePath) {
    $archiveFolder = [System.IO.Path]::GetDirectoryName($archivePath)
    if (-not (Test-Path -Path $archiveFolder)) {
        New-Item -Path $archiveFolder -ItemType Directory -Force
    }
}

# Function to archive and compress each log file
function ArchiveAndCompressLogFiles {
    # Get all log files in the source folder and its subfolders
    Get-ChildItem -Path $sourceFolder -Recurse | Where-Object {
        $_.Extension -eq $logFileExtension -and $_.PSIsContainer -eq $false
    } | ForEach-Object {
        $sourcePath = $_.FullName
        $relativePath = $sourcePath.Substring($sourceFolder.Length)
        $archivePath = Join-Path -Path $archiveFolder -ChildPath $relativePath
        $compressedFileName = [System.IO.Path]::ChangeExtension($_.Name, "zip")
        $compressedFilePath = Join-Path -Path $archivePath -ChildPath $compressedFileName
        CreateArchiveFolder $compressedFilePath
        Compress-Archive -Path $sourcePath -DestinationPath $compressedFilePath -Force
        Write-Host "Archived and compressed: $sourcePath -> $compressedFilePath"
    }
}

# Call the function to perform the archiving and compression for each log file
ArchiveAndCompressLogFiles
