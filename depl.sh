#!/bin/bash

# Deployment script
# Usage: ./depl.sh --from <source_directory> --to <target_directory>

set -e  # Exit on any error

# Initialize variables
FROM_DIR=""
TO_DIR=""

# Function to display usage
usage() {
    echo "Usage: $0 --from <source_directory> --to <target_directory>"
    echo ""
    echo "This script will:"
    echo "1. Go to the source directory (--from)"
    echo "2. Pull latest changes (git pull)"
    echo "3. Remove everything in target directory (--to) while keeping the folder"
    echo "4. Copy everything from source to target"
    echo ""
    echo "Example:"
    echo "  $0 --from ~/projects/x --to /target"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --from)
            FROM_DIR="$2"
            shift 2
            ;;
        --to)
            TO_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "$FROM_DIR" ] || [ -z "$TO_DIR" ]; then
    echo "Error: Both --from and --to arguments are required."
    usage
fi

# Expand tilde in paths
FROM_DIR=$(eval echo "$FROM_DIR")
TO_DIR=$(eval echo "$TO_DIR")

# Validate source directory exists
if [ ! -d "$FROM_DIR" ]; then
    echo "Error: Source directory '$FROM_DIR' does not exist."
    exit 1
fi

# Check if source directory is a git repository
if [ ! -d "$FROM_DIR/.git" ]; then
    echo "Warning: Source directory '$FROM_DIR' is not a git repository. Skipping git pull."
    SKIP_GIT_PULL=true
else
    SKIP_GIT_PULL=false
fi

echo "Deployment script starting..."
echo "Source directory: $FROM_DIR"
echo "Target directory: $TO_DIR"
echo ""

# Step 1: Go to source directory
echo "Step 1: Changing to source directory..."
cd "$FROM_DIR"
echo "Current directory: $(pwd)"

# Step 2: Pull latest changes
if [ "$SKIP_GIT_PULL" = false ]; then
    echo ""
    echo "Step 2: Pulling latest changes..."
    git pull
    if [ $? -eq 0 ]; then
        echo "Git pull completed successfully."
    else
        echo "Error: Git pull failed."
        exit 1
    fi
else
    echo ""
    echo "Step 2: Skipping git pull (not a git repository)."
fi

# Step 3: Create target directory if it doesn't exist, or clean it if it does
echo ""
echo "Step 3: Preparing target directory..."
if [ ! -d "$TO_DIR" ]; then
    echo "Creating target directory: $TO_DIR"
    mkdir -p "$TO_DIR"
else
    echo "Cleaning target directory: $TO_DIR"
    # Remove all contents but keep the directory
    rm -rf "$TO_DIR"/*
    # Also remove hidden files/directories (except . and ..)
    find "$TO_DIR" -mindepth 1 -maxdepth 1 -name ".*" -exec rm -rf {} + 2>/dev/null || true
fi

# Step 4: Copy everything from source to target
echo ""
echo "Step 4: Copying files from source to target..."
cp -r "$FROM_DIR"/* "$TO_DIR"/ 2>/dev/null || true
# Also copy hidden files
cp -r "$FROM_DIR"/.[^.]* "$TO_DIR"/ 2>/dev/null || true

echo ""
echo "Deployment completed successfully!"
echo "Files copied from '$FROM_DIR' to '$TO_DIR'"