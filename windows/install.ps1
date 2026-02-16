# ===============================
# Auto Elevate
# ===============================
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Running as Administrator..."

# ===============================
# Variables
# ===============================
$InstallDir = "C:\OpenXs\VideoDownloaderWindows"
$DownloadDir = "$env:USERPROFILE\Downloads\OpenXS"
$ExeUrl = "https://estube.netlify.app/EasyYouTubeVideoDwonloader.exe"
$ExePath = "$InstallDir\EasyYouTubeVideoDwonloader.exe"

# ===============================
# Create Folders
# ===============================
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $DownloadDir | Out-Null

# ===============================
# Install Chocolatey (if missing)
# ===============================
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString(
        'https://community.chocolatey.org/install.ps1'))
}

# Refresh environment
$env:Path += ";C:\ProgramData\chocolatey\bin"

# ===============================
# Install Python
# ===============================
choco install python -y

# Refresh PATH again
$env:Path += ";C:\Python39;C:\Python39\Scripts"

# ===============================
# Install yt-dlp
# ===============================
python -m pip install --upgrade pip
pip install yt-dlp

# ===============================
# Download EXE
# ===============================
Invoke-WebRequest -Uri $ExeUrl -OutFile $ExePath

# ===============================
# Create Shortcuts
# ===============================
$WshShell = New-Object -ComObject WScript.Shell

$DesktopShortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\OpenXS Video Downloader.lnk")
$DesktopShortcut.TargetPath = $ExePath
$DesktopShortcut.WorkingDirectory = $InstallDir
$DesktopShortcut.Save()

$StartMenuShortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OpenXS Video Downloader.lnk")
$StartMenuShortcut.TargetPath = $ExePath
$StartMenuShortcut.WorkingDirectory = $InstallDir
$StartMenuShortcut.Save()

# ===============================
# Force Run As Admin on Shortcut
# ===============================
foreach ($shortcut in @(
    "$env:USERPROFILE\Desktop\OpenXS Video Downloader.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OpenXS Video Downloader.lnk"
)) {
    $bytes = [System.IO.File]::ReadAllBytes($shortcut)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($shortcut, $bytes)
}

Write-Host ""
Write-Host "Installation Completed Successfully!"
Pause
