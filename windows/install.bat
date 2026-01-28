@echo off
REM OpenXS Video Downloader - Windows Installer
REM Installs dependencies and builds the application on Windows

setlocal enabledelayedexpansion

echo ===================================
echo   OpenXS Video Downloader Setup   
echo ===================================
echo.

REM Configuration
set "APP_NAME=OpenXS Video Downloader"
set "BINARY_NAME=yt-dlp-xs.exe"
set "CONFIG_URL=https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/openxs_config.json"
set "SCRIPT_URL=https://raw.githubusercontent.com/PratikKun/OpenXS-gui-for-yt_dlp/main/windows/openxs.bat"
set "INSTALL_DIR=%LOCALAPPDATA%\OpenXS"
set "DESKTOP_DIR=%USERPROFILE%\Desktop"

echo [INFO] Starting OpenXS Video Downloader installation...
echo.

REM Create installation directory
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
    echo [INFO] Created installation directory: %INSTALL_DIR%
)

REM Check for required tools
echo [INFO] Checking for required dependencies...

REM Check for Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo [INFO] Please install Python from https://python.org
    echo [INFO] Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
) else (
    echo [INFO] Python is available
)

REM Check for Git (optional)
git --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Git is not installed - will download files directly
) else (
    echo [INFO] Git is available
)

REM Install yt-dlp
echo [INFO] Installing yt-dlp...
pip install --user yt-dlp
if errorlevel 1 (
    echo [ERROR] Failed to install yt-dlp
    pause
    exit /b 1
)

REM Install FFmpeg (using yt-dlp's bundled version)
echo [INFO] Installing FFmpeg...
pip install --user ffmpeg-python
if errorlevel 1 (
    echo [WARNING] Failed to install ffmpeg-python, continuing anyway...
)

REM Download configuration
echo [INFO] Downloading configuration...
powershell -Command "Invoke-WebRequest -Uri '%CONFIG_URL%' -OutFile '%INSTALL_DIR%\openxs_config.json'"
if errorlevel 1 (
    echo [ERROR] Failed to download configuration
    pause
    exit /b 1
)

REM Download main script
echo [INFO] Downloading main script...
powershell -Command "Invoke-WebRequest -Uri '%SCRIPT_URL%' -OutFile '%INSTALL_DIR%\openxs.bat'"
if errorlevel 1 (
    echo [ERROR] Failed to download main script
    pause
    exit /b 1
)

REM Create launcher script
echo [INFO] Creating launcher...
echo @echo off > "%INSTALL_DIR%\%BINARY_NAME%"
echo cd /d "%INSTALL_DIR%" >> "%INSTALL_DIR%\%BINARY_NAME%"
echo call openxs.bat %%* >> "%INSTALL_DIR%\%BINARY_NAME%"

REM Create desktop shortcut
echo [INFO] Creating desktop shortcut...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP_DIR%\OpenXS Video Downloader.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\%BINARY_NAME%'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'OpenXS Video Downloader - YouTube Video Downloader'; $Shortcut.Save()"

REM Add to PATH (user level)
echo [INFO] Adding to PATH...
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "CURRENT_PATH=%%B"
if not defined CURRENT_PATH set "CURRENT_PATH="

echo !CURRENT_PATH! | findstr /C:"%INSTALL_DIR%" >nul
if errorlevel 1 (
    if defined CURRENT_PATH (
        setx PATH "!CURRENT_PATH!;%INSTALL_DIR%"
    ) else (
        setx PATH "%INSTALL_DIR%"
    )
    echo [INFO] Added %INSTALL_DIR% to PATH
) else (
    echo [INFO] %INSTALL_DIR% already in PATH
)

echo.
echo ===================================
echo [INFO] Installation completed successfully!
echo.
echo You can now launch OpenXS Video Downloader:
echo • Desktop shortcut: "OpenXS Video Downloader"
echo • Command prompt: yt-dlp-xs
echo • Start menu: Search for "OpenXS"
echo.
echo To uninstall: run "%INSTALL_DIR%\uninstall.bat"
echo ===================================
echo.

REM Create uninstaller
echo [INFO] Creating uninstaller...
echo @echo off > "%INSTALL_DIR%\uninstall.bat"
echo echo Uninstalling OpenXS Video Downloader... >> "%INSTALL_DIR%\uninstall.bat"
echo rmdir /s /q "%INSTALL_DIR%" >> "%INSTALL_DIR%\uninstall.bat"
echo del "%DESKTOP_DIR%\OpenXS Video Downloader.lnk" >> "%INSTALL_DIR%\uninstall.bat"
echo echo OpenXS Video Downloader uninstalled successfully >> "%INSTALL_DIR%\uninstall.bat"
echo pause >> "%INSTALL_DIR%\uninstall.bat"

pause