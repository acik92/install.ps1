# ====================================================
# PowerShell All-in-One Installer
# Author: acik92
# Description: Install software A-Z, Microsoft Office, drivers & tools
# ====================================================

# ===== Helper Functions =====
Function Download-And-Install {
    param (
        [string]$url,
        [string]$installerName,
        [string]$silentArgs = "/S"
    )
    $tempPath = "$env:TEMP\$installerName"
    Write-Host "Downloading $installerName..."
    Invoke-WebRequest -Uri $url -OutFile $tempPath
    Write-Host "Installing $installerName..."
    Start-Process -FilePath $tempPath -ArgumentList $silentArgs -Wait
    Remove-Item $tempPath -Force
    Write-Host "$installerName installed."
}

Function Install-PWA {
    param (
        [string]$url,
        [string]$name
    )
    Write-Host "Installing PWA: $name..."
    Start-Process "msedge.exe" "--app=$url"
}

# ===== SOFTWARE INSTALLER =====
$software = @(
    @{Name="Google Chrome"; Url="https://dl.google.com/chrome/install/latest/chrome_installer.exe"; Args="/silent /install"},
    @{Name="Firefox"; Url="https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US"; Args="/S"},
    @{Name="VLC"; Url="https://get.videolan.org/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"; Args="/S"},
    @{Name="WinRAR"; Url="https://www.rarlab.com/rar/winrar-x64-602.exe"; Args="/S"},
    @{Name="TeamViewer"; Url="https://download.teamviewer.com/download/TeamViewer_Setup.exe"; Args="/S"},
    @{Name="Adobe Reader"; Url="https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2301020047/AcroRdrDC2301020047_en_US.exe"; Args="/sAll"},
    @{Name="WhatsApp"; Url="https://web.whatsapp.com/desktop/windows/release/x64/WhatsAppSetup.exe"; Args="/S"},
    @{Name="Telegram"; Url="https://telegram.org/dl/desktop/win"; Args="/S"}
)

foreach ($app in $software) {
    Download-And-Install -url $app.Url -installerName "$($app.Name).exe" -silentArgs $app.Args
}

# ===== PWA INSTALL =====
$pwapps = @(
    @{Name="Instagram"; Url="https://www.instagram.com"},
    @{Name="Facebook"; Url="https://www.facebook.com"}
)

foreach ($pwa in $pwapps) {
    Install-PWA -url $pwa.Url -name $pwa.Name
}

# ===== MICROSOFT OFFICE =====
# Example: Office 365 Home
$officeUrl = "https://officecdn.microsoft.com/pr/C1297B33-6C35-4B16-888C-0198E8FAE17E/media/en-US/ProPlus2021Retail.img"
Download-And-Install -url $officeUrl -installerName "Office.img" -silentArgs=""

# ===== EXTRA TOOLS =====
# Epson L3250 Driver
$epsonUrl = "https://download.epson.com.sg/epson_l3250_driver.exe"
Download-And-Install -url $epsonUrl -installerName "EpsonL3250.exe" -silentArgs="/S"

# .NET Framework
$dotnetUrl = "https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-desktop-7.0.11-windows-x64-installer"
Download-And-Install -url $dotnetUrl -installerName "dotnet.exe" -silentArgs="/quiet /norestart"

# Visual C++ Redistributables
$vcUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
Download-And-Install -url $vcUrl -installerName "vc_redist.exe" -silentArgs="/install /quiet /norestart"

# Snappy Driver Installer Lite
$sdiUrl = "https://sdi-tool.org/downloads/sdilite.exe"
Download-And-Install -url $sdiUrl -installerName "SDILite.exe" -silentArgs="/S"

Write-Host "`n✅ Semua software telah selesai diinstall!"
Write-Host "Sila restart PC jika perlu."

