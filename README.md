# Depl

A simple deployment script for copying built files from a distribution directory to a target directory with git integration.

## Features

- Pulls latest changes from git repository
- Cleans target directory before deployment
- Copies distribution files to target location
- Error handling and validation
- Command-line argument parsing

## Usage

```bash
./deploy.sh --dir <project_dir> --public <dist_dir> --target <target_dir>
```

### Parameters

- `--dir`: Project directory (must be a git repository)
- `--public`: Distribution directory containing built files
- `--target`: Target directory where files will be deployed

### Example

```bash
./deploy.sh --dir /path/to/project --public dist --target /var/www/html
```

## Requirements

- Bash shell
- Git repository in the project directory
- Read/write permissions for target directory

## License

MIT License - see LICENSE file for details.