

Here's a script to check if `ffmpeg` is installed on your system and install it if it's not. The script is designed to work across multiple systems by detecting the package manager available on the system. 

```bash
#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install ffmpeg using the appropriate package manager
install_ffmpeg() {
    if command_exists apt; then
        echo "Using APT to install ffmpeg..."
        sudo apt update && sudo apt install -y ffmpeg
    elif command_exists yum; then
        echo "Using YUM to install ffmpeg..."
        sudo yum install -y ffmpeg
    elif command_exists dnf; then
        echo "Using DNF to install ffmpeg..."
        sudo dnf install -y ffmpeg
    elif command_exists pacman; then
        echo "Using Pacman to install ffmpeg..."
        sudo pacman -Syu --noconfirm ffmpeg
    elif command_exists zypper; then
        echo "Using Zypper to install ffmpeg..."
        sudo zypper install -y ffmpeg
    elif command_exists brew; then
        echo "Using Homebrew to install ffmpeg..."
        brew install ffmpeg
    elif command_exists port; then
        echo "Using MacPorts to install ffmpeg..."
        sudo port install ffmpeg
    else
        echo "Error: No supported package manager found on this system."
        exit 1
    fi
}

# Check if ffmpeg is installed
if command_exists ffmpeg; then
    echo "ffmpeg is already installed."
else
    echo "ffmpeg is not installed. Installing it now..."
    install_ffmpeg
fi
```

### Instructions:

1. Copy this script into a file, e.g., `check_ffmpeg.sh`.
2. Make the script executable:
   ```bash
   chmod +x check_ffmpeg.sh
   ```
3. Run the script:
   ```bash
   ./check_ffmpeg.sh
   ```

### Notes:
- It checks for common package managers (`apt`, `yum`, `dnf`, `pacman`, `zypper`, `brew`, `port`).
- You may need `sudo` privileges for installation.
- This script is designed for Linux and macOS systems. For Windows, you'd typically use a package manager like Chocolatey or manually install `ffmpeg`.
