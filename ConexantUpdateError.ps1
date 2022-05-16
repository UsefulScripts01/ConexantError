
# disable Conexant sound card
Write-Host "Disable Conexant ISST Audio device" -ForegroundColor Yellow
Get-PnpDevice -FriendlyName '*Conexant*' | Disable-PnpDevice -Confirm:$false

# add empty lines
write-host "`n"
write-host "`n"

# uninstall Conexant software
Write-Host "Delete Conexant software and drivers. Please wait.." -ForegroundColor Yellow
Start-Process -Wait -FilePath "C:\Program Files\CONEXANT\CNXT_AUDIO_HDA\UIU64a.exe" -ArgumentList "-U -R -G -S -Icisstrt.inf -OI=IntcAudioBus.inf"

# stop Windows Update service and delete Windows Update temporary files
Stop-Service -Name "wuauserv" -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Recurse -Force

# start Windows Update
control update
UsoClient StartInteractiveScan

# download "EnableSound.bat"
New-Item -ItemType "directory" -Path "c:\Temp"
Invoke-WebRequest -URI "https://raw.githubusercontent.com/UsefulScripts01/ConexantError/main/EnableSound.bat" -OutFile "C:\Temp\EnableSound.bat"

# add a one-time registry key to run the "EnableSound.bat" script on next boot
# https://docs.microsoft.com/pl-pl/windows/win32/setupapi/run-and-runonce-registry-keys
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableAudioDevice /t REG_SZ /d "C:\Temp\EnableSound.bat" /f

# message box
Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Complete the Windows Update process and restart your computer')

exit
