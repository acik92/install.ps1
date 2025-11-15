# ================================================
# 🧩 Smart Installer Menu + Office 365 + Office 2024
# ================================================

$dl = "$env:TEMP\installers"
New-Item -ItemType Directory -Force -Path $dl | Out-Null

# Senarai software asas
$apps = @(
    @{id=1; name="Google Chrome"; process="chrome"; url="https://dl.google.com/chrome/install/latest/chrome_installer.exe"; args="/silent /install"},
    @{id=2; name="Mozilla Firefox"; process="firefox"; url="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"; args="/S"},
    @{id=3; name="VLC Media Player"; process="vlc"; url="https://mirror-hk.koddos.net/videolan/vlc/3.0.21/win64/vlc-3.0.21-win64.exe"; args="/S"},
    @{id=4; name="TeamViewer"; process="TeamViewer"; url="https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"; args="/S"},
    @{id=5; name="WinRAR"; process="winrar"; url="https://www.rarlab.com/rar/winrar-x64-701.exe"; args="/S"},
    @{id=6; name="WhatsApp"; process="WhatsApp"; url="https://get.microsoft.com/installer/download/9NKSQGP7F2NH"; args="/S"},
    @{id=7; name="Telegram"; process="Telegram"; url="https://td.telegram.org/tx64/tsetup-x64.6.2.4.exe"; args="/S"},
    @{id=8; name="Microsoft Office 365 Online"; process="office365"; url="https://download.microsoft.com/download/2/7/A/27A5C0F6-5C0A-44C0-8F8D-644EE3A3B2B2/officedeploymenttool_17029-20151.exe"; args="" },
    @{id=9; name="Microsoft Office Professional Plus 2024"; process="office2024"; url="https://download.microsoft.com/download/2/7/A/27A5C0F6-5C0A-44C0-8F8D-644EE3A3B2B2/officedeploymenttool_17029-20151.exe"; args="" }
)

# Fungsi install software biasa
function Install-App($app) {
    if ($app.id -ge 8) {
        Install-Office $app
        return
    }

    Write-Host "`n🔍 Memeriksa $($app.name)..." -ForegroundColor Cyan
    $installed = Get-Command $app.process -ErrorAction SilentlyContinue

    if ($installed) {
        Write-Host "✅ $($app.name) sudah dipasang — langkau." -ForegroundColor Green
        return
    }

    $file = "$dl\$($app.name).exe"
    Write-Host "⬇️ Muat turun $($app.name)..." -ForegroundColor Yellow

    try {
        Invoke-WebRequest -Uri $app.url -OutFile $file
        Write-Host "⚙️ Memasang $($app.name)..." -ForegroundColor Magenta
        Start-Process $file -ArgumentList $app.args -Wait
        Write-Host "✅ Selesai: $($app.name)" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Ralat semasa memasang: $($app.name)" -ForegroundColor Red
    }
}

# Fungsi install Microsoft Office
function Install-Office($app) {
    Write-Host "`n📦 Muat turun Office Deployment Tool..." -ForegroundColor Yellow

    $odtExe = "$dl\odt.exe"
    Invoke-WebRequest -Uri $app.url -OutFile $odtExe -UseBasicParsing

    Write-Host "📂 Menyediakan folder ODT..."
    Start-Process $odtExe -ArgumentList "/extract:$dl\odt /quiet" -Wait

    if ($app.id -eq 8) {
        # Office 365 Online Config
        $xml = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@
        $config = "$dl\odt\office365.xml"
    }

    if ($app.id -eq 9) {
        # Office Pro Plus 2024 Config
        $xml = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">
    <Product ID="ProPlus2024Volume">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@
        $config = "$dl\odt\office2024.xml"
    }

    $xml | Out-File -FilePath $config -Encoding UTF8

    Write-Host "⚙️ Memasang $($app.name)... (ambil masa 5–15 minit)" -ForegroundColor Magenta
    Start-Process "$dl\odt\setup.exe" -ArgumentList "/configure `"$config`"" -Wait

    Write-Host "✅ Selesai pasang $($app.name)" -ForegroundColor Green
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
