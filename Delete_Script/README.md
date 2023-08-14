# Delete Script

### Question :
You are working with a directory containing various files and folders. You need to create a Python script to delete specific files based on their patterns. The script should allow you to specify multiple patterns for the files you want to delete. If any processes for deleting files are already running, the script should wait for them to finish. Can you provide a Python script that achieves this task?

### Answer :

## Using Python

```python
    import os
    import psutil
    import fnmatch


    # Set the directory path
    directory_path = r'C:\path\to\your\directory'
    files_to_delete_patterns = ["*.tmp", "*.log"]  # Change these patterns to match the files you want to delete

    # Check if any deleting processes are still running
    deleting_processes = [proc for proc in psutil.process_iter(attrs=['pid', 'cmdline'])
                        if proc.info['cmdline'] and ' '.join(proc.info['cmdline']).find(f'Remove-Item -Path {directory_path}') != -1]

    if deleting_processes:
        print("There are other deleting processes still running. Please wait for them to finish.")
    else:
        # No other deleting processes are running, proceed with deletion
        for root, dirs, files in os.walk(directory_path, topdown=False):
            for file_name in files:
                file_path = os.path.join(root, file_name)
                for pattern in files_to_delete_patterns:
                    if fnmatch.fnmatch(file_name, pattern):
                        os.remove(file_path)
                        print(f"Deleted file: {file_path}")
            for dir_name in dirs:
                dir_path = os.path.join(root, dir_name)
                os.rmdir(dir_path)
                print(f"Deleted folder: {dir_path}")
        print("Files and folders deleted successfully.")

```

1. Set the ***directory_path variable*** to the path of the directory containing the files you want to process.

2. Define the ***files_to_delete_patterns*** list to contain the patterns that match the files you want to delete. For example, if you want to delete both `.tmp` and `.log` files, set it as `["*.tmp", "*.log"]`.

3. The script checks for other deleting processes, similar to the previous examples.

4. Within the loop, it traverses through the directory and its subdirectories using the `os.walk()` function.

5. For each file, the script checks whether the filename matches any of the patterns in the ***files_to_delete_patterns*** list using the fnmatch.`fnmatch()` function from the fnmatch module.

6. If a matching pattern is found, the file is deleted using the `os.remove()` function, and a message is printed.

7. For each directory, the script uses `os.rmdir()` to delete the directory.

8. Messages are displayed indicating whether a folder or a file was deleted.

9. The final message indicates that files and folders have been deleted successfully.

***This Python script provides the same functionality as the previous examples but in a Python 3 environment.***

---

## Using Bash



```bash
    #!/bin/bash

    DIRECTORY_PATH="/path/to/your/directory"
    FILES_TO_DELETE_PATTERNS=("*.tmp" "*.log")  # Change these patterns to match the files you want to delete

    # Check if any deleting processes are still running
    if pgrep -f "rm -rf $DIRECTORY_PATH" > /dev/null; then
        echo "There are other deleting processes still running. Please wait for them to finish."
    else
        # No other deleting processes are running, proceed with deletion
        cd "$DIRECTORY_PATH" || exit  # Change directory
        for pattern in "${FILES_TO_DELETE_PATTERNS[@]}"; do
            for item in $pattern; do
                if [ -e "$item" ]; then
                    if [ -d "$item" ]; then
                        rm -rf "$item"
                        echo "Deleted folder: $item"
                    else
                        rm -f "$item"
                        echo "Deleted file: $item"
                    fi
                fi
            done
        done
        echo "Files and folders deleted successfully."
    fi

```


1. Set the ***FILES_TO_DELETE_PATTERNS*** array to contain the patterns that match the files you want to delete. For example, if you want to delete both `.tmp` and `.log` files, set it as `("\*.tmp" "\*.log")`.

2. The script still checks for other deleting processes and changes to the directory as before.

3. The outer loop iterates through each pattern in the ***FILES_TO_DELETE_PATTERNS*** array.

4. Inside the inner loop, the script iterates through files matching the current pattern.

5. If the item exists (file or folder), the script checks if it's a directory or a file.

6. If the item is a directory, the script uses `rm -rf` to delete the folder and its contents.

7. If the item is a file, the script uses `rm -f` to delete the file.

8. Messages are displayed indicating whether a folder or a file was deleted.

9. The final message indicates that files and folders have been deleted successfully.

***With this bash script, you can specify multiple patterns for the files you want to delete within the specified directory.***


---

## Using Powershell

```powershell
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

```

1. Set the ***$filesToDeletePatterns*** array to contain the patterns that match the files you want to delete. For example, if you want to delete both `.tmp` and `.log` files, set it as `@("*.tmp", "*.log")`.

2. The script still checks for other deleting processes and changes to the directory as before.

3. The script uses the `-Recurse` parameter in the `Get-ChildItem` cmdlet to retrieve all items within the directory, including subdirectories.

4. Inside the loop, the script iterates through each pattern in the ***$filesToDeletePatterns*** array.

5. For each item found, it checks if the filename matches the current pattern.

6. If a matching pattern is found, the script checks if the item is a directory or a file.

7. If the item is a directory, the script uses `Remove-Item` with the `-Recurse` and `-Force` parameters to delete the folder and its contents.

8. If the item is a file, the script uses `Remove-Item` with the `-Force` parameter to delete the file.

9. Messages are displayed indicating whether a folder or a file was deleted.

10. The final message indicates that files and folders have been deleted successfully.

***This PowerShell script now allows you to specify multiple patterns for the files you want to delete within the specified directory on an IIS server environment.***