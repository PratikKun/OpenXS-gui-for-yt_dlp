# OpenXS Video Downloader - Windows Version

Windows support for OpenXS Video Downloader with batch file implementation.

## Quick Installation

### One-Click Install

1. **Download the installer**: [install.bat](install.bat)
2. **Right-click** and select "Run as administrator" (recommended)
3. **Follow the prompts** - the installer will:
   - Install Python dependencies
   - Download yt-dlp
   - Set up the application
   - Create desktop shortcut
   - Add to PATH

### Manual Installation

```batch
REM Download the installer
curl -O https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/windows/install.bat

REM Run the installer
install.bat
```

## Requirements

- **Windows 10/11** (Windows 7/8 may work but not tested)
- **Python 3.6+** - Download from [python.org](https://python.org)
  - ⚠️ **Important**: Check "Add Python to PATH" during installation
- **PowerShell** (included with Windows)
- **Internet connection** for downloading dependencies

## Features

### Video Downloads
- **Multiple Formats**: MP4, MKV, AVI, WebM
- **Quality Selection**: 4K, 1080p, 720p, 480p, or Best/Worst
- **Smart Format Selection**: Automatically combines video+audio streams
- **Custom Output Directory**: Choose where to save files

### Audio Downloads
- **Audio-Only Mode**: Extract audio without video
- **Multiple Formats**: MP3, AAC, FLAC, OGG
- **Quality Options**: From 96k to 320k bitrate

### Playlist Support
- **Full Playlist Downloads**: Download entire YouTube playlists
- **Organized Output**: Creates folders by playlist name
- **Same Quality/Format**: Consistent settings across all videos

## Usage

### After Installation

Launch OpenXS Video Downloader:

1. **Desktop Shortcut**: Double-click "OpenXS Video Downloader"
2. **Command Prompt**: Type `yt-dlp-xs`
3. **Start Menu**: Search for "OpenXS"

### Command-Line Interface

The Windows version uses a simple menu-driven interface:

```
===================================
   OpenXS Video Downloader
===================================

Please choose an option:
1. Download single video
2. Download playlist
3. Audio-only download
4. Exit

Enter your choice (1-4):
```

### Single Video Download

1. **Enter URL**: Paste the YouTube/video URL
2. **Choose Quality**: Select from Best, 1080p, 720p, 480p
3. **Choose Format**: Select MP4, MKV, AVI, or WebM
4. **Set Output**: Choose download directory
5. **Download**: The video will be downloaded with audio

### Playlist Download

1. **Enter Playlist URL**: Paste the YouTube playlist URL
2. **Choose Settings**: Same as single video
3. **Organized Output**: Videos saved in playlist-named folder

### Audio-Only Download

1. **Enter URL**: Any video URL
2. **Choose Format**: MP3, AAC, FLAC, or OGG
3. **Extract**: Audio extracted and saved

## File Locations

### Installation Directory
```
%LOCALAPPDATA%\OpenXS\
├── openxs.bat              # Main application script
├── openxs_config.json      # Configuration file
├── yt-dlp-xs.exe          # Launcher executable
└── uninstall.bat          # Uninstaller
```

### Default Downloads
```
%USERPROFILE%\Downloads\
├── VideoTitle.mp4          # Single videos
└── PlaylistName\           # Playlist folder
    ├── Video1.mp4
    ├── Video2.mp4
    └── ...
```

## Configuration

The Windows version uses the same configuration system as the Linux version:

- **Auto-download**: Configuration downloaded from GitHub
- **Local cache**: Cached in installation directory
- **Format options**: Same quality and format options
- **Validation**: JSON schema validation

## Troubleshooting

### Common Issues

#### "Python is not installed or not in PATH"
- **Solution**: Install Python from [python.org](https://python.org)
- **Important**: Check "Add Python to PATH" during installation
- **Verify**: Open Command Prompt and type `python --version`

#### "yt-dlp is not installed"
- **Solution**: Run the installer again
- **Manual fix**: `pip install --user yt-dlp`

#### "Command not found: yt-dlp-xs"
- **Solution**: Restart Command Prompt after installation
- **Manual fix**: Add `%LOCALAPPDATA%\OpenXS` to your PATH

#### Downloads fail with format errors
- **Try different format**: Use MP4 instead of MKV
- **Lower quality**: Try 720p instead of 1080p
- **Check URL**: Ensure the video URL is valid

#### Permission errors
- **Run as administrator**: Right-click installer and "Run as administrator"
- **Check antivirus**: Some antivirus software blocks batch files

### Getting Help

- **GitHub Issues**: [Report problems](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp/issues)
- **Documentation**: Check the main [README.md](../README.md)
- **yt-dlp help**: `yt-dlp --help` for advanced options

## Uninstallation

### Using the Uninstaller
1. **Navigate to**: `%LOCALAPPDATA%\OpenXS`
2. **Run**: `uninstall.bat`
3. **Confirm**: Follow the prompts

### Manual Uninstallation
1. **Delete folder**: `%LOCALAPPDATA%\OpenXS`
2. **Remove shortcut**: Desktop "OpenXS Video Downloader"
3. **Clean PATH**: Remove OpenXS from environment variables (optional)

## Advanced Usage

### Custom yt-dlp Arguments

For advanced users, you can modify the batch file to add custom yt-dlp arguments:

```batch
REM Example: Add custom arguments
set "cmd=!cmd! --write-description --embed-subs"
```

### Batch Downloads

Create a text file with URLs (one per line) and use:

```batch
yt-dlp --batch-file urls.txt --merge-output-format mp4
```

## Differences from Linux Version

| Feature | Linux | Windows |
|---------|-------|---------|
| GUI | Qt5 Wizard | Command-line menu |
| Installation | System-wide | User-local |
| Dependencies | Auto-detected | Manual Python setup |
| Format Selection | Dropdown | Menu choice |
| Desktop Integration | Full | Shortcut only |

## Future Improvements

- **GUI Version**: Qt5 GUI for Windows (planned)
- **Installer Package**: MSI installer package
- **Auto-updates**: Automatic update checking
- **Context Menu**: Right-click integration in browsers

---

**Note**: This is the command-line version for Windows. A full GUI version similar to the Linux Qt5 interface is planned for future releases.