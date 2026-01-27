# OpenXS Video Downloader


WebPage - (https://pratikkun.github.io/OpenXS-gui-for-yt_dlp/).


A comprehensive Qt/KDE-based graphical interface for yt-dlp with step-by-step wizard interface for easy video downloading on Linux.


![OpenXS Video Downloader](https://img.shields.io/badge/OpenXS-Video%20Downloader-blue)

![License](https://img.shields.io/badge/license-GPL--3.0-green)

![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

![Qt](https://img.shields.io/badge/Qt-5.15+-blue)


## Features


- **Step-by-Step Wizard Interface** - Simple 7-step process guides you through all options

- **Multiple Video Qualities** - Download in 4K, 1080p, 720p, or any available quality

- **Audio Extraction** - Extract audio in MP3, AAC, FLAC, OGG, or WAV formats

- **Playlist Support** - Download entire playlists with range and order options

- **Subtitle Downloads** - Download subtitles in 15+ languages

- **Advanced Options** - Speed limiting, thumbnails, metadata, custom arguments

- **Universal Linux Support** - Works on Ubuntu, Fedora, Arch, openSUSE, and more

- **Desktop Integration** - Proper application menu entries and desktop shortcuts


## Quick Installation


### One-Command Install (Recommended)


```bash

curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash

```


### Manual Installation


```bash

wget https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh

chmod +x install.sh

./install.sh

```


## Package Manager Installation (Not Ready Yet, Please Use The Command)


### Arch Linux (AUR)

```bash

yay -S openxs-video-downloader

```


### Flatpak

```bash

flatpak install org.openxs.VideoDownloader

```


### Snap

```bash

snap install openxs-video-downloader

```


### AppImage

Download the latest AppImage from [Releases](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/releases)


## Usage


After installation, launch the application:


- **Application Menu:** Utilities → OpenXS Video Downloader

- **Terminal:** `yt-dlp-xs`

- **Desktop Shortcut:** (if created during installation)


### Wizard Steps


1. **Enter URL** - Paste your video/playlist URL

2. **Choose Quality** - Select video resolution

3. **Playlist Options** - Configure playlist settings

4. **Audio Settings** - Audio extraction options

5. **Subtitles** - Select subtitle languages

6. **Advanced Options** - Thumbnails, metadata, speed limits

7. **Review & Download** - Confirm and start download


## Supported Platforms


- Ubuntu / Debian (apt)

- Fedora / RHEL / CentOS (dnf/yum)

- Arch Linux / Manjaro (pacman)

- openSUSE (zypper)

- Most other Linux distributions


## Dependencies


The installer automatically handles all dependencies:


- Qt5 (qtbase5-dev, qttools5-dev)

- CMake and build tools

- Python 3 and pip

- yt-dlp

- FFmpeg

- Git, curl, wget


## Building from Source


```bash

# Clone the repository

git clone https://github.com/PratikKun/OpenXS-gui-for-yt_dlp.git

cd OpenXS-gui-for-yt_dlp


# Make executable and build

chmod +x openxs.sh

./openxs.sh build


# Run the application

./openxs.sh run

```


## Configuration


The application uses a unified JSON configuration system hosted on GitHub. Configuration is automatically downloaded and cached locally.


## Uninstallation


```bash

# If installed system-wide

sudo /usr/local/bin/openxs-uninstall


# If installed locally

~/.local/bin/openxs-uninstall

```


## Contributing


1. Fork the repository

2. Create a feature branch (`git checkout -b feature/amazing-feature`)

3. Commit your changes (`git commit -m 'Add amazing feature'`)

4. Push to the branch (`git push origin feature/amazing-feature`)

5. Open a Pull Request


## License


This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.


## Acknowledgments


- Built on top of [yt-dlp](https://github.com/yt-dlp/yt-dlp)

- Uses Qt5 framework for the GUI

- Inspired by the need for a simple, wizard-based video downloader


## Support


- **Issues:** [GitHub Issues](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/issues)

- **Discussions:** [GitHub Discussions](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/discussions)


## Screenshots


<img width="1503" height="873" alt="image" src="https://github.com/user-attachments/assets/d6fbd0eb-cf2e-4593-962f-7cd3c28f871b" />




---


**OpenXS Video Downloader** - Making video downloads simple and accessible for everyone. 
