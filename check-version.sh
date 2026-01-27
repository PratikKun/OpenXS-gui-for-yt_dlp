#!/bin/bash

# OpenXS Video Downloader Version Checker
# This script helps verify you have the latest version with MP4 format fixes

echo "=== OpenXS Video Downloader Version Check ==="
echo ""

# Check if yt-dlp-xs command exists
if command -v yt-dlp-xs &> /dev/null; then
    echo "✓ yt-dlp-xs command found"
    INSTALL_TYPE="system"
else
    echo "✗ yt-dlp-xs command not found in PATH"
    INSTALL_TYPE="local"
fi

# Check for local build
if [[ -f "openxs.sh" ]]; then
    echo "✓ Source files found in current directory"
    
    # Check if the latest format fix is present
    if grep -q "merge-output-format" openxs.sh; then
        echo "✓ Latest MP4 format fix is present"
        echo "✓ Your version includes the WebM fix"
    else
        echo "✗ MP4 format fix not found"
        echo "⚠️  You need to update your source code"
        echo ""
        echo "To update:"
        echo "  git pull origin main"
        echo "  ./openxs.sh clean"
        echo "  ./openxs.sh build"
    fi
    
    # Check build status
    APP_DIR=$(eval echo "$(python3 -c "
import json
try:
    with open('openxs_config.json', 'r') as f:
        data = json.load(f)
    print(data['config']['paths']['app_dir'])
except:
    print('~/.local/share/openxs_video_downloader')
" 2>/dev/null)")
    
    BUILD_DIR="$APP_DIR/build"
    EXECUTABLE_NAME=$(python3 -c "
import json
try:
    with open('openxs_config.json', 'r') as f:
        data = json.load(f)
    print(data['config']['cmake']['executable_name'])
except:
    print('openxs_video_downloader')
" 2>/dev/null)
    
    if [[ -f "$BUILD_DIR/$EXECUTABLE_NAME" ]]; then
        echo "✓ Application is built"
        BUILD_DATE=$(stat -c %Y "$BUILD_DIR/$EXECUTABLE_NAME" 2>/dev/null || stat -f %m "$BUILD_DIR/$EXECUTABLE_NAME" 2>/dev/null)
        if [[ -n "$BUILD_DATE" ]]; then
            echo "  Built: $(date -d @$BUILD_DATE 2>/dev/null || date -r $BUILD_DATE 2>/dev/null)"
        fi
    else
        echo "✗ Application not built"
        echo "  Run: ./openxs.sh build"
    fi
else
    echo "✗ Source files not found"
    echo "  You may have a package installation"
fi

echo ""
echo "=== Test Command Generation ==="
echo ""
echo "The latest version should generate commands like:"
echo "  yt-dlp URL -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/...' --merge-output-format mp4"
echo ""
echo "If you see commands like:"
echo "  yt-dlp URL -f 'bestvideo[height<=1080]' (without +bestaudio)"
echo "Then you need to update and rebuild."
echo ""

# Provide update instructions
echo "=== Update Instructions ==="
echo ""
if [[ "$INSTALL_TYPE" == "system" ]]; then
    echo "For system installation:"
    echo "  curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash"
else
    echo "For source installation:"
    echo "  git pull origin main"
    echo "  ./openxs.sh clean"
    echo "  ./openxs.sh build"
fi

echo ""
echo "=== Format Fix Verification ==="
echo ""
echo "After updating, test with any YouTube video:"
echo "1. The command should include '--merge-output-format mp4'"
echo "2. The format should be 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/...'"
echo "3. You should get .mp4 files with audio, not .webm files"