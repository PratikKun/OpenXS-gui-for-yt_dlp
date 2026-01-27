OpenXS Video Downloader

WebPage

A comprehensive Qt/KDE-based graphical interface for yt-dlp with a step-by-step wizard interface for easy video downloading on Linux.

Features

Step-by-Step Wizard Interface - Simple 7-step process guides you through all options.

Multiple Video Qualities - Download in 4K, 1080p, 720p, or any available quality.

Audio Extraction - Extract audio in MP3, AAC, FLAC, OGG, or WAV formats.

Playlist Support - Download entire playlists with range and order options.

Subtitle Downloads - Download subtitles in 15+ languages.

Advanced Options - Speed limiting, thumbnails, metadata, custom arguments.

Universal Linux Support - Works on Ubuntu, Fedora, Arch, openSUSE, and more.

Desktop Integration - Proper application menu entries and desktop shortcuts.

Quick Installation

One-Command Install (Recommended)

curl -sSL [https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh](https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh) | bash


Manual Installation

wget [https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh](https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh)
chmod +x install.sh
./install.sh


Package Manager Installation (Work in Progress)

Note: The following methods are currently under development. Please use the One-Command Install above for now.

Arch Linux (AUR)

# Coming soon
# yay -S openxs-video-downloader


Flatpak

# Coming soon
# flatpak install org.openxs.VideoDownloader


Snap

# Coming soon
# snap install openxs-video-downloader


AppImage

Download the latest AppImage from Releases

Usage

After installation, launch the application:

Application Menu: Utilities → OpenXS Video Downloader

Terminal: yt-dlp-xs

Desktop Shortcut: (If created during installation)

Wizard Steps

Enter URL - Paste your video/playlist URL.

Choose Quality - Select video resolution.

Playlist Options - Configure playlist settings.

Audio Settings - Audio extraction options.

Subtitles - Select subtitle languages.

Advanced Options - Thumbnails, metadata, speed limits.

Review & Download - Confirm and start download.

Supported Platforms

Ubuntu / Debian (apt)

Fedora / RHEL / CentOS (dnf/yum)

Arch Linux / Manjaro (pacman)

openSUSE (zypper)

Most other Linux distributions

Dependencies

The installer automatically handles all dependencies:

Qt5 (qtbase5-dev, qttools5-dev)

CMake and build tools

Python 3 and pip

yt-dlp

FFmpeg

Git, curl, wget

Building from Source

# Clone the repository
git clone [https://github.com/PratikKun/OpenXS-gui-for-yt_dlp.git](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp.git)
cd OpenXS-gui-for-yt_dlp

# Make executable and build
chmod +x openxs.sh
./openxs.sh build

# Run the application
./openxs.sh run


Configuration

The application uses a unified JSON configuration system hosted on GitHub. Configuration is automatically downloaded and cached locally.

Uninstallation

# If installed system-wide
sudo /usr/local/bin/openxs-uninstall

# If installed locally
~/.local/bin/openxs-uninstall


Contributing

See CONTRIBUTING.md for details on how to help the project.

License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details.

Acknowledgments

Built on top of yt-dlp

Uses Qt5 framework for the GUI

Inspired by the need for a simple, wizard-based video downloader

Support

Issues: GitHub Issues

Discussions: GitHub Discussions

Screenshots

<img width="1503" height="873" alt="OpenXS Interface" src="https://github.com/user-attachments/assets/d6fbd0eb-cf2e-4593-962f-7cd3c28f871b" />

OpenXS Video Downloader - Making video downloads simple and accessible for everyone.
