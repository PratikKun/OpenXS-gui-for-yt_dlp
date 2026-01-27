# Changelog

All notable changes to OpenXS Video Downloader will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release preparation
- GitHub Actions CI/CD pipeline
- Package manager configurations (AUR, Flatpak, Snap, AppImage)

## [2.0.0] - 2026-01-27

### Added
- **Step-by-step wizard interface** replacing complex tabbed layout
- **Universal installer script** with automatic dependency detection
- **Desktop integration** for all major Linux desktop environments
- **Package manager support** (AUR, Flatpak, Snap, AppImage)
- **GitHub-hosted configuration** with automatic updates and validation
- **OpenXS branding** throughout the application
- **Terminal command** `yt-dlp-xs` for easy launching

### Features
- **7-step wizard process**:
  1. URL entry with validation
  2. Video quality selection (4K to 144p)
  3. Playlist configuration with range options
  4. Audio extraction settings (MP3, FLAC, etc.)
  5. Subtitle language selection (15+ languages)
  6. Advanced options (thumbnails, metadata, speed limiting)
  7. Output settings and final review
- **Comprehensive yt-dlp integration** with all major features
- **Real-time download progress** and output display
- **Smart format selection** and quality handling
- **Cross-distribution compatibility** (Ubuntu, Fedora, Arch, openSUSE)

### Technical
- **Qt5/C++ application** with modern CMake build system
- **JSON configuration system** with embedded schema validation
- **Automatic dependency installation** for all major package managers
- **State tracking** to avoid redundant installations
- **Proper desktop entries** and application menu integration
- **Uninstaller** for clean removal

### Installation
- **One-command installation**: `curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash`
- **Multiple package formats** available
- **System-wide or user-local** installation options
- **Automatic PATH configuration** for user installations

### Changed
- **Complete UI redesign** from tabbed interface to step-by-step wizard
- **Simplified user experience** with guided configuration
- **Improved error handling** and user feedback
- **Better desktop integration** across all environments

### Removed
- **Complex tabbed interface** in favor of wizard
- **Manual dependency management** (now automated)
- **Local-only configuration** (now GitHub-hosted)

## [1.0.0] - Previous Version

### Added
- Initial KDE yt-dlp GUI implementation
- Basic tabbed interface
- Manual dependency installation
- Local configuration files

---

## Release Notes

### v2.0.0 - Major Redesign

This release represents a complete redesign of the OpenXS Video Downloader with a focus on simplicity and ease of use. The new wizard-based interface guides users through each step of the download process, making it accessible to users of all technical levels.

**Key Improvements:**
- **Wizard Interface**: No more overwhelming options - each step is simple and focused
- **Universal Installation**: One command installs everything on any Linux distribution
- **Better Integration**: Proper desktop entries and application menu integration
- **Package Support**: Available through multiple package managers and formats

**Migration from v1.x:**
- No migration needed - v2.0 is a fresh installation
- Old installations can be removed manually if desired
- Configuration is now managed automatically

**Known Issues:**
- AppImage may require additional permissions on some systems
- Flatpak version pending Flathub approval
- Some older distributions may need manual dependency installation

**Future Plans:**
- Additional video platforms support
- Batch download capabilities
- Download queue management
- Custom output templates
- Plugin system for extensibility