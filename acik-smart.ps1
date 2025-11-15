# ================================================
# 🧩 Smart Installer Menu + Office 365 + Office Home 2024
# ================================================

$dl = "$env:TEMP\installers"
New-Item -ItemType Directory -Force -Path $dl | Out-Null

# Senarai software
$apps = @(
    @{id=1; name="Google Chrome"; process="chrome"; url="https://dl.google.com/chrome/install/latest/chrome_installer.exe"; args="/silent /install"},
    @{id=2; name="Mozilla Firefox"; process="firefox"; url="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"; args="/S"},
    @{id=3; name="VLC Media Player"; process="vlc"; url="https://mirror-hk.koddos.net/videolan/vlc/3.0.21/win64/vlc-3.0.21-win64.exe"; args="/S"},
    @{id=4; name="TeamViewer"; process="TeamViewer"; url="https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"; args="/S"},
    @{id=5; name="WinRAR"; process="winrar"; url="https://www.rarlab.com/rar/winrar-x64-701.exe"; args="/S"},
    @{id=6; name="WhatsApp"; process="WhatsApp"; url="https://get.microsoft.com/installer/download/9NKSQGP7F2NH"; args="/S"},
    @{id=7; name="Telegram"; process="Telegram"; url="https://td.telegram.org/tx64/tsetup-x64.6.2.4.exe"; args="/S"},
    @{id=8; name="Microsoft Office 365"; process="office365"; url="https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA"; args="/quiet /update user"},
    @{id=9; name="Microsoft Office Home 2024"; process="officehome2024"; url="https://officecdn.microsoft.com/db/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/bg-bg/Home2024Retail.img"; args="/quiet /update user"}
)

# Fungsi install software
function Install-App($app) {
    Write-Host "`n🔍 Memeriksa $($app.name)..." -ForegroundColor Cyan
    $installed = Get-Command $app.process -ErrorAction SilentlyContinue

    if ($installed) {
        Write-Host "✅ $($app.name) sudah dipasang — langkau." -ForegroundColor Green
        return
    }

    $file = "$dl\$($app.name).exe"
    Write-Host "⬇️ Muat turun $($app.name)..." -ForegroundColor Yellow

    try {
        Invoke-WebRequest -Uri $app.url -OutFile $file -UseBasicParsing
        Write-Host "⚙️ Memasang $($app.name)..." -ForegroundColor Magenta
        Start-Process $file -ArgumentList $app.args -Wait
        Write-Host "✅ Selesai: $($app.name)" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Ralat semasa memasang: $($app.name)" -ForegroundColor Red
    }
}

# Fungsi shortcut Chrome Apps
function Create-ChromeApps {
    Write-Host "`n🌐 Membuat shortcut Chrome Apps..." -ForegroundColor Cyan

    $desktop = [Environment]::GetFolderPath("Desktop")
    $ws = New-Object -ComObject WScript.Shell
    $chrome = "C:\Program Files\Google\Chrome\Application\chrome_proxy.exe"

    $shortcuts = @{
        "YouTube"   = "--profile-directory=Default --app-id=agimnkijcaahngcdmfeangaknmldooml"
        "Facebook"  = "--profile-directory=Default --app-id=kippjfofjhjlffjecoapiogbkgbpmgej"
        "Instagram" = "--profile-directory=Default --app-id=akpamiohjfcnimfljfndmaldlcfphjmp"
    }

    foreach ($name in $shortcuts.Keys) {
        $sc = $ws.CreateShortcut("$desktop\$name.lnk")
        $sc.TargetPath = $chrome
        $sc.Arguments = $shortcuts[$name]
        $sc.IconLocation = "$chrome,0"
        $sc.Save()
    }

    Write-Host "✅ Shortcut siap!" -ForegroundColor Green
}

# Menu
function Show-Menu {
    Clear-Host
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host "  🧩 Smart Installer Menu" -ForegroundColor Green
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host "1. Install SEMUA software"
    Write-Host "2. Pilih software satu-satu"
    Write-Host "3. Pasang Chrome App Shortcuts"
    Write-Host "4. Exit"
    Write-Host ""
}

# Loop Menu
do {
    Show-Menu
    $choice = Read-Host "Masukkan pilihan"

    switch ($choice) {

        "1" {
            foreach ($app in $apps) { Install-App $app }
            Read-Host "`nTekan ENTER untuk kembali ke menu"
        }

        "2" {
            Write-Host "`n📦 Senarai Software:" -ForegroundColor Yellow
            foreach ($app in $apps) {
                Write-Host "$($app.id). $($app.name)"
            }

            $pick = Read-Host "`nPilih nombor software"
            $selected = $apps | Where-Object { $_.id -eq $pick }

            if ($selected) {
                Install-App $selected
            } else {
                Write-Host "❌ Pilihan tidak sah!" -ForegroundColor Red
            }

            Read-Host "`nTekan ENTER untuk kembali ke menu"
        }

        "3" {
            Create-ChromeApps
            Read-Host "`nTekan ENTER untuk kembali ke menu"
        }

        "4" {
            Write-Host "`n👋 Keluar..." -ForegroundColor Cyan
        }

        default {
            Write-Host "❌ Pilihan tidak sah!" -ForegroundColor Red
        }
    }

} until ($choice -eq "4")

Remove-Item -Path $dl -Recurse -Force -ErrorAction SilentlyContinue
