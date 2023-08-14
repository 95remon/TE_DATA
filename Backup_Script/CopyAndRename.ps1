# Set the source folder path
$sourceFolder = "C:\path\to\source\folder"

# Set the destination folder path
$destinationFolder = "C:\path\to\destination\folder"

# Set the file extension of the log files
$logFileExtension = ".log"

# Initialize the sequence number
$sequenceNumber = 1

# Function to generate a new filename based on base name and sequence number
function GenerateNewFilename($baseName, $sequenceNumber) {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $newFilename = "${baseName}_${timestamp}_${sequenceNumber}$logFileExtension"
    return $newFilename
}

# Function to copy and rename log files
function CopyAndRenameLogFiles {
    # Get all items (files and folders) in the source folder
    Get-ChildItem -Path $sourceFolder | ForEach-Object {
        # Check if the item is a file and has the specified log file extension
        if ($_.Extension -eq $logFileExtension) {
            $sourcePath = $_.FullName
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
            $newFilename = GenerateNewFilename $baseName $sequenceNumber
            $destinationPath = Join-Path -Path $destinationFolder -ChildPath $newFilename
            
            # Copy the file to the destination folder with the new name
            Copy-Item $sourcePath -Destination $destinationPath
            Write-Host "Copied and renamed: $sourcePath -> $destinationPath"
            
            $sequenceNumber++
        }
    }
}

# Call the function to perform the copying and renaming
CopyAndRenameLogFiles
