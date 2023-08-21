# Check if the sequence.txt file exists; if not, create it with an initial value of 1
$sequenceFilePath = Join-Path -Path (Get-Location) -ChildPath "sequence.txt"
if (-not (Test-Path -Path $sequenceFilePath)) {
    Set-Content -Path $sequenceFilePath -Value 1
}

# Set the source folder path
# $sourceFolder = "C:\path\to\source\folder"
$sourceFolder = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\S"


# Set the destination folder path
# $destinationFolder = "C:\path\to\destination\folder"
$destinationFolder = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\D"


# Read the last used sequence number from the sequence.txt file
$lastSequenceNumber = Get-Content -Path $sequenceFilePath
$lastSequenceNumber = [int]$lastSequenceNumber  # Convert to integer

# Set the log.txt file path
$logFilePath = "C:\Users\95rem\OneDrive\Desktop\WE\TE_DATA\Backup_Script\script_log.txt"

# Function to generate a new filename based on the base name, sequence number, date, and time
function GenerateNewFilename($baseName, $sequenceNumber, $fileExtension) {
    $timestamp = Get-Date -Format "dd-MM-yyyy-HH-mm-ss"
    $newFilename = "${baseName}_${timestamp}_${sequenceNumber}$fileExtension"
    return $newFilename
}

# Function to copy and rename log files
function CopyAndRenameLogFiles {
    $logContent = @()

    # Get the current date and time
    $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Get all items (files and folders) in the source folder
    Get-ChildItem -Path $sourceFolder | ForEach-Object {
        $sourcePath = $_.FullName
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
        $fileExtension = $_.Extension
        $newFilename = GenerateNewFilename $baseName $lastSequenceNumber $fileExtension
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $newFilename

        # Copy the file to the destination folder with the new name
        Copy-Item $sourcePath -Destination $destinationPath
        $logEntry = "$currentDateTime - Copied and renamed: $sourcePath -> $destinationPath"
        $logContent += $logEntry
    }

    # Write log content to the log file
    $logContent | Out-File -FilePath $logFilePath -Append

    # Increment the sequence number
    $lastSequenceNumber++

    # Update the sequence.txt file with the new last sequence number
    Set-Content -Path $sequenceFilePath -Value $lastSequenceNumber
}

# Call the function to copy, rename log files, and log the script's behavior
CopyAndRenameLogFiles
