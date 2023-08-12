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