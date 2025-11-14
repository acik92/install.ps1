# =====================================================
# 🧩 All-in-One Smart Installer
# Auto Download + Silent Install + Auto Skip + Auto Delete
# =====================================================

Write-Host "🚀 Memulakan pemasangan automatik..." -ForegroundColor Cyan

# Folder sementara
$dl = "$env:TEMP\installers"
New-Item -ItemType Directory -Force -Path $dl | Out-Null

# Senarai software (nama, URL, command line)
$apps = @(
    @{name="Google Chrome"; process="chrome"; url="https://dl.google.com/chrome/install/latest/chrome_installer.exe"; args="/silent /install"},
    @{name="Mozilla Firefox"; process="firefox"; url="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"; args="/S"},
    @{name="VLC Media Player"; process="vlc"; url="https://get.videolan.org/vlc/3.0.21/win64/vlc-3.0.21-win64.exe"; args="/S"},
    @{name="TeamViewer"; process="TeamViewer"; url="https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"; args="/S"},
    @{name="WinRAR"; process="winrar"; url="https://www.rarlab.com/rar/winrar-x64-701.exe"; args="/S"},
    @{name="Adobe Acrobat Reader"; process="AcroRd32"; url="https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2400820463/AcroRdrDCx642400820463_MUI.exe"; args="/sAll /rs /rps /msi EULA_ACCEPT=YES ENABLE_CHROMEEXT=0"},
    @{name="WhatsApp"; process="WhatsApp"; url="https://web.whatsapp.com/desktop/windows/release/x64/WhatsAppSetup.exe"; args="/S"},
    @{name="Telegram"; process="Telegram"; url="https://updates.tdesktop.com/tsetup-x64.5.9.1.exe"; args="/S"}
)

# Semak dan pasang
foreach ($app in $apps) {
    Write-Host "`n🔍 Memeriksa $($app.name)..." -ForegroundColor Cyan
    $installed = Get-Command $app.process -ErrorAction SilentlyContinue

    if ($installed) {
        Write-Host "✅ $($app.name) sudah dipasang — langkau." -ForegroundColor Green
        continue
    }

    $file = "$dl\$($app.name).exe"
    Write-Host "⬇️ Muat turun $($app.name)..." -ForegroundColor Yellow
    try {
        iwr -Uri $app.url -OutFile $file -UseBasicParsing
        Write-Host "⚙️ Memasang $($app.name)..." -ForegroundColor Magenta
        Start-Process $file -ArgumentList $app.args -Wait
        Write-Host "✅ Selesai: $($app.name)" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Ralat semasa memasang: $($app.name)" -ForegroundColor Red
    }
}

# Padam semua installer
Write-Host "`n🧹 Memadam fail pemasangan sementara..." -ForegroundColor Cyan
Remove-Item -Path $dl -Recurse -Force -ErrorAction SilentlyContinue

# Buat shortcut web di Desktop
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcuts = @{
    "YouTube"   = "https://www.youtube.com"
    "Instagram" = "https://www.instagram.com"
    "Facebook"  = "https://www.facebook.com"
}
$ws = New-Object -ComObject WScript.Shell
foreach ($name in $shortcuts.Keys) {
    $sc = $ws.CreateShortcut("$desktop\$name.url")
    $sc.TargetPath = $shortcuts[$name]
    $sc.Save()
}

Write-Host "`n🎉 Semua software & shortcut telah siap dipasang (auto skip diaktifkan)." -ForegroundColor Green
