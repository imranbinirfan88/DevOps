#!/bin/bash

# Define the source directory
SOURCE_DIR="/c/Users/imran.ullah/Downloads/weekly plan 2025-2026/JIS/ENGLISH SECTION/KG - 02"

# Define the source file (modify extension if needed, e.g., WEEK 01.docx)
SOURCE_FILE="$SOURCE_DIR/WEEK 01.docx"

# Debug: Check if directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' not found."
    exit 1
fi

# Debug: List files in directory to verify
echo "Listing files in $SOURCE_DIR:"
ls -l "$SOURCE_DIR"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file 'WEEK 01' not found in the specified directory."
    exit 1
fi

# Create copies from WEEK 02 to WEEK 50
for i in {02..50}; do
    cp "$SOURCE_FILE" "$SOURCE_DIR/WEEK $i"
    if [ $? -eq 0 ]; then
        echo "Created: WEEK $i"
    else
        echo "Failed to create: WEEK $i"
    fi
done

echo "All copies (WEEK 02 to WEEK 50) created successfully."
