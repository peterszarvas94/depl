
#!/bin/bash

# Deploy script for copying built files to target directory
# Usage: ./deploy.sh --dir <project_dir> --public <dist_dir> --target <target_dir>

set -e  # Exit on any error

# Default values
PROJECT_DIR=""
DIST_DIR=""
TARGET_DIR=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dir)
            PROJECT_DIR="$2"
            shift 2
            ;;
        --public)
            DIST_DIR="$2"
            shift 2
            ;;
        --target)
            TARGET_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 --dir <project_dir> --public <dist_dir> --target <target_dir>"
            exit 1
            ;;
    esac
done

# Validate required parameters
if [[ -z "$PROJECT_DIR" || -z "$DIST_DIR" || -z "$TARGET_DIR" ]]; then
    echo "Error: All parameters are required"
    echo "Usage: $0 --dir <project_dir> --public <dist_dir> --target <target_dir>"
    exit 1
fi

echo "Starting deployment..."
echo "Project directory: $PROJECT_DIR"
echo "Distribution directory: $DIST_DIR"
echo "Target directory: $TARGET_DIR"

# Step 1: Change to project directory
echo "Step 1: Changing to project directory..."
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "Error: Project directory '$PROJECT_DIR' does not exist"
    exit 1
fi
cd "$PROJECT_DIR"
echo "Changed to $(pwd)"

# Step 2: Git pull
echo "Step 2: Pulling latest changes from git..."
if [[ ! -d ".git" ]]; then
    echo "Error: Not a git repository"
    exit 1
fi
git pull
echo "Git pull completed"

# Step 3: Remove target directory children (keep directory)
echo "Step 3: Cleaning target directory..."
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Creating target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
else
    echo "Removing contents of target directory: $TARGET_DIR"
    rm -rf "$TARGET_DIR"/*
fi

# Step 4: Copy files from dist to target
echo "Step 4: Copying files from $DIST_DIR to $TARGET_DIR..."
if [[ ! -d "$DIST_DIR" ]]; then
    echo "Error: Distribution directory '$DIST_DIR' does not exist"
    exit 1
fi

cp -r "$DIST_DIR"/* "$TARGET_DIR"/
echo "Files copied successfully"

echo "Deployment completed successfully!"
echo "Files from $DIST_DIR have been deployed to $TARGET_DIR"
