
# disable Conexant sound card
Write-Host "Disable Conexant ISST Audio device" -ForegroundColor Yellow

Get-PnpDevice -FriendlyName '*Conexant*' | Disable-PnpDevice -Confirm:$false

write-host "`n"
write-host "`n"

# uninstall Conexant software
Write-Host "Delete Conexant software and drivers. Please wait.." -ForegroundColor Yellow
Start-Process -Wait -FilePath "C:\Program Files\CONEXANT\CNXT_AUDIO_HDA\UIU64a.exe" -ArgumentList "-U -R -G -S -Icisstrt.inf -OI=IntcAudioBus.inf"

# stop Windows Update service, delete Windows Update temporary files
Stop-Service -Name "wuauserv" -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Recurse -Force

# start windows update
control update
UsoClient StartInteractiveScan

# pobieranie jednorazowego skryptu "EnableSound.bat"
New-Item -ItemType "directory" -Path "c:\Temp"
Invoke-WebRequest -URI "https://raw.githubusercontent.com/UsefulScripts01/ConexantError/main/EnableSound.bat" -OutFile "C:\Temp\EnableSound.bat"

# dodaje jednorazowy klucz rejestru, ktory uruchamia EnableSound.bat przy nastepnym restarcie
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableAudioDevice /t REG_SZ /d "C:\Temp\EnableSound.bat" /f

write-host "`n"
write-host "`n"

Write-Host "DONE. Wait for all Windows Updates and restart the machine.." -ForegroundColor Yellow

pause