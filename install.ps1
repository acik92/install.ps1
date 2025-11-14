Write-Host "Installing Google Chrome..."

$chrome = "$env:TEMP\chrome.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $chrome
Start-Process $chrome -ArgumentList "/silent /install" -Wait
Remove-Item $chrome

Write-Host "Done."
