# Delete Script

## Using Powershell

```powershell

$directoryPath = "C:\path\to\your\directory" # Set the directory path

$daysAgo = 30  # Set the number of days ago

$logFilePath = "C:\path\to\log\script_log.txt"  # Set the log file path

$filesToDeletePatterns = @("*.tmp", "*.log")  # Set the patterns for files to delete


# Calculate the target date based on the specified number of days
$targetDate = (Get-Date).AddDays(-$daysAgo)

# Check if any deleting processes are still running
$deletingProcesses = Get-Process | Where-Object { $_.CommandLine -like "*Remove-Item -Path '$directoryPath\*'" }

if ($deletingProcesses.Count -gt 0) {
    Write-Host "There are other deleting processes still running. Please wait for them to finish."
    Add-Content -Path $logFilePath -Value "$(Get-Date) - There are other deleting processes still running."
} else {
    # No other deleting processes are running, proceed with deletion
    Get-ChildItem -Path $directoryPath -Recurse | ForEach-Object {
        $fullName = $_.FullName
        $name = $_.Name
        $lastWriteTime = $_.LastWriteTime
        
        # Check if the file matches any of the patterns
        $patternMatched = $false
        foreach ($pattern in $filesToDeletePatterns) {
            if ($name -like $pattern) {
                $patternMatched = $true
                break
            }
        }
        
        if ($patternMatched -and $lastWriteTime -lt $targetDate) {
            if ($_.PSIsContainer) {
                Remove-Item -Path $fullName -Recurse -Force
                Write-Host "Deleted folder: $($name)"
                Add-Content -Path $logFilePath -Value "$(Get-Date) - Deleted folder: $($name)"
            } else {
                Remove-Item -Path $fullName -Force
                Write-Host "Deleted file: $($name)"
                Add-Content -Path $logFilePath -Value "$(Get-Date) - Deleted file: $($name)"
            }
        }
    }
    Write-Host "Files and folders deleted successfully."
    Add-Content -Path $logFilePath -Value "$(Get-Date) - Files and folders deleted successfully."
}


```

1. Set the directory path, number of days ago, log file path, and file patterns.

2. Calculate the target date based on the specified number of days.

3. Check if other deleting processes are currently running.

4. If other processes are running, inform and log it.

5. If no other processes are running, proceed to deletion.

6. Loop through all items (files and folders) in the directory.

7. Check if the item's name matches any of the specified patterns.

8. If matched and last write time is earlier than the target date, delete the item.

9. Log each deleted item along with the current date and time.

10. Output a completion message once all items are processed.

***This script combines pattern matching, date comparison, and logging to selectively delete files based on patterns and their last modification date, while maintaining a log for future reference.***