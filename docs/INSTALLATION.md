# Installation Guide

This guide covers all installation methods for OpenXS Video Downloader on Linux systems.

## Quick Installation (Recommended)

### One-Command Install

```bash
curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash
```

This command will:
- Detect your Linux distribution automatically
- Install all required dependencies
- Build and install the application
- Create desktop entries and menu shortcuts
- Set up the `yt-dlp-xs` terminal command

### Manual Download and Install

```bash
wget https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh
chmod +x install.sh
./install.sh
```

## Package Manager Installation

### Arch Linux (AUR)

```bash
# Using yay
yay -S openxs-video-downloader

# Using paru
paru -S openxs-video-downloader

# Manual AUR installation
git clone https://aur.archlinux.org/openxs-video-downloader.git
cd openxs-video-downloader
makepkg -si
```

### Flatpak (Universal)

```bash
# Add Flathub repository (if not already added)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install OpenXS Video Downloader
flatpak install flathub org.openxs.VideoDownloader

# Run the application
flatpak run org.openxs.VideoDownloader
```

### Snap (Universal)

```bash
# Install from Snap Store
sudo snap install openxs-video-downloader

# Run the application
openxs-video-downloader
```

### AppImage (Portable)

```bash
# Download the latest AppImage
wget https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/releases/latest/download/OpenXS_Video_Downloader-2.0-x86_64.AppImage

# Make executable
chmod +x OpenXS_Video_Downloader-2.0-x86_64.AppImage

# Run directly
./OpenXS_Video_Downloader-2.0-x86_64.AppImage
```

## Distribution-Specific Instructions

### Ubuntu / Debian

```bash
# Update package list
sudo apt update

# Install dependencies (if installing manually)
sudo apt install qtbase5-dev qttools5-dev cmake build-essential python3 python3-pip ffmpeg git curl wget

# Run the installer
curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash
```

### Fedora / RHEL / CentOS

```bash
# Install dependencies (if installing manually)
sudo dnf install qt5-qtbase-devel qt5-qttools-devel cmake gcc-c++ python3 python3-pip ffmpeg git curl wget

# Run the installer
curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash
```

### Arch Linux / Manjaro

```bash
# Install dependencies (if installing manually)
sudo pacman -S qt5-base qt5-tools cmake base-devel python python-pip ffmpeg git curl wget

# Use AUR (recommended)
yay -S openxs-video-downloader

# Or run the installer
curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash
```

### openSUSE

```bash
# Install dependencies (if installing manually)
sudo zypper install libqt5-qtbase-devel libqt5-qttools-devel cmake gcc-c++ python3 python3-pip ffmpeg git curl wget

# Run the installer
curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash
```

## Building from Source

### Prerequisites

- Qt5 development libraries
- CMake 3.16+
- C++17 compatible compiler
- Python 3.6+
- Git

### Build Steps

```bash
# Clone the repository
git clone https://github.com/PratikKun/OpenXS-gui-for-yt_dlp.git
cd OpenXS-gui-for-yt_dlp

# Install dependencies (distribution-specific)
# See distribution sections above

# Build the application
chmod +x openxs.sh
./openxs.sh build

# Install system-wide (optional)
sudo ./openxs.sh install

# Or run locally
./openxs.sh run
```

### Custom Build Options

```bash
# Build only (no dependencies)
./openxs.sh build

# Clean build
./openxs.sh clean
./openxs.sh build

# Check installation status
./openxs.sh status

# Update configuration
./openxs.sh update-config

# Validate configuration
./openxs.sh validate
```

## Installation Locations

### System-wide Installation (root)

- **Binary**: `/usr/local/bin/yt-dlp-xs`
- **Desktop Entry**: `/usr/share/applications/openxs-video-downloader.desktop`
- **Configuration**: `/etc/openxs/openxs_config.json`
- **Uninstaller**: `/usr/local/bin/openxs-uninstall`

### User Installation (non-root)

- **Binary**: `~/.local/bin/yt-dlp-xs`
- **Desktop Entry**: `~/.local/share/applications/openxs-video-downloader.desktop`
- **Configuration**: `~/.config/openxs/openxs_config.json`
- **Uninstaller**: `~/.local/bin/openxs-uninstall`

## Post-Installation

### Launching the Application

After installation, you can launch OpenXS Video Downloader:

1. **Application Menu**: Look for "OpenXS Video Downloader" in Utilities
2. **Terminal**: Type `yt-dlp-xs`
3. **Desktop**: Use the desktop shortcut (if created)

### Verifying Installation

```bash
# Check if command is available
which yt-dlp-xs

# Test the application
yt-dlp-xs --help

# Check installation status
./install.sh status  # if you have the installer script
```

## Troubleshooting

### Common Issues

#### Command not found: yt-dlp-xs

```bash
# Add to PATH (for user installations)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Missing dependencies

```bash
# Re-run the installer to check dependencies
./install.sh

# Or install manually based on your distribution
```

#### Permission denied

```bash
# Make sure the binary is executable
chmod +x ~/.local/bin/yt-dlp-xs
# or
sudo chmod +x /usr/local/bin/yt-dlp-xs
```

#### Qt libraries not found

```bash
# Install Qt5 development packages
# Ubuntu/Debian:
sudo apt install qtbase5-dev qttools5-dev

# Fedora:
sudo dnf install qt5-qtbase-devel qt5-qttools-devel

# Arch:
sudo pacman -S qt5-base qt5-tools
```

### Getting Help

- **GitHub Issues**: [Report bugs and issues](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/issues)
- **Discussions**: [Ask questions](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/discussions)
- **Documentation**: Check other files in the `docs/` directory

## Uninstallation

### Using the Uninstaller

```bash
# System-wide installation
sudo /usr/local/bin/openxs-uninstall

# User installation
~/.local/bin/openxs-uninstall
```

### Manual Uninstallation

```bash
# Remove binary
sudo rm -f /usr/local/bin/yt-dlp-xs
# or
rm -f ~/.local/bin/yt-dlp-xs

# Remove desktop entry
sudo rm -f /usr/share/applications/openxs-video-downloader.desktop
# or
rm -f ~/.local/share/applications/openxs-video-downloader.desktop

# Remove configuration
sudo rm -rf /etc/openxs
# or
rm -rf ~/.config/openxs

# Remove uninstaller
sudo rm -f /usr/local/bin/openxs-uninstall
# or
rm -f ~/.local/bin/openxs-uninstall
```

### Package Manager Uninstallation

```bash
# AUR
yay -R openxs-video-downloader

# Flatpak
flatpak uninstall org.openxs.VideoDownloader

# Snap
sudo snap remove openxs-video-downloader

# AppImage
# Simply delete the .AppImage file
```