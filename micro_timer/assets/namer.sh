#!/bin/bash

# Directory containing the music files
DIRECTORY="/Users/atanasa/Desktop/Projects/micro_timer_app/micro_timer/assets/sounds"

# Navigate to the directory
cd "$DIRECTORY"

# Check if the directory change was successful
if [ $? -eq 0 ]; then
    # Loop through all mp3 files
    for file in *.mp3; do
        # Normalize the filename
        newname=$(echo "$file" | tr '[:upper:]' '[:lower:]' | sed -e 's/[- ]/_/g' -e 's/__*/_/g' -e 's/^_//;s/_$//')
        # Rename the file
        mv -v "$file" "$newname"
    done
else
    echo "Failed to change directory to $DIRECTORY. Check the directory path."
fi
