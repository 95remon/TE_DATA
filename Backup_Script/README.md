# BackUp

## Using Powershell

### CopyAndRename Script
```powershell
        # Set the source folder path
    $sourceFolder = "C:\path\to\source\folder"


    # Set the destination folder path
    $destinationFolder = "C:\path\to\destination\folder"


    # Set the file extension of the log files
    $logFileExtension = ".log"

    # Generate a random starting sequence number
    $sequenceNumber = Get-Random -Minimum 1 -Maximum 9999999

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
            if ($_.Extension -eq $logFileExtension) {
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


```

1. Set the `$sourceFolder` variable to the path of the folder containing the log files you want to copy and rename.

2. Set the `$destinationFolder` variable to the path of the folder where you want to copy the log files with the new names.

3. Set the `$logFileExtension` variable to the file extension of the log files `(e.g., ".log")`.

4. The `GenerateNewFilename` function creates a new filename based on the given base name, the current date and time, and a sequence number.

5. The `CopyAndRenameLogFiles` function uses `Get-ChildItem` to get the files in the source folder and iterates through them.

6. For each file with the specified log file extension, it generates a new filename using the `GenerateNewFilename` function and then copies the file from the source folder to the destination folder with the new name.

7. A message is written to the console indicating the source and destination paths for each copied and renamed log file.

8. The script calls the `CopyAndRenameLogFiles` function to perform the copying and renaming.

***This PowerShell script provides a way to copy log files from one folder to another while renaming them with the specified naming convention.***


### Archive Script

```powershell
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

```

1. Set the `$sourceFolder` variable to the path of the folder containing the log files you want to archive and compress.


2. Set the `$archiveFolder` variable to the path of the folder where you want to store the compressed archives while retaining their original folder structure.

3. Set the `$logFileExtension` variable to the file extension of the log files (e.g., ".log").

4. The `CreateArchiveFolder` function creates the archive folder structure that matches the original folder structure of the log files being archived.

5. The `ArchiveAndCompressLogFiles` function gets all log files in the source folder and its subfolders using `Get-ChildItem`.

6. For each log file, the script creates the corresponding archive folder structure using the `CreateArchiveFolder` function.

7. The log file is compressed into a separate ZIP archive for each file, and the compressed archive is placed in the archive folder.

8. A message is written to the console indicating the source path and the path of each compressed archive.

9. The script calls the `ArchiveAndCompressLogFiles` function to perform the archiving and compression for each individual log file.

***This PowerShell script allows you to archive and compress each individual log file from a source folder into separate compressed archives while maintaining their original folder structure.***
