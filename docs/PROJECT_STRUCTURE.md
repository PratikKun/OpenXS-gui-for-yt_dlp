# Project Structure

This document describes the organization and structure of the OpenXS Video Downloader project.

## Repository Overview

```
OpenXS-gui-for-yt_dlp/
├── .github/                    # GitHub-specific files
│   └── workflows/
│       └── build.yml          # CI/CD pipeline
├── docs/                      # Documentation
│   ├── index.html            # Project website
│   ├── INSTALLATION.md       # Installation guide
│   ├── USAGE.md             # User guide
│   └── PROJECT_STRUCTURE.md # This file
├── packaging/                # Package manager configurations
│   ├── appimage/
│   │   └── build-appimage.sh # AppImage build script
│   ├── arch/
│   │   └── PKGBUILD         # Arch Linux AUR package
│   ├── flatpak/
│   │   └── org.openxs.VideoDownloader.yml # Flatpak manifest
│   └── snap/
│       └── snapcraft.yaml   # Snap package configuration
├── .gitignore               # Git ignore rules
├── CHANGELOG.md             # Version history and changes
├── CONTRIBUTING.md          # Contribution guidelines
├── LICENSE                  # GPL-3.0 license
├── README.md               # Main project documentation
├── install.sh              # Universal installer script
├── openxs.sh              # Main application script
└── openxs_config.json     # Unified configuration file
```

## Core Files

### Main Application Files

- **`openxs.sh`**: Main application script that handles:
  - Dependency installation and management
  - Application building with CMake
  - Configuration management
  - GUI application execution

- **`openxs_config.json`**: Unified configuration file containing:
  - Application metadata and branding
  - Dependency lists for different package managers
  - GUI configuration (qualities, formats, languages)
  - Build system configuration
  - JSON schema for validation

- **`install.sh`**: Universal installer that:
  - Detects Linux distribution automatically
  - Installs system dependencies
  - Builds and installs the application
  - Creates desktop integration
  - Sets up uninstaller

### Documentation

- **`README.md`**: Main project documentation with:
  - Feature overview
  - Quick installation instructions
  - Usage examples
  - Contributing information

- **`docs/INSTALLATION.md`**: Comprehensive installation guide covering:
  - All installation methods
  - Distribution-specific instructions
  - Troubleshooting common issues
  - Uninstallation procedures

- **`docs/USAGE.md`**: Detailed user guide explaining:
  - How to use the wizard interface
  - All configuration options
  - Tips and best practices
  - Troubleshooting

- **`docs/index.html`**: Project website with:
  - Dark mode design
  - Installation instructions
  - Feature highlights
  - Package manager information

### Project Management

- **`CHANGELOG.md`**: Version history with:
  - Release notes for each version
  - Feature additions and changes
  - Bug fixes and improvements
  - Migration information

- **`CONTRIBUTING.md`**: Guidelines for contributors covering:
  - How to report issues
  - Development setup
  - Code style guidelines
  - Pull request process

- **`LICENSE`**: GPL-3.0 license terms

- **`.gitignore`**: Git ignore rules for:
  - Build artifacts
  - IDE files
  - Temporary files
  - Package build outputs

## Packaging Directory

### Package Manager Support

The `packaging/` directory contains configurations for different package managers and distribution methods:

#### `packaging/arch/`
- **`PKGBUILD`**: Arch Linux AUR package configuration
- Handles dependency installation via pacman
- Builds from source and creates system package

#### `packaging/flatpak/`
- **`org.openxs.VideoDownloader.yml`**: Flatpak manifest
- Sandboxed application with proper permissions
- Universal Linux distribution support

#### `packaging/snap/`
- **`snapcraft.yaml`**: Snap package configuration
- Confined application with interface access
- Automatic updates through Snap Store

#### `packaging/appimage/`
- **`build-appimage.sh`**: AppImage build script
- Creates portable executable
- No installation required, runs anywhere

## GitHub Integration

### `.github/workflows/`
- **`build.yml`**: CI/CD pipeline that:
  - Tests builds on Ubuntu
  - Creates AppImage releases
  - Publishes releases automatically
  - Runs on pushes and tags

## Configuration System

### Unified Configuration (`openxs_config.json`)

The configuration file uses a two-part structure:

1. **`schema`**: JSON Schema definition for validation
2. **`config`**: Actual configuration data

**Key sections**:
- `app`: Application metadata and window settings
- `paths`: File and directory locations
- `dependencies`: Package lists for different distributions
- `gui`: UI configuration and available options
- `messages`: User interface text and formatting
- `cmake`: Build system configuration

### Configuration Management

- **GitHub-hosted**: Configuration is downloaded from GitHub
- **Local caching**: Cached locally with expiration
- **Automatic updates**: Updates downloaded automatically
- **Schema validation**: Ensures configuration integrity
- **Fallback**: Uses cached version if download fails

## Build System

### CMake Integration

The application uses CMake for building:
- **Qt5 integration**: Automatic MOC and UI compilation
- **Cross-platform**: Works on different Linux distributions
- **Dependency management**: Finds required libraries
- **Installation targets**: System and user installation

### Build Process

1. **Dependency check**: Verify all requirements are met
2. **Configuration**: Load settings from JSON
3. **Code generation**: Create C++ source from configuration
4. **Compilation**: Build Qt5 application with CMake
5. **Installation**: Copy binary and create desktop entries

## Installation Locations

### System-wide Installation (root)
```
/usr/local/bin/yt-dlp-xs                    # Main executable
/usr/share/applications/openxs-*.desktop    # Desktop entry
/etc/openxs/openxs_config.json             # Configuration
/usr/local/bin/openxs-uninstall            # Uninstaller
```

### User Installation (non-root)
```
~/.local/bin/yt-dlp-xs                      # Main executable
~/.local/share/applications/openxs-*.desktop # Desktop entry
~/.config/openxs/openxs_config.json        # Configuration
~/.local/bin/openxs-uninstall              # Uninstaller
```

## Development Workflow

### Local Development

1. **Clone repository**: `git clone https://github.com/PratikKun/OpenXS-gui-for-yt_dlp.git`
2. **Install dependencies**: `./install.sh` or manual installation
3. **Build application**: `./openxs.sh build`
4. **Test locally**: `./openxs.sh run`
5. **Make changes**: Edit source code or configuration
6. **Rebuild**: `./openxs.sh clean && ./openxs.sh build`

### Release Process

1. **Update version**: Modify version in configuration files
2. **Update changelog**: Document changes in `CHANGELOG.md`
3. **Create tag**: `git tag v2.1.0`
4. **Push tag**: `git push origin v2.1.0`
5. **GitHub Actions**: Automatically builds and creates release
6. **Update packages**: Submit to AUR, Flatpak, Snap stores

## File Relationships

### Configuration Flow
```
openxs_config.json → openxs.sh → CMakeLists.txt → main.cpp
```

### Installation Flow
```
install.sh → openxs.sh → build → system integration
```

### Package Flow
```
Source → PKGBUILD/snapcraft.yaml/etc. → Package repositories
```

## Maintenance

### Regular Tasks

- **Update dependencies**: Keep Qt5 and yt-dlp versions current
- **Test on distributions**: Verify compatibility across Linux distros
- **Update documentation**: Keep guides current with changes
- **Monitor issues**: Respond to user reports and questions

### Configuration Updates

- **Schema changes**: Update both schema and config sections
- **Backward compatibility**: Maintain compatibility when possible
- **Validation**: Test configuration changes thoroughly
- **Documentation**: Update relevant documentation

This structure provides a maintainable, scalable foundation for the OpenXS Video Downloader project while supporting multiple distribution methods and development workflows.