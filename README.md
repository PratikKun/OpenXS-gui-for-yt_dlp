# OpenXS Video Downloader Linux Only

<div align="center">

![OpenXS Logo](https://img.shields.io/badge/OpenXS-Video%20Downloader-blue?style=for-the-badge&logo=youtube&logoColor=white)

**A modern, user-friendly video downloader with step-by-step wizard interface**

[![License](https://img.shields.io/badge/license-GPL--3.0-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows-lightgrey?style=flat-square)](README.md)
[![Qt](https://img.shields.io/badge/Qt-5.15+-blue?style=flat-square)](README.md)
[![Python](https://img.shields.io/badge/Python-3.6+-yellow?style=flat-square)](README.md)
[![GitHub release](https://img.shields.io/github/v/release/PratikKun/OpenXS-gui-for-yt_dlp?style=flat-square)](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/releases)
[![GitHub stars](https://img.shields.io/github/stars/PratikKun/OpenXS-gui-for-yt_dlp?style=flat-square)](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/stargazers)

[🚀 Quick Install](#quick-installation) • [📖 Documentation](#documentation) • [🎯 Features](#features) • [🐛 Issues](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/issues) • [💬 Discussions](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/discussions)

</div>

---

## 🎯 Features

### 🧙‍♂️ **Intuitive Wizard Interface**
- **7-step guided process** - No overwhelming options or complex forms
- **Smart defaults** - Works great out of the box
- **Progress tracking** - See exactly where you are in the process
- **Back/Forward navigation** - Change settings easily

### 🎥 **Advanced Video Downloads**
- **Multiple Quality Options** - 4K, 1080p, 720p, 480p, and more
- **Format Selection** - Choose from MP4, MKV, AVI, MOV, WebM, FLV
- **Smart Format Matching** - Automatically combines best video+audio streams
- **Container Enforcement** - Get exactly the format you want

### 🎵 **Professional Audio Extraction**
- **High-Quality Formats** - MP3, AAC, FLAC, OGG, WAV
- **Bitrate Control** - From 96k to 320k quality options
- **Audio-Only Mode** - Extract audio without downloading video
- **Metadata Preservation** - Keep artist, title, and album info

### 📋 **Playlist Management**
- **Full Playlist Support** - Download entire YouTube playlists
- **Range Selection** - Download specific items (e.g., videos 5-10)
- **Reverse Order** - Get newest videos first
- **Organized Output** - Creates folders by playlist name

### 🌍 **Subtitle Support**
- **15+ Languages** - English, Spanish, French, German, Japanese, and more
- **Auto-Generated** - Falls back to auto-generated when manual unavailable
- **Multiple Formats** - SRT, VTT, and more
- **Embedded Options** - Embed subtitles directly in video files

### ⚡ **Advanced Features**
- **Speed Limiting** - Control bandwidth usage
- **Retry Logic** - Automatic retry on network failures
- **Thumbnail Downloads** - Save video preview images
- **Metadata Extraction** - JSON files with video information
- **Custom Arguments** - Advanced yt-dlp options for power users

### 🖥️ **Cross-Platform Support**
- **Linux** - Full Qt5 GUI with desktop integration
- **Windows** - Command-line interface with menu system
- **Universal Installer** - One command installs everything
- **Package Manager Support** - AUR, Flatpak, Snap, AppImage

---

## 🚀 Quick Installation

### 🐧 Linux (Recommended)

**One-Command Install:**
```bash
curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash
```

**After installation, launch with:**
```bash
yt-dlp-xs
```

### 🪟 Windows

**One-Click Install:**
```batch
curl -O https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/windows/install.bat
install.bat
```

**Requirements:** Windows 10/11 with Python 3.6+

---

## 📦 Package Manager Installation

<div align="center">

| Platform | Command | Status |
|----------|---------|--------|
| **Arch Linux (AUR)** | `yay -S openxs-video-downloader` | ✅ Available |
| **Flatpak** | `flatpak install org.openxs.VideoDownloader` | 🔄 Pending |
| **Snap** | `snap install openxs-video-downloader` | 🔄 Pending |
| **AppImage** | [Download from Releases](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/releases) | ✅ Available |

</div>

---

## 🎮 Usage

### Linux GUI Version

1. **Launch the application:**
   - Application Menu → Utilities → OpenXS Video Downloader
   - Terminal: `yt-dlp-xs`
   - Desktop shortcut

2. **Follow the 7-step wizard:**
   1. **URL Entry** - Paste your video/playlist URL
   2. **Quality & Format** - Choose resolution and container format
   3. **Playlist Options** - Configure playlist settings
   4. **Audio Settings** - Audio extraction options
   5. **Subtitles** - Select subtitle languages
   6. **Advanced Options** - Thumbnails, metadata, speed limits
   7. **Review & Download** - Confirm and start download

### Windows Command-Line Version

1. **Launch:** Double-click desktop shortcut or run `yt-dlp-xs`
2. **Choose from menu:**
   - Single video download
   - Playlist download
   - Audio-only extraction
3. **Follow prompts** for URL, quality, format, and output location

---

## 🛠️ Supported Platforms

### Linux Distributions
- ✅ **Ubuntu / Debian** (apt)
- ✅ **Fedora / RHEL / CentOS** (dnf/yum)
- ✅ **Arch Linux / Manjaro** (pacman)
- ✅ **openSUSE** (zypper)
- ✅ **Most other distributions** (universal installer)

### Desktop Environments
- ✅ **KDE Plasma**
- ✅ **GNOME**
- ✅ **XFCE**
- ✅ **MATE**
- ✅ **Cinnamon**
- ✅ **LXQt / LXDE**

### Windows Versions
- ✅ **Windows 11**
- ✅ **Windows 10**
- ⚠️ **Windows 8.1** (untested)
- ⚠️ **Windows 7** (untested)

---

## 📖 Documentation

### 📚 Documentation
- **[Windows Guide](windows/README.md)** - Windows-specific installation and usage
- **[Project Website](https://pratikkun.github.io/OpenXS-gui-for-yt_dlp/)** - Official website with demo
- **[GitHub Issues](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/issues)** - Bug reports and feature requests

---

## 🔧 Building from Source

### Prerequisites
- **Qt5** development libraries
- **CMake** 3.16+
- **C++17** compatible compiler
- **Python** 3.6+
- **Git**

### Build Steps
```bash
# Clone the repository
git clone https://github.com/PratikKun/OpenXS-gui-for-yt_dlp.git
cd OpenXS-gui-for-yt_dlp

# Install dependencies (auto-detected)
chmod +x openxs.sh
./openxs.sh install

# Build the application
./openxs.sh build

# Run locally
./openxs.sh run
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🐛 **Report Issues**
- Found a bug? [Open an issue](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/issues)
- Include your OS, steps to reproduce, and error messages

### 💡 **Suggest Features**
- Have an idea? [Start a discussion](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/discussions)
- Check existing requests first

### 🔧 **Code Contributions**
- Fork the repository
- Create a feature branch
- Make your changes
- Submit a pull request

---

## 🏆 Why Choose OpenXS?

### 🆚 **vs. Command-Line yt-dlp**
- ✅ **User-friendly GUI** instead of complex commands
- ✅ **Step-by-step guidance** vs. memorizing arguments
- ✅ **Visual feedback** and progress tracking
- ✅ **Error handling** with helpful messages

### 🆚 **vs. Other GUI Tools**
- ✅ **Modern wizard interface** vs. overwhelming option panels
- ✅ **Cross-platform support** (Linux + Windows)
- ✅ **Active development** and community support
- ✅ **Open source** and transparent
- ✅ **Package manager integration**

### 🆚 **vs. Online Downloaders**
- ✅ **Privacy-focused** - no data sent to third parties
- ✅ **No ads or limitations**
- ✅ **Batch downloads** and playlist support
- ✅ **High-quality formats** and advanced options
- ✅ **Works offline** once installed

---

## 📊 Project Stats

<div align="center">

![GitHub repo size](https://img.shields.io/github/repo-size/PratikKun/OpenXS-gui-for-yt_dlp?style=flat-square)
![GitHub code size](https://img.shields.io/github/languages/code-size/PratikKun/OpenXS-gui-for-yt_dlp?style=flat-square)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/PratikKun/OpenXS-gui-for-yt_dlp?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/PratikKun/OpenXS-gui-for-yt_dlp?style=flat-square)

</div>

---

## 🙏 Acknowledgments

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** - The powerful backend that makes it all possible
- **[Qt Framework](https://www.qt.io/)** - Cross-platform GUI framework
- **Contributors** - Everyone who has helped improve this project
- **Community** - Users who provide feedback and suggestions

---

## 📄 License

This project is licensed under the **GPL-3.0 License** - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Links

<div align="center">

**[🌟 Star this repo](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/stargazers)** • **[🍴 Fork it](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/fork)** • **[📥 Download](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/releases)**

Made with ❤️ for the open source community

</div>

## 📁 Project Structure

```
OpenXS-gui-for-yt_dlp/
├── openxs.sh              # Main application script (Linux)
├── openxs_config.json     # Unified configuration file
├── install.sh             # System installer script
├── README.md              # This file
├── LICENSE                # GPL-3.0 license
├── .gitignore             # Git ignore rules
├── docs/
│   └── index.html         # Project website
└── windows/
    ├── install.bat        # Windows installer
    ├── openxs.bat         # Windows application
    └── README.md          # Windows documentation
```
