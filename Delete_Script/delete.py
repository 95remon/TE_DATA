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
