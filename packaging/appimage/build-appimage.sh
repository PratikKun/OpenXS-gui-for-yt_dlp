#!/bin/bash

# OpenXS Video Downloader AppImage Builder

set -e

APP_NAME="OpenXS_Video_Downloader"
APP_VERSION="2.0"
ARCH="x86_64"

# Create AppDir structure
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/lib
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Download and build application
echo "Building OpenXS Video Downloader..."
curl -sSL "https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/openxs.sh" -o openxs.sh
curl -sSL "https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/openxs_config.json" -o openxs_config.json

chmod +x openxs.sh
./openxs.sh build

# Get paths from config
APP_DIR=$(eval echo "$(python3 -c "
import json
with open('openxs_config.json', 'r') as f:
    data = json.load(f)
print(data['config']['paths']['app_dir'])
")")

BUILD_DIR=$(eval echo "$(python3 -c "
import json
with open('openxs_config.json', 'r') as f:
    data = json.load(f)
print(data['config']['paths']['build_dir'])
")")

EXECUTABLE_NAME=$(python3 -c "
import json
with open('openxs_config.json', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['executable_name'])
")

# Copy application files
cp "$BUILD_DIR/$EXECUTABLE_NAME" AppDir/usr/bin/yt-dlp-xs
cp openxs_config.json AppDir/usr/share/

# Copy Qt libraries
echo "Copying Qt libraries..."
ldd AppDir/usr/bin/yt-dlp-xs | grep "=> /" | awk '{print $3}' | grep -E "(libQt5|libqt5)" | while read lib; do
    cp "$lib" AppDir/usr/lib/
done

# Create desktop entry
cat > AppDir/usr/share/applications/openxs-video-downloader.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=OpenXS Video Downloader
Comment=Download videos with step-by-step wizard interface
Exec=yt-dlp-xs
Icon=openxs
Terminal=false
Categories=AudioVideo;Video;Utility;
Keywords=youtube;video;download;yt-dlp;
StartupNotify=true
MimeType=x-scheme-handler/http;x-scheme-handler/https;
EOF

# Create AppRun script
cat > AppDir/AppRun << 'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${LD_LIBRARY_PATH}"
export PATH="${HERE}/usr/bin:${PATH}"
exec "${HERE}/usr/bin/yt-dlp-xs" "$@"
EOF

chmod +x AppDir/AppRun

# Create simple icon (placeholder)
cat > AppDir/usr/share/icons/hicolor/256x256/apps/openxs.png << 'EOF'
# This would be a proper PNG icon file
# Using system multimedia icon for now
EOF

# Symlink for AppImage convention
ln -sf usr/share/applications/openxs-video-downloader.desktop AppDir/
ln -sf usr/share/icons/hicolor/256x256/apps/openxs.png AppDir/

# Download appimagetool if not present
if [[ ! -f appimagetool ]]; then
    echo "Downloading appimagetool..."
    wget -q "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O appimagetool
    chmod +x appimagetool
fi

# Build AppImage
echo "Building AppImage..."
./appimagetool AppDir "${APP_NAME}-${APP_VERSION}-${ARCH}.AppImage"

echo "AppImage created: ${APP_NAME}-${APP_VERSION}-${ARCH}.AppImage"