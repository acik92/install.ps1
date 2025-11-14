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
    @{name="VLC Media Player"; process="vlc"; url="https://mirror-hk.koddos.net/videolan/vlc/3.0.21/win64/vlc-3.0.21-win64.exe"; args="/S"},
    @{name="TeamViewer"; process="TeamViewer"; url="https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"; args="/S"},
    @{name="WinRAR"; process="winrar"; url="https://www.rarlab.com/rar/winrar-x64-701.exe"; args="/S"}
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

# --- Loop Microsoft Store / Winget Apps ---
$storeApps = @(
    @{name="YouTube"; id="Google.YouTube"},
    @{name="WhatsApp"; id="9WZDNCRFJ03T"},
    @{name="Telegram"; id="8WZDNCRFHVJL"},
    @{name="Adobe Acrobat Reader"; id="Adobe.Acrobat.Reader.64-bit"}
)

foreach ($app in $storeApps) {
    Write-Host "`n⬇️ Memasang $($app.name) dari Store..." -ForegroundColor Cyan
    try {
        winget install --id $app.id -e --silent --accept-package-agreements --accept-source-agreements
        Write-Host "✅ $($app.name) telah dipasang." -ForegroundColor Green
    } catch {
        Write-Host "❌ Gagal memasang $($app.name) dari Store." -ForegroundColor Red
    }
}

# Padam semua installer
Write-Host "`n🧹 Memadam fail pemasangan sementara..." -ForegroundColor Cyan
Remove-Item -Path $dl -Recurse -Force -ErrorAction SilentlyContinue

# Path Chrome
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Desktop folder
$desktop = [Environment]::GetFolderPath("Desktop")

# Senarai web yang nak dibuat shortcut
$apps = @{
    "YouTube"   = "https://www.youtube.com"
    "Instagram" = "https://www.instagram.com"
    "Facebook"  = "https://www.facebook.com"
}

# Buat shortcut
$ws = New-Object -ComObject WScript.Shell
foreach ($name in $apps.Keys) {
    $sc = $ws.CreateShortcut("$desktop\$name.lnk")
    $sc.TargetPath = $chromePath
    # --app=<URL> buka web dalam window Chrome tersendiri
    $sc.Arguments = "--app=$($apps[$name])"
    $sc.WorkingDirectory = [System.IO.Path]::GetDirectoryName($chromePath)
    $sc.Save()
}

Write-Host "`n🎉 Semua software & shortcut telah siap dipasang (auto skip diaktifkan)." -ForegroundColor Green
