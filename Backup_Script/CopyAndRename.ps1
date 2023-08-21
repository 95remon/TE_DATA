# Set the source folder path
$sourceFolder = "C:\path\to\source\folder"

# Set the destination folder path
$destinationFolder = "C:\path\to\destination\folder"

# Set the file extensions of the log files
$logFileExtensions = @(".log", ".txt")  # Add or modify extensions as needed

# Generate a random starting sequence number
$sequenceNumber = Get-Random -Minimum 10000 -Maximum 99999

# Set the log.txt file path
$logFilePath = "C:\path\to\log\folder\script_log.txt"

# Function to generate a new filename based on base name, sequence number, date, and time
function GenerateNewFilename($baseName, $sequenceNumber) {
    $timestamp = Get-Date -Format "dd-MM-yyyy-HH-mm-ss"
    $newFilename = "${baseName}_${timestamp}_${sequenceNumber}$logFileExtension"
    return $newFilename
}

# Function to copy and rename log files
function CopyAndRenameLogFiles {
    $logContent = @()

    # Get the current date and time
    $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Get all items (files and folders) in the source folder
    Get-ChildItem -Path $sourceFolder | ForEach-Object {
        if ($logFileExtensions -contains $_.Extension) {
            $sourcePath = $_.FullName
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
            $newFilename = GenerateNewFilename $baseName $sequenceNumber
            $destinationPath = Join-Path -Path $destinationFolder -ChildPath $newFilename

            # Copy the file to the destination folder with the new name
            Copy-Item $sourcePath -Destination $destinationPath
            $logEntry = "$currentDateTime - Copied and renamed: $sourcePath -> $destinationPath"
            $logContent += $logEntry

            $sequenceNumber++
        }
    }

    # Write log content to the log file
    $logContent | Out-File -FilePath $logFilePath -Append
}

# Call the function to copy, rename log files, and log the script's behavior
CopyAndRenameLogFiles
