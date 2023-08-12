# Set the directory path

$directoryPath = "C:\path\to\your\directory"

$filesToDeletePatterns = @("*.tmp", "*.log")  # Change these patterns to match the files you want to delete


# Check if any deleting processes are still running
$deletingProcesses = Get-Process | Where-Object { $_.CommandLine -like "*Remove-Item -Path '$directoryPath\*'" }

if ($deletingProcesses.Count -gt 0) {
    Write-Host "There are other deleting processes still running. Please wait for them to finish."
} else {
    # No other deleting processes are running, proceed with deletion
    Get-ChildItem -Path $directoryPath -Recurse | ForEach-Object {
        $fullName = $_.FullName
        $name = $_.Name
        foreach ($pattern in $filesToDeletePatterns) {
            if ($name -like $pattern) {
                if ($_.PSIsContainer) {
                    Remove-Item -Path $fullName -Recurse -Force
                    Write-Host "Deleted folder: $($name)"
                } else {
                    Remove-Item -Path $fullName -Force
                    Write-Host "Deleted file: $($name)"
                }
                break
            }
        }
    }
    Write-Host "Files and folders deleted successfully."
}
