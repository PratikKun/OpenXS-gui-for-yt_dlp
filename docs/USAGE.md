# Usage Guide

This guide explains how to use OpenXS Video Downloader effectively.

## Getting Started

### Launching the Application

After installation, you can start OpenXS Video Downloader in several ways:

1. **Application Menu**: Applications → Utilities → OpenXS Video Downloader
2. **Terminal**: Type `yt-dlp-xs` and press Enter
3. **Desktop Shortcut**: Double-click the desktop icon (if created)

### First Launch

When you first open the application, you'll see:
- A welcome message
- A "Start Download Wizard" button
- An output area for download logs
- Control buttons (Start, Stop, Clear)

## Using the Download Wizard

OpenXS uses a 7-step wizard to guide you through the download process. Each step focuses on one aspect of the download configuration.

### Step 1: Video URL

**What to do**: Enter the URL of the video or playlist you want to download.

**Supported platforms**:
- YouTube (videos and playlists)
- Vimeo
- Dailymotion
- And many others supported by yt-dlp

**Examples**:
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ
https://www.youtube.com/playlist?list=PLrAXtmRdnEQy6nuLMt9JiYIk3HBzJyQcx
https://vimeo.com/123456789
```

**Tips**:
- Copy the URL from your browser's address bar
- The URL will be validated before proceeding
- Both single videos and playlists are supported

### Step 2: Video Quality

**What to do**: Select the video quality/resolution you prefer.

**Available options**:
- **Best Available**: Highest quality available
- **4K (2160p)**: Ultra HD quality
- **1440p**: 2K quality
- **1080p**: Full HD (recommended for most users)
- **720p**: HD quality
- **480p**: Standard definition
- **360p, 240p, 144p**: Lower qualities for slow connections
- **Worst Available**: Lowest quality available

**Tips**:
- Higher quality = larger file size
- Choose based on your internet speed and storage
- 1080p is a good balance for most users

### Step 3: Playlist Options

**What to do**: Configure how playlists should be downloaded (if applicable).

**Options**:
- **Download entire playlist**: Check to download all videos
- **Start from item**: Specify which video to start from (default: 1)
- **End at item**: Specify where to stop (0 = download all remaining)
- **Download in reverse order**: Download from newest to oldest

**Examples**:
- Download items 5-10: Start=5, End=10
- Download last 5 videos: Start=1, End=0, Reverse=checked
- Download only item 3: Start=3, End=3

**Tips**:
- For single videos, these options are ignored
- Use ranges to download specific parts of large playlists
- Reverse order is useful for getting latest videos first

### Step 4: Audio Settings

**What to do**: Configure audio extraction and format options.

**Audio-only download**:
- Check "Download audio only" to extract just the audio
- Useful for music, podcasts, or when you only need audio

**Audio formats**:
- **Best**: Highest quality available
- **MP3**: Most compatible, good compression
- **AAC**: Good quality, smaller files
- **FLAC**: Lossless quality, larger files
- **OGG**: Open source format
- **WAV**: Uncompressed, very large files

**Audio quality**:
- **Best**: Highest bitrate available
- **320k**: High quality (recommended)
- **256k, 192k**: Good quality
- **128k, 96k**: Lower quality, smaller files

**Tips**:
- MP3 320k is good for most music
- Use FLAC for archival quality
- Lower bitrates save storage space

### Step 5: Subtitles

**What to do**: Select which subtitle languages to download.

**Available languages**:
- English, Spanish, French, German, Italian
- Portuguese, Russian, Japanese, Korean, Chinese
- Arabic, Hindi, Turkish, Polish, Dutch

**Options**:
- Check "Download subtitles" to enable
- Select one or more languages
- English is selected by default

**Tips**:
- Subtitles are saved as separate .srt files
- Not all videos have subtitles in all languages
- Auto-generated subtitles may be available when manual ones aren't

### Step 6: Advanced Options

**What to do**: Configure additional download features.

**Available options**:
- **Download video thumbnails**: Save preview images
- **Save video metadata**: Create JSON files with video information
- **Limit download speed**: Prevent bandwidth saturation

**Speed limiting**:
- Check "Limit download speed to" and set KB/s
- Useful on shared connections
- Default: 1000 KB/s (1 MB/s)

**Tips**:
- Thumbnails are useful for organizing downloads
- Metadata includes title, description, upload date, etc.
- Speed limiting helps maintain network performance for other activities

### Step 7: Output Settings

**What to do**: Configure where and how files are saved.

**Output directory**:
- Default: Your Downloads folder
- Click "Browse" to select a different location
- Path can include environment variables

**Filename template**:
- Default: `%(title)s.%(ext)s` (video title + extension)
- Available placeholders:
  - `%(title)s`: Video title
  - `%(uploader)s`: Channel/uploader name
  - `%(upload_date)s`: Upload date (YYYYMMDD)
  - `%(ext)s`: File extension

**Custom arguments**:
- Advanced yt-dlp options
- Leave empty unless you know what you're doing

**Examples**:
```
%(uploader)s - %(title)s.%(ext)s
%(upload_date)s - %(title)s.%(ext)s
[%(uploader)s] %(title)s (%(upload_date)s).%(ext)s
```

### Step 8: Review and Download

**What to do**: Review your settings and start the download.

The summary shows:
- Video URL
- Quality settings
- Playlist configuration
- Audio settings
- Subtitle languages
- Advanced options
- Output location

**Final steps**:
1. Review all settings
2. Click "Finish" to start the download
3. Monitor progress in the main window

## Download Process

### Monitoring Downloads

Once you start a download:
- **Progress bar**: Shows overall progress
- **Output log**: Displays detailed yt-dlp output
- **Status messages**: Show current operation

### Download Controls

- **Stop Download**: Terminates the current download
- **Clear Output**: Clears the log area
- **Start Download Wizard**: Begin a new download

### Understanding Output

The output log shows:
- Download progress percentages
- File sizes and speeds
- Any errors or warnings
- Completion messages

**Example output**:
```
[youtube] dQw4w9WgXcQ: Downloading webpage
[youtube] dQw4w9WgXcQ: Downloading video info webpage
[download] Destination: Rick Astley - Never Gonna Give You Up.mp4
[download] 100% of 3.28MiB in 00:02
```

## Tips and Best Practices

### Choosing Quality

- **For viewing on phones/tablets**: 720p is usually sufficient
- **For computer viewing**: 1080p provides good quality
- **For archival**: Use "Best Available"
- **For slow connections**: Use 480p or lower

### Managing Storage

- **Audio-only**: Use for music to save space
- **Lower quality**: Reduces file sizes significantly
- **Selective downloads**: Use playlist ranges for large playlists

### Network Considerations

- **Speed limiting**: Use on shared or metered connections
- **Retry logic**: Built-in retry for network issues
- **Pause/resume**: Stop and restart downloads as needed

### Organization

- **Custom templates**: Organize files by uploader or date
- **Separate folders**: Use different output directories for different content
- **Metadata files**: Help with cataloging and searching

## Troubleshooting

### Common Issues

#### "Video unavailable" or "Private video"
- Video may be deleted, private, or region-blocked
- Try a different URL or check if the video exists

#### Download stops or fails
- Check your internet connection
- Some videos have download restrictions
- Try lowering the quality setting

#### No audio in downloaded video
- Some videos have separate audio/video streams
- Try selecting a different quality option
- Use audio-only mode if you only need audio

#### Subtitles not downloading
- Not all videos have subtitles
- Try different language options
- Some videos only have auto-generated subtitles

### Getting Help

If you encounter issues:

1. **Check the output log** for error messages
2. **Try different settings** (lower quality, different format)
3. **Test with a different video** to isolate the issue
4. **Report bugs** on GitHub with:
   - The video URL (if not private)
   - Your settings
   - The error message
   - Your operating system

### Advanced Usage

#### Custom yt-dlp Arguments

For advanced users, you can add custom yt-dlp arguments in Step 7:

**Examples**:
```
--write-description --write-annotations
--embed-subs --embed-thumbnail
--add-metadata --xattrs
```

**Warning**: Only use if you understand yt-dlp options. Invalid arguments may cause downloads to fail.

#### Batch Downloads

To download multiple videos:
1. Use playlist URLs when possible
2. Run the wizard multiple times for different videos
3. Consider using yt-dlp directly for complex batch operations

## Keyboard Shortcuts

- **Ctrl+Q**: Quit application
- **F1**: Show about dialog
- **Escape**: Cancel current wizard (if open)

## Configuration

The application automatically manages its configuration. Advanced users can:
- View config: `~/.config/openxs/openxs_config.json`
- Update config: The app automatically downloads updates
- Validate config: Use `./openxs.sh validate` (if you have the source)

---

For more help, visit the [GitHub repository](https://github.com/PratikKun/OpenXS-gui-for-yt_dlp) or check the other documentation files.