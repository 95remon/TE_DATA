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
