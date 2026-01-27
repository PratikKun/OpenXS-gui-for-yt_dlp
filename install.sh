#!/bin/bash

# OpenXS Video Downloader - System Installer
# Installs to system with desktop integration and package manager support

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
APP_NAME="OpenXS Video Downloader"
BINARY_NAME="yt-dlp-xs"
DESKTOP_FILE="openxs-video-downloader.desktop"
INSTALL_DIR="/usr/local/bin"
DESKTOP_DIR="/usr/share/applications"
ICON_DIR="/usr/share/pixmaps"
CONFIG_URL="https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/openxs_config.json"
SCRIPT_URL="https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/openxs.sh"

# Print functions
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running as root for system installation
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root - will install system-wide"
        INSTALL_DIR="/usr/local/bin"
        DESKTOP_DIR="/usr/share/applications"
        ICON_DIR="/usr/share/pixmaps"
    else
        print_info "Running as user - will install to user directories"
        INSTALL_DIR="$HOME/.local/bin"
        DESKTOP_DIR="$HOME/.local/share/applications"
        ICON_DIR="$HOME/.local/share/pixmaps"
        
        # Create user directories if they don't exist
        mkdir -p "$INSTALL_DIR" "$DESKTOP_DIR" "$ICON_DIR"
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            print_info "Added ~/.local/bin to PATH. Please restart terminal or run: source ~/.bashrc"
        fi
    fi
}

# Detect package manager and distribution
detect_system() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        INSTALL_CMD="apt update && apt install -y"
        print_info "Detected Debian/Ubuntu system (apt)"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="dnf install -y"
        print_info "Detected Fedora/RHEL system (dnf)"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="pacman -S --noconfirm"
        print_info "Detected Arch Linux system (pacman)"
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
        INSTALL_CMD="zypper install -y"
        print_info "Detected openSUSE system (zypper)"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        INSTALL_CMD="yum install -y"
        print_info "Detected CentOS/RHEL system (yum)"
    else
        print_error "Unsupported package manager. Please install dependencies manually."
        exit 1
    fi
}

# Install system dependencies
install_dependencies() {
    print_step "Installing system dependencies..."
    
    case $PKG_MANAGER in
        "apt")
            if [[ $EUID -eq 0 ]]; then
                $INSTALL_CMD qtbase5-dev qttools5-dev cmake build-essential python3 python3-pip ffmpeg git curl wget
            else
                sudo $INSTALL_CMD qtbase5-dev qttools5-dev cmake build-essential python3 python3-pip ffmpeg git curl wget
            fi
            ;;
        "dnf")
            if [[ $EUID -eq 0 ]]; then
                $INSTALL_CMD qt5-qtbase-devel qt5-qttools-devel cmake gcc-c++ python3 python3-pip ffmpeg git curl wget
            else
                sudo $INSTALL_CMD qt5-qtbase-devel qt5-qttools-devel cmake gcc-c++ python3 python3-pip ffmpeg git curl wget
            fi
            ;;
        "pacman")
            if [[ $EUID -eq 0 ]]; then
                $INSTALL_CMD qt5-base qt5-tools cmake base-devel python python-pip ffmpeg git curl wget
            else
                sudo $INSTALL_CMD qt5-base qt5-tools cmake base-devel python python-pip ffmpeg git curl wget
            fi
            ;;
        "zypper")
            if [[ $EUID -eq 0 ]]; then
                $INSTALL_CMD libqt5-qtbase-devel libqt5-qttools-devel cmake gcc-c++ python3 python3-pip ffmpeg git curl wget
            else
                sudo $INSTALL_CMD libqt5-qtbase-devel libqt5-qttools-devel cmake gcc-c++ python3 python3-pip ffmpeg git curl wget
            fi
            ;;
        "yum")
            if [[ $EUID -eq 0 ]]; then
                $INSTALL_CMD qt5-qtbase-devel qt5-qttools-devel cmake gcc-c++ python3 python3-pip git curl wget
                # FFmpeg might need EPEL repository
                yum install -y epel-release && yum install -y ffmpeg
            else
                sudo $INSTALL_CMD qt5-qtbase-devel qt5-qttools-devel cmake gcc-c++ python3 python3-pip git curl wget
                sudo yum install -y epel-release && sudo yum install -y ffmpeg
            fi
            ;;
    esac
    
    print_info "System dependencies installed successfully"
}

# Install yt-dlp
install_ytdlp() {
    print_step "Installing yt-dlp..."
    
    # Try package manager first, fall back to pip
    case $PKG_MANAGER in
        "apt"|"dnf"|"yum")
            if ! command -v yt-dlp &> /dev/null; then
                if [[ $EUID -eq 0 ]]; then
                    pip3 install yt-dlp
                else
                    pip3 install --user yt-dlp
                fi
            fi
            ;;
        "pacman")
            if [[ $EUID -eq 0 ]]; then
                pacman -S --noconfirm yt-dlp
            else
                sudo pacman -S --noconfirm yt-dlp
            fi
            ;;
        "zypper")
            if [[ $EUID -eq 0 ]]; then
                pip3 install yt-dlp
            else
                pip3 install --user yt-dlp
            fi
            ;;
    esac
    
    print_info "yt-dlp installed successfully"
}

# Download and build application
build_application() {
    print_step "Downloading and building OpenXS Video Downloader..."
    
    # Create temporary build directory
    BUILD_DIR=$(mktemp -d)
    cd "$BUILD_DIR"
    
    # Download main script and config
    curl -sSL "$SCRIPT_URL" -o openxs.sh
    curl -sSL "$CONFIG_URL" -o openxs_config.json
    
    chmod +x openxs.sh
    
    # Build the application
    ./openxs.sh build
    
    # Get the built executable path
    APP_DIR=$(eval echo "$(python3 -c "
import json
with open('openxs_config.json', 'r') as f:
    data = json.load(f)
print(data['config']['paths']['app_dir'])
")")
    
    BUILD_APP_DIR=$(eval echo "$(python3 -c "
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
    
    # Copy executable to install directory
    if [[ $EUID -eq 0 ]]; then
        cp "$BUILD_APP_DIR/$EXECUTABLE_NAME" "$INSTALL_DIR/$BINARY_NAME"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
    else
        cp "$BUILD_APP_DIR/$EXECUTABLE_NAME" "$INSTALL_DIR/$BINARY_NAME"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
    fi
    
    # Copy config file to a system location
    CONFIG_SYSTEM_DIR="/etc/openxs"
    if [[ $EUID -eq 0 ]]; then
        mkdir -p "$CONFIG_SYSTEM_DIR"
        cp openxs_config.json "$CONFIG_SYSTEM_DIR/"
    else
        CONFIG_SYSTEM_DIR="$HOME/.config/openxs"
        mkdir -p "$CONFIG_SYSTEM_DIR"
        cp openxs_config.json "$CONFIG_SYSTEM_DIR/"
    fi
    
    # Cleanup
    cd /
    rm -rf "$BUILD_DIR"
    
    print_info "Application built and installed to $INSTALL_DIR/$BINARY_NAME"
}

# Create desktop entry
create_desktop_entry() {
    print_step "Creating desktop entry..."
    
    # Create application icon (simple text-based icon for now)
    cat > "$ICON_DIR/openxs.png" << 'EOF'
# This would be a proper PNG icon file
# For now, we'll use the system's default video icon
EOF
    
    # Create desktop entry file
    cat > "$DESKTOP_DIR/$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=Download videos with step-by-step wizard interface
Exec=$INSTALL_DIR/$BINARY_NAME
Icon=applications-multimedia
Terminal=false
Categories=AudioVideo;Video;Utility;
Keywords=youtube;video;download;yt-dlp;
StartupNotify=true
MimeType=x-scheme-handler/http;x-scheme-handler/https;
EOF
    
    # Make desktop file executable
    chmod +x "$DESKTOP_DIR/$DESKTOP_FILE"
    
    # Update desktop database if available
    if command -v update-desktop-database &> /dev/null; then
        if [[ $EUID -eq 0 ]]; then
            update-desktop-database /usr/share/applications
        else
            update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
        fi
    fi
    
    print_info "Desktop entry created at $DESKTOP_DIR/$DESKTOP_FILE"
}

# Create uninstaller
create_uninstaller() {
    print_step "Creating uninstaller..."
    
    cat > "$INSTALL_DIR/openxs-uninstall" << EOF
#!/bin/bash
# OpenXS Video Downloader Uninstaller

echo "Uninstalling OpenXS Video Downloader..."

# Remove binary
rm -f "$INSTALL_DIR/$BINARY_NAME"

# Remove desktop entry
rm -f "$DESKTOP_DIR/$DESKTOP_FILE"

# Remove icon
rm -f "$ICON_DIR/openxs.png"

# Remove config directory
if [[ -d "/etc/openxs" ]]; then
    rm -rf "/etc/openxs"
fi

if [[ -d "\$HOME/.config/openxs" ]]; then
    rm -rf "\$HOME/.config/openxs"
fi

# Remove this uninstaller
rm -f "$INSTALL_DIR/openxs-uninstall"

echo "OpenXS Video Downloader uninstalled successfully"
EOF
    
    chmod +x "$INSTALL_DIR/openxs-uninstall"
    print_info "Uninstaller created at $INSTALL_DIR/openxs-uninstall"
}

# Main installation function
main() {
    echo "=================================="
    echo "  OpenXS Video Downloader Setup  "
    echo "=================================="
    echo ""
    
    print_info "Starting installation..."
    
    check_permissions
    detect_system
    install_dependencies
    install_ytdlp
    build_application
    create_desktop_entry
    create_uninstaller
    
    echo ""
    echo "=================================="
    print_info "Installation completed successfully!"
    echo ""
    echo "You can now launch OpenXS Video Downloader from:"
    echo "• Application menu → Utilities → $APP_NAME"
    echo "• Terminal: $BINARY_NAME"
    echo ""
    echo "To uninstall: $INSTALL_DIR/openxs-uninstall"
    echo "=================================="
}

# Handle command line arguments
case "${1:-}" in
    "--help"|"-h")
        echo "OpenXS Video Downloader Installer"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --uninstall    Uninstall OpenXS Video Downloader"
        echo ""
        echo "Installation:"
        echo "  curl -sSL https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/install.sh | bash"
        ;;
    "--uninstall")
        if [[ -f "$INSTALL_DIR/openxs-uninstall" ]]; then
            "$INSTALL_DIR/openxs-uninstall"
        else
            print_error "Uninstaller not found. OpenXS may not be installed."
            exit 1
        fi
        ;;
    *)
        main
        ;;
esac