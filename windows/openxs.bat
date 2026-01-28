@echo off
REM OpenXS Video Downloader - Windows Main Script
REM Simple GUI launcher for yt-dlp with wizard interface

setlocal enabledelayedexpansion

REM Configuration
set "APP_NAME=OpenXS Video Downloader"
set "CONFIG_FILE=openxs_config.json"

REM Check if config file exists
if not exist "%CONFIG_FILE%" (
    echo [ERROR] Configuration file not found: %CONFIG_FILE%
    echo [INFO] Please run install.bat first
    pause
    exit /b 1
)

REM Check if yt-dlp is available
yt-dlp --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] yt-dlp is not installed or not in PATH
    echo [INFO] Please run install.bat first
    pause
    exit /b 1
)

REM Handle command line arguments
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="help" goto :show_help

REM Launch GUI (simplified Windows version)
echo ===================================
echo   %APP_NAME%
echo ===================================
echo.
echo Welcome to OpenXS Video Downloader!
echo This is the Windows command-line version.
echo.

:main_menu
echo Please choose an option:
echo 1. Download single video
echo 2. Download playlist
echo 3. Audio-only download
echo 4. Exit
echo.
set /p "choice=Enter your choice (1-4): "

if "%choice%"=="1" goto :single_video
if "%choice%"=="2" goto :playlist
if "%choice%"=="3" goto :audio_only
if "%choice%"=="4" goto :exit
echo Invalid choice. Please try again.
echo.
goto :main_menu

:single_video
echo.
echo === Single Video Download ===
set /p "url=Enter video URL: "
if "%url%"=="" (
    echo Error: URL cannot be empty
    goto :main_menu
)

echo.
echo Choose video quality:
echo 1. Best Available
echo 2. 1080p
echo 3. 720p
echo 4. 480p
set /p "quality_choice=Enter choice (1-4): "

set "quality=best"
if "%quality_choice%"=="2" set "quality=1080"
if "%quality_choice%"=="3" set "quality=720"
if "%quality_choice%"=="4" set "quality=480"

echo.
echo Choose video format:
echo 1. MP4 (Recommended)
echo 2. MKV (High Quality)
echo 3. AVI (Compatible)
echo 4. WebM (Web)
set /p "format_choice=Enter choice (1-4): "

set "format=mp4"
if "%format_choice%"=="2" set "format=mkv"
if "%format_choice%"=="3" set "format=avi"
if "%format_choice%"=="4" set "format=webm"

echo.
set /p "output_dir=Enter output directory (or press Enter for Downloads): "
if "%output_dir%"=="" set "output_dir=%USERPROFILE%\Downloads"

echo.
echo === Starting Download ===
echo URL: %url%
echo Quality: %quality%
echo Format: %format%
echo Output: %output_dir%
echo.

REM Build yt-dlp command
set "cmd=yt-dlp "%url%" --merge-output-format %format%"

if "%quality%"=="best" (
    set "cmd=!cmd! -f "bestvideo[ext=%format%]+bestaudio/bestvideo+bestaudio/best""
) else (
    set "cmd=!cmd! -f "bestvideo[height<=%quality%][ext=%format%]+bestaudio/bestvideo[height<=%quality%]+bestaudio/best[height<=%quality%]""
)

set "cmd=!cmd! -o "%output_dir%\%%(title)s.%%(ext)s""

echo Command: !cmd!
echo.
!cmd!

if errorlevel 1 (
    echo.
    echo === Download Failed ===
) else (
    echo.
    echo === Download Completed Successfully! ===
)

echo.
pause
goto :main_menu

:playlist
echo.
echo === Playlist Download ===
set /p "url=Enter playlist URL: "
if "%url%"=="" (
    echo Error: URL cannot be empty
    goto :main_menu
)

echo.
echo Choose video quality:
echo 1. Best Available
echo 2. 1080p
echo 3. 720p
echo 4. 480p
set /p "quality_choice=Enter choice (1-4): "

set "quality=best"
if "%quality_choice%"=="2" set "quality=1080"
if "%quality_choice%"=="3" set "quality=720"
if "%quality_choice%"=="4" set "quality=480"

echo.
echo Choose video format:
echo 1. MP4 (Recommended)
echo 2. MKV (High Quality)
echo 3. AVI (Compatible)
echo 4. WebM (Web)
set /p "format_choice=Enter choice (1-4): "

set "format=mp4"
if "%format_choice%"=="2" set "format=mkv"
if "%format_choice%"=="3" set "format=avi"
if "%format_choice%"=="4" set "format=webm"

echo.
set /p "output_dir=Enter output directory (or press Enter for Downloads): "
if "%output_dir%"=="" set "output_dir=%USERPROFILE%\Downloads"

echo.
echo === Starting Playlist Download ===
echo URL: %url%
echo Quality: %quality%
echo Format: %format%
echo Output: %output_dir%
echo.

REM Build yt-dlp command for playlist
set "cmd=yt-dlp "%url%" --merge-output-format %format%"

if "%quality%"=="best" (
    set "cmd=!cmd! -f "bestvideo[ext=%format%]+bestaudio/bestvideo+bestaudio/best""
) else (
    set "cmd=!cmd! -f "bestvideo[height<=%quality%][ext=%format%]+bestaudio/bestvideo[height<=%quality%]+bestaudio/best[height<=%quality%]""
)

set "cmd=!cmd! -o "%output_dir%\%%(playlist_title)s\%%(title)s.%%(ext)s""

echo Command: !cmd!
echo.
!cmd!

if errorlevel 1 (
    echo.
    echo === Download Failed ===
) else (
    echo.
    echo === Download Completed Successfully! ===
)

echo.
pause
goto :main_menu

:audio_only
echo.
echo === Audio-Only Download ===
set /p "url=Enter video URL: "
if "%url%"=="" (
    echo Error: URL cannot be empty
    goto :main_menu
)

echo.
echo Choose audio format:
echo 1. MP3 (Most Compatible)
echo 2. AAC (Good Quality)
echo 3. FLAC (Lossless)
echo 4. OGG (Open Source)
set /p "audio_choice=Enter choice (1-4): "

set "audio_format=mp3"
if "%audio_choice%"=="2" set "audio_format=aac"
if "%audio_choice%"=="3" set "audio_format=flac"
if "%audio_choice%"=="4" set "audio_format=ogg"

echo.
set /p "output_dir=Enter output directory (or press Enter for Downloads): "
if "%output_dir%"=="" set "output_dir=%USERPROFILE%\Downloads"

echo.
echo === Starting Audio Download ===
echo URL: %url%
echo Format: %audio_format%
echo Output: %output_dir%
echo.

yt-dlp "%url%" --extract-audio --audio-format %audio_format% -o "%output_dir%\%%(title)s.%%(ext)s"

if errorlevel 1 (
    echo.
    echo === Download Failed ===
) else (
    echo.
    echo === Download Completed Successfully! ===
)

echo.
pause
goto :main_menu

:show_help
echo.
echo OpenXS Video Downloader - Windows Version
echo.
echo Usage: %~nx0 [options]
echo.
echo Options:
echo   --help, -h     Show this help message
echo.
echo Features:
echo   • Single video downloads
echo   • Playlist downloads
echo   • Audio-only extraction
echo   • Multiple format support (MP4, MKV, AVI, WebM)
echo   • Quality selection
echo.
echo For more information, visit:
echo https://github.com/PratikKun/OpenXS-gui-for-yt_dlp
echo.
pause
exit /b 0

:exit
echo.
echo Thank you for using OpenXS Video Downloader!
exit /b 0