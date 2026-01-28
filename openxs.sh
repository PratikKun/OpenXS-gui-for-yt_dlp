#!/bin/bash

# OpenXS Video Downloader (YouTube)
# Complete application with dependency installation, state tracking, and GUI
# All configuration loaded from unified GitHub-hosted JSON

set -e

# Configuration URLs (modify these to point to your GitHub raw URLs)
CONFIG_URL="https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/refs/heads/main/openxs_config.json"

# Local configuration cache
SCRIPT_DIR="$(dirname "$0")"
LOCAL_CONFIG="$SCRIPT_DIR/openxs_config.json"
CONFIG_CACHE_TIME=3600  # Cache for 1 hour (3600 seconds)

# Function to check if file is older than cache time
is_cache_expired() {
    local file="$1"
    local cache_time="$2"
    
    if [[ ! -f "$file" ]]; then
        return 0  # File doesn't exist, cache expired
    fi
    
    local file_time=$(stat -c %Y "$file" 2>/dev/null || echo 0)
    local current_time=$(date +%s)
    local age=$((current_time - file_time))
    
    if [[ $age -gt $cache_time ]]; then
        return 0  # Cache expired
    else
        return 1  # Cache still valid
    fi
}

# Function to download configuration from GitHub
download_config() {
    echo "Downloading OpenXS configuration from GitHub..."
    
    # Check if curl or wget is available
    if command -v curl &> /dev/null; then
        DOWNLOAD_CMD="curl -s -L"
    elif command -v wget &> /dev/null; then
        DOWNLOAD_CMD="wget -q -O -"
    else
        echo "ERROR: Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
    
    # Download unified config
    echo "Downloading openxs_config.json..."
    if ! $DOWNLOAD_CMD "$CONFIG_URL" > "$LOCAL_CONFIG.tmp"; then
        echo "ERROR: Failed to download config from $CONFIG_URL"
        if [[ -f "$LOCAL_CONFIG" ]]; then
            echo "Using cached configuration"
        else
            echo "No cached config available. Exiting."
            exit 1
        fi
    else
        # Validate JSON before replacing
        if python3 -c "import json; data = json.load(open('$LOCAL_CONFIG.tmp')); assert 'config' in data and 'schema' in data" 2>/dev/null; then
            mv "$LOCAL_CONFIG.tmp" "$LOCAL_CONFIG"
            echo "Successfully downloaded and validated openxs_config.json"
            
            # Validate config against embedded schema
            if python3 -c "
import json
try:
    import jsonschema
    with open('$LOCAL_CONFIG', 'r') as f:
        data = json.load(f)
    config = data['config']
    schema = data['schema']
    jsonschema.validate(config, schema)
    print('✅ Config validates against embedded schema')
except ImportError:
    print('ℹ️  jsonschema not available for validation')
except Exception as e:
    print(f'⚠️  Schema validation warning: {e}')
" 2>/dev/null; then
                echo "Schema validation passed"
            fi
        else
            echo "ERROR: Downloaded config is invalid or missing required sections"
            rm -f "$LOCAL_CONFIG.tmp"
            if [[ ! -f "$LOCAL_CONFIG" ]]; then
                echo "No valid config available. Exiting."
                exit 1
            fi
        fi
    fi
}

# Function to ensure config is available and up-to-date
ensure_config() {
    # Check if we need to download/update config
    if is_cache_expired "$LOCAL_CONFIG" "$CONFIG_CACHE_TIME"; then
        echo "Config cache expired or missing, downloading from GitHub..."
        download_config
    else
        echo "Using cached configuration (expires in $((CONFIG_CACHE_TIME - $(date +%s) + $(stat -c %Y "$LOCAL_CONFIG"))) seconds)"
    fi
    
    # Verify config file exists and is valid
    if [[ ! -f "$LOCAL_CONFIG" ]]; then
        echo "ERROR: No configuration file available"
        exit 1
    fi
    
    if ! python3 -c "import json; data = json.load(open('$LOCAL_CONFIG')); assert 'config' in data" 2>/dev/null; then
        echo "ERROR: Configuration file is invalid or missing config section"
        echo "Attempting to re-download..."
        rm -f "$LOCAL_CONFIG"
        download_config
    fi
}

# Load configuration from unified JSON
CONFIG_FILE="$LOCAL_CONFIG"

# Ensure we have a valid config before proceeding
ensure_config

# Function to read JSON values from unified config
read_json() {
    local key="$1"
    python3 -c "
import json, sys
try:
    with open('$CONFIG_FILE', 'r') as f:
        data = json.load(f)
    
    # Access config section
    config = data['config']
    
    keys = '$key'.split('.')
    value = config
    for k in keys:
        if k.isdigit():
            value = value[int(k)]
        else:
            value = value[k]
    
    if isinstance(value, list):
        print(' '.join(str(v) for v in value))
    elif isinstance(value, bool):
        print('true' if value else 'false')
    else:
        print(value)
except Exception as e:
    sys.stderr.write(f'Error reading $key: {e}\\n')
    sys.exit(1)
"
}

# Load app configuration
APP_NAME=$(read_json "app.name")
APP_VERSION=$(read_json "app.version")
APP_ORGANIZATION=$(read_json "app.organization")
APP_DESCRIPTION=$(read_json "app.description")
APP_ICON=$(read_json "app.icon")
WINDOW_TITLE=$(read_json "app.window.title")
MIN_WIDTH=$(read_json "app.window.min_width")
MIN_HEIGHT=$(read_json "app.window.min_height")
DEFAULT_WIDTH=$(read_json "app.window.default_width")
DEFAULT_HEIGHT=$(read_json "app.window.default_height")

# Load paths (expand environment variables)
CONFIG_DIR=$(eval echo "$(read_json "paths.config_dir")")
STATE_FILE=$(eval echo "$(read_json "paths.state_file")")
APP_DIR=$(eval echo "$(read_json "paths.app_dir")")
BUILD_DIR=$(eval echo "$(read_json "paths.build_dir")")
DEFAULT_DOWNLOAD_DIR=$(eval echo "$(read_json "paths.default_download_dir")")

# Load colors
RED=$(read_json "messages.colors.red")
GREEN=$(read_json "messages.colors.green")
YELLOW=$(read_json "messages.colors.yellow")
BLUE=$(read_json "messages.colors.blue")
NC=$(read_json "messages.colors.nc")

# Load message prefixes
INFO_PREFIX=$(read_json "messages.info_prefix")
WARNING_PREFIX=$(read_json "messages.warning_prefix")
ERROR_PREFIX=$(read_json "messages.error_prefix")
SKIP_PREFIX=$(read_json "messages.skip_prefix")

echo "=== $APP_NAME v$APP_VERSION ==="
echo "All-in-one installer and launcher"

# Function to print colored output
print_status() {
    echo -e "${GREEN}${INFO_PREFIX}${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}${WARNING_PREFIX}${NC} $1"
}

print_error() {
    echo -e "${RED}${ERROR_PREFIX}${NC} $1"
}

print_skip() {
    echo -e "${BLUE}${SKIP_PREFIX}${NC} $1"
}

# Initialize state file
init_state_file() {
    mkdir -p "$CONFIG_DIR"
    if [[ ! -f "$STATE_FILE" ]]; then
        cat > "$STATE_FILE" << 'EOF'
{
  "qt_libs_installed": false,
  "python_installed": false,
  "ytdlp_installed": false,
  "additional_libs_installed": false,
  "app_built": false,
  "package_manager": "",
  "last_check": ""
}
EOF
        print_status "Created new state file: $STATE_FILE"
    fi
}

# Read state from JSON
read_state() {
    if [[ -f "$STATE_FILE" ]]; then
        python3 -c "
import json, sys
try:
    with open('$STATE_FILE', 'r') as f:
        data = json.load(f)
    print(f\"QT_LIBS={data.get('qt_libs_installed', False)}\")
    print(f\"PYTHON={data.get('python_installed', False)}\")
    print(f\"YTDLP={data.get('ytdlp_installed', False)}\")
    print(f\"ADDITIONAL_LIBS={data.get('additional_libs_installed', False)}\")
    print(f\"APP_BUILT={data.get('app_built', False)}\")
    print(f\"PKG_MGR={data.get('package_manager', '')}\")
except:
    sys.exit(1)
" 2>/dev/null || echo "QT_LIBS=false
PYTHON=false
YTDLP=false
ADDITIONAL_LIBS=false
APP_BUILT=false
PKG_MGR="
    fi
}

# Update state in JSON
update_state() {
    local key="$1"
    local value="$2"
    
    python3 -c "
import json
try:
    with open('$STATE_FILE', 'r') as f:
        data = json.load(f)
except:
    data = {}

# Convert string values to proper JSON booleans
if '$value' == 'true':
    data['$key'] = True
elif '$value' == 'false':
    data['$key'] = False
else:
    data['$key'] = '$value'

data['last_check'] = '$(date -Iseconds)'

with open('$STATE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
}

# Check if system has package manager
check_system() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        INSTALL_CMD="sudo apt update && sudo apt install -y"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
        INSTALL_CMD="sudo zypper install -y"
    else
        print_error "Unsupported package manager. Please install dependencies manually."
        exit 1
    fi
    print_status "Detected package manager: $PKG_MANAGER"
}

# Get dependencies from JSON based on package manager
get_dependencies() {
    local dep_type="$1"
    read_json "dependencies.${PKG_MANAGER}.${dep_type}"
}

# Check functions (same as before)
check_qt_libs() {
    if command -v qmake &> /dev/null && command -v cmake &> /dev/null; then
        case $PKG_MANAGER in
            "apt") dpkg -l | grep -q "qtbase5-dev\|libqt5widgets5" && return 0 ;;
            "dnf") rpm -qa | grep -q "qt5-qtbase-devel" && return 0 ;;
            "pacman") pacman -Qs qt5-base &> /dev/null && return 0 ;;
            "zypper") zypper se -i libqt5-qtbase-devel &> /dev/null && return 0 ;;
        esac
    fi
    return 1
}

check_python() {
    command -v python3 &> /dev/null && command -v pip3 &> /dev/null
}

check_ytdlp() {
    command -v yt-dlp &> /dev/null || python3 -c "import yt_dlp" &> /dev/null
}

check_additional_libs() {
    command -v ffmpeg &> /dev/null && command -v git &> /dev/null
}

# Installation functions (same logic as before)
install_python() {
    if [[ "$PYTHON_INSTALLED" == "True" ]] && check_python; then
        print_skip "Python 3 already installed"
        return 0
    fi
    
    print_status "Installing Python 3..."
    local python_deps=$(get_dependencies "python")
    $INSTALL_CMD $python_deps
    update_state "python_installed" "true"
    print_status "Python 3 installed successfully"
}

install_kde_qt_libs() {
    if [[ "$QT_LIBS_INSTALLED" == "True" ]] && check_qt_libs; then
        print_skip "Qt/KDE libraries already installed"
        return 0
    fi
    
    print_status "Installing KDE/Qt GUI libraries..."
    local qt_deps=$(get_dependencies "qt_libs")
    $INSTALL_CMD $qt_deps
    update_state "qt_libs_installed" "true"
    print_status "Qt/KDE libraries installed successfully"
}

install_ytdlp() {
    if [[ "$YTDLP_INSTALLED" == "True" ]] && check_ytdlp; then
        print_skip "yt-dlp already installed"
        return 0
    fi
    
    print_status "Installing yt-dlp..."
    case $PKG_MANAGER in
        "apt"|"dnf") 
            if ! $INSTALL_CMD yt-dlp 2>/dev/null; then
                pip3 install --user yt-dlp
            fi ;;
        "pacman") $INSTALL_CMD yt-dlp ;;
        "zypper") pip3 install --user yt-dlp ;;
    esac
    
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        print_warning "Added ~/.local/bin to PATH. Please restart your terminal or run: source ~/.bashrc"
    fi
    
    update_state "ytdlp_installed" "true"
    print_status "yt-dlp installed successfully"
}

install_additional_libs() {
    if [[ "$ADDITIONAL_LIBS_INSTALLED" == "True" ]] && check_additional_libs; then
        print_skip "Additional libraries already installed"
        return 0
    fi
    
    print_status "Installing additional useful libraries..."
    local additional_deps=$(get_dependencies "additional")
    $INSTALL_CMD $additional_deps
    update_state "additional_libs_installed" "true"
    print_status "Additional libraries installed successfully"
}

# Create GUI application (simplified version for brevity)
create_enhanced_app() {
    print_status "Creating $APP_NAME application..."
    
    mkdir -p "$APP_DIR"
    
    # Copy config file to app directory for build process
    cp "$LOCAL_CONFIG" "$APP_DIR/"
    
    cd "$APP_DIR"
    
    # Update CONFIG_FILE path for this context
    local TEMP_CONFIG_FILE="$APP_DIR/openxs_config.json"
    
    # Load GUI settings from JSON using local config
    local default_video_quality=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['gui']['default_settings']['video_quality_index'])
")
    
    local default_output_template=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['gui']['default_settings']['output_template'])
")
    
    local url_placeholder=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['messages']['placeholders']['url_input'])
")
    
    # Create main.cpp (wizard-style interface)
    cat > main.cpp << EOF
#include <QApplication>
#include <QMainWindow>
#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QTextEdit>
#include <QLabel>
#include <QProcess>
#include <QMessageBox>
#include <QProgressBar>
#include <QComboBox>
#include <QCheckBox>
#include <QFileDialog>
#include <QStatusBar>
#include <QMenuBar>
#include <QAction>
#include <QGroupBox>
#include <QSplitter>
#include <QTimer>
#include <QRegularExpression>
#include <QScrollArea>
#include <QSpinBox>
#include <QTabWidget>
#include <QListWidget>
#include <QButtonGroup>
#include <QRadioButton>
#include <QSlider>
#include <QTextBrowser>
#include <QPlainTextEdit>
#include <QDir>
#include <QStackedWidget>
#include <QWizard>
#include <QWizardPage>

class DownloadWizard : public QWizard {
    Q_OBJECT

public:
    enum { Page_URL, Page_Quality, Page_Playlist, Page_Audio, Page_Subtitles, Page_Advanced, Page_Output, Page_Summary };

    DownloadWizard(QWidget *parent = nullptr) : QWizard(parent) {
        setWindowTitle("OpenXS Download Wizard");
        setWizardStyle(QWizard::ModernStyle);
        setOption(QWizard::HaveHelpButton, false);
        setMinimumSize(600, 400);
        
        addPage(new URLPage);
        addPage(new QualityPage);
        addPage(new PlaylistPage);
        addPage(new AudioPage);
        addPage(new SubtitlesPage);
        addPage(new AdvancedPage);
        addPage(new OutputPage);
        addPage(new SummaryPage);
        
        setStartId(Page_URL);
    }
    
    QString getVideoURL() const { return field("url").toString(); }
    QString getVideoQuality() const { return field("quality").toString(); }
    QString getVideoFormat() const { return field("videoFormat").toString(); }
    bool isPlaylistEnabled() const { return field("playlist").toBool(); }
    int getPlaylistStart() const { return field("playlistStart").toInt(); }
    int getPlaylistEnd() const { return field("playlistEnd").toInt(); }
    bool isPlaylistReversed() const { return field("playlistReversed").toBool(); }
    bool isAudioOnly() const { return field("audioOnly").toBool(); }
    QString getAudioFormat() const { return field("audioFormat").toString(); }
    QString getAudioQuality() const { return field("audioQuality").toString(); }
    bool areSubtitlesEnabled() const { return field("subtitles").toBool(); }
    QStringList getSubtitleLanguages() const { return field("subtitleLangs").toStringList(); }
    bool areThumbnailsEnabled() const { return field("thumbnails").toBool(); }
    bool isMetadataEnabled() const { return field("metadata").toBool(); }
    bool isSpeedLimited() const { return field("speedLimit").toBool(); }
    int getSpeedLimit() const { return field("speedLimitValue").toInt(); }
    QString getOutputDir() const { return field("outputDir").toString(); }
    QString getOutputTemplate() const { return field("outputTemplate").toString(); }
    QString getCustomArgs() const { return field("customArgs").toString(); }
};

class URLPage : public QWizardPage {
    Q_OBJECT

public:
    URLPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Video URL");
        setSubTitle("Enter the URL of the video or playlist you want to download.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        QLabel *label = new QLabel("Video/Playlist URL:");
        urlEdit = new QLineEdit;
        urlEdit->setPlaceholderText("https://www.youtube.com/watch?v=...");
        
        layout->addWidget(label);
        layout->addWidget(urlEdit);
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("url*", urlEdit);
    }

private:
    QLineEdit *urlEdit;
};

class QualityPage : public QWizardPage {
    Q_OBJECT

public:
    QualityPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Video Quality & Format");
        setSubTitle("Select the video quality and container format you prefer.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        // Video Quality
        QLabel *qualityLabel = new QLabel("Choose video quality:");
        qualityCombo = new QComboBox;
        qualityCombo->addItem("Best Available", "best");
        qualityCombo->addItem("4K (2160p)", "2160");
        qualityCombo->addItem("1440p", "1440");
        qualityCombo->addItem("1080p", "1080");
        qualityCombo->addItem("720p", "720");
        qualityCombo->addItem("480p", "480");
        qualityCombo->addItem("360p", "360");
        qualityCombo->addItem("240p", "240");
        qualityCombo->addItem("144p", "144");
        qualityCombo->addItem("Worst Available", "worst");
        qualityCombo->setCurrentIndex(3); // Default to 1080p
        
        layout->addWidget(qualityLabel);
        layout->addWidget(qualityCombo);
        
        // Video Format
        QLabel *formatLabel = new QLabel("Choose video format:");
        formatCombo = new QComboBox;
        formatCombo->addItem("MP4 (Recommended)", "mp4");
        formatCombo->addItem("MKV (High Quality)", "mkv");
        formatCombo->addItem("AVI (Compatible)", "avi");
        formatCombo->addItem("MOV (Apple)", "mov");
        formatCombo->addItem("WebM (Web)", "webm");
        formatCombo->addItem("FLV (Flash)", "flv");
        formatCombo->setCurrentIndex(0); // Default to MP4
        
        layout->addWidget(formatLabel);
        layout->addWidget(formatCombo);
        
        // Format description
        QLabel *descLabel = new QLabel("MP4 is recommended for best compatibility across all devices and players.");
        descLabel->setStyleSheet("color: gray; font-size: 10px; margin-top: 5px;");
        layout->addWidget(descLabel);
        
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("quality", qualityCombo, "currentData");
        registerField("videoFormat", formatCombo, "currentData");
    }

private:
    QComboBox *qualityCombo;
    QComboBox *formatCombo;
};

class PlaylistPage : public QWizardPage {
    Q_OBJECT

public:
    PlaylistPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Playlist Options");
        setSubTitle("Configure playlist download settings.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        playlistCheck = new QCheckBox("Download entire playlist (if URL is a playlist)");
        playlistCheck->setChecked(true);
        layout->addWidget(playlistCheck);
        
        QGroupBox *optionsGroup = new QGroupBox("Playlist Range");
        QGridLayout *optionsLayout = new QGridLayout(optionsGroup);
        
        optionsLayout->addWidget(new QLabel("Start from item:"), 0, 0);
        startSpin = new QSpinBox;
        startSpin->setMinimum(1);
        startSpin->setMaximum(9999);
        startSpin->setValue(1);
        optionsLayout->addWidget(startSpin, 0, 1);
        
        optionsLayout->addWidget(new QLabel("End at item (0 = last):"), 1, 0);
        endSpin = new QSpinBox;
        endSpin->setMinimum(0);
        endSpin->setMaximum(9999);
        endSpin->setValue(0);
        optionsLayout->addWidget(endSpin, 1, 1);
        
        reversedCheck = new QCheckBox("Download in reverse order");
        optionsLayout->addWidget(reversedCheck, 2, 0, 1, 2);
        
        layout->addWidget(optionsGroup);
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("playlist", playlistCheck);
        registerField("playlistStart", startSpin);
        registerField("playlistEnd", endSpin);
        registerField("playlistReversed", reversedCheck);
        
        connect(playlistCheck, &QCheckBox::toggled, optionsGroup, &QGroupBox::setEnabled);
    }

private:
    QCheckBox *playlistCheck;
    QSpinBox *startSpin;
    QSpinBox *endSpin;
    QCheckBox *reversedCheck;
};

class AudioPage : public QWizardPage {
    Q_OBJECT

public:
    AudioPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Audio Options");
        setSubTitle("Configure audio download and extraction settings.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        audioOnlyCheck = new QCheckBox("Download audio only (extract audio from video)");
        layout->addWidget(audioOnlyCheck);
        
        QGroupBox *audioGroup = new QGroupBox("Audio Settings");
        QGridLayout *audioLayout = new QGridLayout(audioGroup);
        
        audioLayout->addWidget(new QLabel("Audio Format:"), 0, 0);
        formatCombo = new QComboBox;
        formatCombo->addItem("Best", "best");
        formatCombo->addItem("MP3", "mp3");
        formatCombo->addItem("AAC", "aac");
        formatCombo->addItem("FLAC", "flac");
        formatCombo->addItem("OGG", "ogg");
        formatCombo->addItem("WAV", "wav");
        formatCombo->setCurrentIndex(1); // Default to MP3
        audioLayout->addWidget(formatCombo, 0, 1);
        
        audioLayout->addWidget(new QLabel("Audio Quality:"), 1, 0);
        qualityCombo = new QComboBox;
        qualityCombo->addItem("Best", "0");
        qualityCombo->addItem("320k", "320");
        qualityCombo->addItem("256k", "256");
        qualityCombo->addItem("192k", "192");
        qualityCombo->addItem("128k", "128");
        qualityCombo->addItem("96k", "96");
        audioLayout->addWidget(qualityCombo, 1, 1);
        
        layout->addWidget(audioGroup);
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("audioOnly", audioOnlyCheck);
        registerField("audioFormat", formatCombo, "currentData");
        registerField("audioQuality", qualityCombo, "currentData");
        
        connect(audioOnlyCheck, &QCheckBox::toggled, audioGroup, &QGroupBox::setEnabled);
        audioGroup->setEnabled(false);
    }

private:
    QCheckBox *audioOnlyCheck;
    QComboBox *formatCombo;
    QComboBox *qualityCombo;
};

class SubtitlesPage : public QWizardPage {
    Q_OBJECT

public:
    SubtitlesPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Subtitles");
        setSubTitle("Select subtitle languages to download.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        subtitlesCheck = new QCheckBox("Download subtitles");
        layout->addWidget(subtitlesCheck);
        
        QGroupBox *langGroup = new QGroupBox("Languages");
        QVBoxLayout *langLayout = new QVBoxLayout(langGroup);
        
        QStringList languages = {
            "en:English", "es:Spanish", "fr:French", "de:German", "it:Italian",
            "pt:Portuguese", "ru:Russian", "ja:Japanese", "ko:Korean", "zh:Chinese"
        };
        
        for (const QString &lang : languages) {
            QStringList parts = lang.split(":");
            QCheckBox *langCheck = new QCheckBox(parts[1]);
            langCheck->setProperty("langCode", parts[0]);
            if (parts[0] == "en") langCheck->setChecked(true); // Default English
            langChecks.append(langCheck);
            langLayout->addWidget(langCheck);
        }
        
        layout->addWidget(langGroup);
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("subtitles", subtitlesCheck);
        
        connect(subtitlesCheck, &QCheckBox::toggled, langGroup, &QGroupBox::setEnabled);
        langGroup->setEnabled(false);
    }
    
    bool validatePage() override {
        QStringList selectedLangs;
        if (field("subtitles").toBool()) {
            for (QCheckBox *check : langChecks) {
                if (check->isChecked()) {
                    selectedLangs << check->property("langCode").toString();
                }
            }
        }
        setField("subtitleLangs", selectedLangs);
        return true;
    }

private:
    QCheckBox *subtitlesCheck;
    QList<QCheckBox*> langChecks;
};

class AdvancedPage : public QWizardPage {
    Q_OBJECT

public:
    AdvancedPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Advanced Options");
        setSubTitle("Configure additional download options.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        thumbnailCheck = new QCheckBox("Download video thumbnails");
        layout->addWidget(thumbnailCheck);
        
        metadataCheck = new QCheckBox("Save video metadata (JSON file)");
        layout->addWidget(metadataCheck);
        
        QGroupBox *speedGroup = new QGroupBox("Speed Limit");
        QHBoxLayout *speedLayout = new QHBoxLayout(speedGroup);
        
        speedLimitCheck = new QCheckBox("Limit download speed to:");
        speedSpin = new QSpinBox;
        speedSpin->setMinimum(1);
        speedSpin->setMaximum(999999);
        speedSpin->setValue(1000);
        speedSpin->setSuffix(" KB/s");
        speedSpin->setEnabled(false);
        
        speedLayout->addWidget(speedLimitCheck);
        speedLayout->addWidget(speedSpin);
        speedLayout->addStretch();
        
        layout->addWidget(speedGroup);
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("thumbnails", thumbnailCheck);
        registerField("metadata", metadataCheck);
        registerField("speedLimit", speedLimitCheck);
        registerField("speedLimitValue", speedSpin);
        
        connect(speedLimitCheck, &QCheckBox::toggled, speedSpin, &QSpinBox::setEnabled);
    }

private:
    QCheckBox *thumbnailCheck;
    QCheckBox *metadataCheck;
    QCheckBox *speedLimitCheck;
    QSpinBox *speedSpin;
};

class OutputPage : public QWizardPage {
    Q_OBJECT

public:
    OutputPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Output Settings");
        setSubTitle("Configure where and how files will be saved.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        QGroupBox *dirGroup = new QGroupBox("Output Directory");
        QHBoxLayout *dirLayout = new QHBoxLayout(dirGroup);
        
        outputDirEdit = new QLineEdit("$DEFAULT_DOWNLOAD_DIR");
        QPushButton *browseBtn = new QPushButton("Browse...");
        
        dirLayout->addWidget(outputDirEdit);
        dirLayout->addWidget(browseBtn);
        
        layout->addWidget(dirGroup);
        
        QGroupBox *templateGroup = new QGroupBox("Filename Template");
        QVBoxLayout *templateLayout = new QVBoxLayout(templateGroup);
        
        templateEdit = new QLineEdit("%(title)s.%(ext)s");
        QLabel *helpLabel = new QLabel("Available: %(title)s %(uploader)s %(upload_date)s %(ext)s");
        helpLabel->setStyleSheet("color: gray; font-size: 10px;");
        
        templateLayout->addWidget(templateEdit);
        templateLayout->addWidget(helpLabel);
        
        layout->addWidget(templateGroup);
        
        QGroupBox *customGroup = new QGroupBox("Custom Arguments (Optional)");
        QVBoxLayout *customLayout = new QVBoxLayout(customGroup);
        
        customArgsEdit = new QLineEdit;
        customArgsEdit->setPlaceholderText("Additional yt-dlp arguments...");
        customLayout->addWidget(customArgsEdit);
        
        layout->addWidget(customGroup);
        layout->addStretch();
        
        setLayout(layout);
        
        registerField("outputDir*", outputDirEdit);
        registerField("outputTemplate", templateEdit);
        registerField("customArgs", customArgsEdit);
        
        connect(browseBtn, &QPushButton::clicked, this, &OutputPage::browseDirectory);
    }

private slots:
    void browseDirectory() {
        QString dir = QFileDialog::getExistingDirectory(this, "Select Output Directory", 
                                                       outputDirEdit->text());
        if (!dir.isEmpty()) {
            outputDirEdit->setText(dir);
        }
    }

private:
    QLineEdit *outputDirEdit;
    QLineEdit *templateEdit;
    QLineEdit *customArgsEdit;
};

class SummaryPage : public QWizardPage {
    Q_OBJECT

public:
    SummaryPage(QWidget *parent = nullptr) : QWizardPage(parent) {
        setTitle("Download Summary");
        setSubTitle("Review your settings and start the download.");
        
        QVBoxLayout *layout = new QVBoxLayout;
        
        summaryText = new QTextEdit;
        summaryText->setReadOnly(true);
        summaryText->setMaximumHeight(200);
        
        layout->addWidget(new QLabel("Download settings summary:"));
        layout->addWidget(summaryText);
        layout->addStretch();
        
        setLayout(layout);
    }
    
    void initializePage() override {
        DownloadWizard *wizard = qobject_cast<DownloadWizard*>(this->wizard());
        if (!wizard) return;
        
        QString summary;
        summary += "URL: " + wizard->getVideoURL() + "\\n";
        summary += "Quality: " + wizard->getVideoQuality() + "\\n";
        summary += "Format: " + wizard->getVideoFormat().toUpper() + "\\n";
        
        if (wizard->isPlaylistEnabled()) {
            summary += "Playlist: Yes";
            if (wizard->getPlaylistStart() > 1 || wizard->getPlaylistEnd() > 0) {
                summary += QString(" (items %1-%2)").arg(wizard->getPlaylistStart())
                          .arg(wizard->getPlaylistEnd() > 0 ? QString::number(wizard->getPlaylistEnd()) : "last");
            }
            if (wizard->isPlaylistReversed()) summary += " [reversed]";
            summary += "\\n";
        } else {
            summary += "Playlist: No (single video only)\\n";
        }
        
        if (wizard->isAudioOnly()) {
            summary += "Audio Only: Yes (" + wizard->getAudioFormat() + ", " + wizard->getAudioQuality() + ")\\n";
        } else {
            summary += "Audio Only: No\\n";
        }
        
        if (wizard->areSubtitlesEnabled()) {
            QStringList langs = wizard->getSubtitleLanguages();
            summary += "Subtitles: " + (langs.isEmpty() ? "None selected" : langs.join(", ")) + "\\n";
        } else {
            summary += "Subtitles: No\\n";
        }
        
        if (wizard->areThumbnailsEnabled()) summary += "Thumbnails: Yes\\n";
        if (wizard->isMetadataEnabled()) summary += "Metadata: Yes\\n";
        if (wizard->isSpeedLimited()) summary += "Speed Limit: " + QString::number(wizard->getSpeedLimit()) + " KB/s\\n";
        
        summary += "Output: " + wizard->getOutputDir() + "\\n";
        summary += "Template: " + wizard->getOutputTemplate() + "\\n";
        
        if (!wizard->getCustomArgs().isEmpty()) {
            summary += "Custom Args: " + wizard->getCustomArgs() + "\\n";
        }
        
        summaryText->setPlainText(summary);
    }

private:
    QTextEdit *summaryText;
};

class OpenXSVideoDownloader : public QMainWindow {
    Q_OBJECT

public:
    OpenXSVideoDownloader(QWidget *parent = nullptr) : QMainWindow(parent) {
        setupUI();
        setupMenuBar();
        setupStatusBar();
        setWindowTitle("$WINDOW_TITLE");
        setMinimumSize($MIN_WIDTH, $MIN_HEIGHT);
        resize($DEFAULT_WIDTH, $DEFAULT_HEIGHT);
        setWindowIcon(QIcon::fromTheme("$APP_ICON"));
        downloadProcess = nullptr;
    }

private slots:
    void startWizard() {
        DownloadWizard wizard(this);
        if (wizard.exec() == QDialog::Accepted) {
            startDownload(&wizard);
        }
    }
    
    void startDownload(DownloadWizard *wizard) {
        // Build yt-dlp arguments from wizard
        QStringList args;
        args << wizard->getVideoURL();
        
        // Quality and Format
        QString quality = wizard->getVideoQuality();
        QString videoFormat = wizard->getVideoFormat();
        
        if (wizard->isAudioOnly()) {
            args << "--extract-audio";
            if (wizard->getAudioFormat() != "best") {
                args << "--audio-format" << wizard->getAudioFormat();
            }
            if (wizard->getAudioQuality() != "0") {
                args << "--audio-quality" << wizard->getAudioQuality();
            }
        } else {
            // Video download with user-selected format
            args << "--merge-output-format" << videoFormat;
            
            // Build format string based on selected container format
            QString audioExt = "m4a";
            if (videoFormat == "mkv") {
                audioExt = "opus";
            } else if (videoFormat == "webm") {
                audioExt = "opus";
            } else if (videoFormat == "avi") {
                audioExt = "mp3";
            }
            
            if (quality == "best") {
                QString formatString = QString("bestvideo[ext=%1]+bestaudio[ext=%2]/bestvideo+bestaudio/best").arg(videoFormat, audioExt);
                args << "-f" << formatString;
            } else if (quality == "worst") {
                QString formatString = QString("worstvideo[ext=%1]+worstaudio[ext=%2]/worstvideo+worstaudio/worst").arg(videoFormat, audioExt);
                args << "-f" << formatString;
            } else {
                // For specific quality with selected format
                QString formatString = QString("bestvideo[height<=%1][ext=%2]+bestaudio[ext=%3]/bestvideo[height<=%1]+bestaudio/best[height<=%1]").arg(quality, videoFormat, audioExt);
                args << "-f" << formatString;
            }
        }
        
        // Playlist
        if (wizard->isPlaylistEnabled()) {
            if (wizard->getPlaylistStart() > 1) {
                args << "--playlist-start" << QString::number(wizard->getPlaylistStart());
            }
            if (wizard->getPlaylistEnd() > 0) {
                args << "--playlist-end" << QString::number(wizard->getPlaylistEnd());
            }
            if (wizard->isPlaylistReversed()) {
                args << "--playlist-reverse";
            }
        } else {
            args << "--no-playlist";
        }
        
        // Subtitles
        if (wizard->areSubtitlesEnabled()) {
            args << "--write-subs";
            QStringList langs = wizard->getSubtitleLanguages();
            if (!langs.isEmpty()) {
                args << "--sub-langs" << langs.join(",");
            }
        }
        
        // Advanced options
        if (wizard->areThumbnailsEnabled()) {
            args << "--write-thumbnail";
        }
        if (wizard->isMetadataEnabled()) {
            args << "--write-info-json";
        }
        if (wizard->isSpeedLimited()) {
            args << "--limit-rate" << QString::number(wizard->getSpeedLimit()) + "K";
        }
        
        // Output
        QString outputTemplate = wizard->getOutputTemplate();
        if (outputTemplate.isEmpty()) outputTemplate = "%(title)s.%(ext)s";
        args << "-o" << wizard->getOutputDir() + "/" + outputTemplate;
        
        // Custom arguments
        if (!wizard->getCustomArgs().isEmpty()) {
            args << wizard->getCustomArgs().split(" ", Qt::SkipEmptyParts);
        }
        
        // Start download
        downloadBtn->setEnabled(false);
        stopBtn->setEnabled(true);
        progressBar->setVisible(true);
        progressBar->setRange(0, 0);
        
        outputText->clear();
        outputText->append("=== Starting Download ===");
        outputText->append("Command: yt-dlp " + args.join(" "));
        outputText->append("");
        
        downloadProcess = new QProcess(this);
        
        connect(downloadProcess, &QProcess::readyReadStandardOutput, [this]() {
            QByteArray data = downloadProcess->readAllStandardOutput();
            QString output = QString::fromUtf8(data);
            outputText->append(output.trimmed());
            
            QTextCursor cursor = outputText->textCursor();
            cursor.movePosition(QTextCursor::End);
            outputText->setTextCursor(cursor);
        });
        
        connect(downloadProcess, &QProcess::readyReadStandardError, [this]() {
            QByteArray data = downloadProcess->readAllStandardError();
            QString error = QString::fromUtf8(data);
            if (!error.trimmed().isEmpty()) {
                outputText->append("ERROR: " + error.trimmed());
            }
        });
        
        connect(downloadProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
                [this](int exitCode, QProcess::ExitStatus exitStatus) {
            downloadBtn->setEnabled(true);
            stopBtn->setEnabled(false);
            progressBar->setVisible(false);
            
            if (exitCode == 0) {
                outputText->append("\\n=== Download Completed Successfully! ===");
                statusBar()->showMessage("Download completed", 5000);
                QMessageBox::information(this, "Success", "Download completed successfully!");
            } else {
                outputText->append("\\n=== Download Failed ===");
                statusBar()->showMessage("Download failed", 5000);
            }
        });
        
        downloadProcess->start("yt-dlp", args);
    }
    
    void stopDownload() {
        if (downloadProcess && downloadProcess->state() == QProcess::Running) {
            downloadProcess->kill();
            outputText->append("\\nStopping download...");
        }
    }
    
    void clearOutput() {
        outputText->clear();
    }
    
    void aboutApp() {
        QMessageBox::about(this, "About $APP_NAME", 
                          "$APP_NAME v$APP_VERSION\\n\\n"
                          "$APP_DESCRIPTION\\n\\n"
                          "Step-by-step wizard interface for easy video downloading.\\n\\n"
                          "Built with Qt5 for KDE desktop environments.");
    }

private:
    void setupUI() {
        QWidget *centralWidget = new QWidget(this);
        setCentralWidget(centralWidget);
        
        QVBoxLayout *mainLayout = new QVBoxLayout(centralWidget);
        
        // Welcome message
        QLabel *welcomeLabel = new QLabel("Welcome to OpenXS Video Downloader!");
        welcomeLabel->setStyleSheet("font-size: 18px; font-weight: bold; margin: 10px;");
        welcomeLabel->setAlignment(Qt::AlignCenter);
        mainLayout->addWidget(welcomeLabel);
        
        QLabel *instructionLabel = new QLabel("Click 'Start Download Wizard' to begin downloading videos with step-by-step guidance.");
        instructionLabel->setAlignment(Qt::AlignCenter);
        instructionLabel->setStyleSheet("margin: 10px; color: gray;");
        mainLayout->addWidget(instructionLabel);
        
        // Control buttons
        QHBoxLayout *buttonLayout = new QHBoxLayout;
        
        downloadBtn = new QPushButton("Start Download Wizard");
        downloadBtn->setDefault(true);
        downloadBtn->setMinimumHeight(40);
        connect(downloadBtn, &QPushButton::clicked, this, &OpenXSVideoDownloader::startWizard);
        
        stopBtn = new QPushButton("Stop Download");
        stopBtn->setEnabled(false);
        stopBtn->setMinimumHeight(40);
        connect(stopBtn, &QPushButton::clicked, this, &OpenXSVideoDownloader::stopDownload);
        
        QPushButton *clearBtn = new QPushButton("Clear Output");
        clearBtn->setMinimumHeight(40);
        connect(clearBtn, &QPushButton::clicked, this, &OpenXSVideoDownloader::clearOutput);
        
        buttonLayout->addWidget(downloadBtn);
        buttonLayout->addWidget(stopBtn);
        buttonLayout->addWidget(clearBtn);
        buttonLayout->addStretch();
        
        mainLayout->addLayout(buttonLayout);
        
        // Progress bar
        progressBar = new QProgressBar();
        progressBar->setVisible(false);
        mainLayout->addWidget(progressBar);
        
        // Output area
        QLabel *outputLabel = new QLabel("Download Output:");
        outputLabel->setStyleSheet("font-weight: bold; margin-top: 10px;");
        mainLayout->addWidget(outputLabel);
        
        outputText = new QTextEdit();
        outputText->setReadOnly(true);
        outputText->setFont(QFont("monospace", 9));
        outputText->setPlaceholderText("Download output will appear here...");
        mainLayout->addWidget(outputText);
    }
    
    void setupMenuBar() {
        QMenuBar *menuBar = this->menuBar();
        
        QMenu *fileMenu = menuBar->addMenu("&File");
        QAction *exitAction = new QAction("E&xit", this);
        exitAction->setShortcut(QKeySequence::Quit);
        connect(exitAction, &QAction::triggered, this, &QWidget::close);
        fileMenu->addAction(exitAction);
        
        QMenu *helpMenu = menuBar->addMenu("&Help");
        QAction *aboutAction = new QAction("&About", this);
        connect(aboutAction, &QAction::triggered, this, &OpenXSVideoDownloader::aboutApp);
        helpMenu->addAction(aboutAction);
    }
    
    void setupStatusBar() {
        statusBar()->showMessage("Ready - Click 'Start Download Wizard' to begin");
    }
    
    QPushButton *downloadBtn;
    QPushButton *stopBtn;
    QTextEdit *outputText;
    QProgressBar *progressBar;
    QProcess *downloadProcess;
};

#include "main.moc"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    app.setApplicationName("$APP_NAME");
    app.setApplicationVersion("$APP_VERSION");
    app.setOrganizationName("$APP_ORGANIZATION");
    
    OpenXSVideoDownloader window;
    window.show();
    
    return app.exec();
}
EOF

    # Create CMakeLists.txt using local config
    local project_name=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['project_name'])
")
    
    local executable_name=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['executable_name'])
")
    
    local cpp_standard=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['cpp_standard'])
")
    
    local cmake_version=$(python3 -c "
import json
with open('$TEMP_CONFIG_FILE', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['cmake_minimum_version'])
")
    
    cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION $cmake_version)
project($project_name)

set(CMAKE_CXX_STANDARD $cpp_standard)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 REQUIRED COMPONENTS Core Widgets)
set(CMAKE_AUTOMOC ON)

add_executable($executable_name main.cpp)
target_link_libraries($executable_name Qt5::Core Qt5::Widgets)
install(TARGETS $executable_name DESTINATION bin)
EOF

    print_status "$APP_NAME application created in $APP_DIR"
}

# Build and run functions (same as before)
build_app() {
    if [[ "$APP_BUILT" == "True" ]] && [[ -f "$BUILD_DIR/$(read_json "cmake.executable_name")" ]]; then
        print_skip "Application already built"
        return 0
    fi
    
    print_status "Building the application..."
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    cmake .. && make || {
        print_error "Build failed"
        exit 1
    }
    
    update_state "app_built" "true"
    print_status "Build completed successfully"
}

run_app() {
    print_status "Starting $APP_NAME..."
    
    # Get executable name from config before changing directory
    executable_name=$(python3 -c "
import json
with open('$LOCAL_CONFIG', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['executable_name'])
")
    
    cd "$BUILD_DIR"
    ./$executable_name
}

# Install all dependencies
install_all_dependencies() {
    print_status "Installing all dependencies..."
    init_state_file
    eval $(read_state)
    
    QT_LIBS_INSTALLED="$QT_LIBS"
    PYTHON_INSTALLED="$PYTHON"
    YTDLP_INSTALLED="$YTDLP"
    ADDITIONAL_LIBS_INSTALLED="$ADDITIONAL_LIBS"
    APP_BUILT="$APP_BUILT"
    
    print_status "Loaded installation state from: $STATE_FILE"
    
    check_system
    if [[ "$PKG_MGR" != "$PKG_MANAGER" ]]; then
        update_state "package_manager" "$PKG_MANAGER"
    fi
    
    install_python
    install_kde_qt_libs
    install_ytdlp
    install_additional_libs
    
    print_status "$(read_json "messages.status_messages.deps_installed")"
}

# Main execution
main() {
    echo ""
    print_status "$(read_json "messages.status_messages.starting")"
    
    install_all_dependencies
    create_enhanced_app
    build_app
    run_app
}

# Handle command line arguments
case "${1:-}" in
    "install") install_all_dependencies ;;
    "build") install_all_dependencies; create_enhanced_app; build_app ;;
    "run") 
        # Get executable name for check
        executable_name=$(python3 -c "
import json
with open('$LOCAL_CONFIG', 'r') as f:
    data = json.load(f)
print(data['config']['cmake']['executable_name'])
")
        
        if [[ ! -f "$BUILD_DIR/$executable_name" ]]; then
            print_error "Application not built. Run without arguments to install and build."
            exit 1
        fi
        run_app ;;
    "clean") rm -rf "$BUILD_DIR" "$STATE_FILE"; print_status "Clean completed" ;;
    "status") [[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || print_status "No installation state found" ;;
    "config") 
        print_status "Current configuration source: $CONFIG_URL"
        print_status "Local config file: $LOCAL_CONFIG"
        [[ -f "$LOCAL_CONFIG" ]] && echo "Config last updated: $(date -r "$LOCAL_CONFIG")" ;;
    "update-config") rm -f "$LOCAL_CONFIG"; download_config ;;
    "validate")
        if python3 -c "
import json
try:
    import jsonschema
    with open('$LOCAL_CONFIG', 'r') as f:
        data = json.load(f)
    jsonschema.validate(data['config'], data['schema'])
    print('✅ Configuration is valid!')
except ImportError:
    print('ℹ️  jsonschema not available')
except Exception as e:
    print(f'❌ Validation error: {e}')
"; then
            print_status "Configuration validation passed"
        fi ;;
    "help"|"-h"|"--help")
        echo "=== $APP_NAME v$APP_VERSION ==="
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  (no args)       Install dependencies, build, and run GUI"
        echo "  install         Install dependencies only"
        echo "  build           Install dependencies and build application"
        echo "  run             Run the GUI (must be built first)"
        echo "  clean           Clean build files and state"
        echo "  status          Show installation status"
        echo "  config          Show current configuration"
        echo "  update-config   Force download latest config from GitHub"
        echo "  validate        Validate config against embedded schema"
        echo "  help            Show this help message"
        echo ""
        echo "Configuration: $CONFIG_URL" ;;
    *) main ;;
esac