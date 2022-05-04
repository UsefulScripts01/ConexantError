
# disable Conexant sound card
Write-Host "Disable Conexant ISST Audio device"

#$DeviceID = (Get-PnpDevice -FriendlyName "*Conexant*").InstanceID
#Disable-PnpDevice -InstanceID $DeviceID
Get-PnpDevice -FriendlyName "*Conexant*" | Disable-PnpDevice -Confirm:$false -

write-host "`n"
write-host "`n"

Write-Host "Delete Conexant software and drivers. Please wait.."
Start-Process -Wait -FilePath "C:\Program Files\CONEXANT\CNXT_AUDIO_HDA\UIU64a.exe" -ArgumentList "-U -R -G -S -Icisstrt.inf -OI=IntcAudioBus.inf"


Stop-Service -Name "wuauserv" -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Recurse -Force

# start windows update
control update
UsoClient StartInteractiveScan

# kopiowanie jednorazowego skryptu "EnableSound.bat"
Set-Location -Path "C:\Users\dawid\Documents\GitHub\ConexantError" 
Copy-Item "EnableSound.bat" -Destination "C:\Temp\" -Force

# dodaje jednorazowy klucz rejestru, ktory uruchamia EnableSound.bat przy nastepnym restarcie
reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableAudioDevice /t REG_SZ /d "C:\Temp\EnableSound.bat" /f
#reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableAudioDevice /t REG_SZ /d "powershell.exe -Command 'Get-PnpDevice -FriendlyName "*Conexant*" | Enable-PnpDevice -Confirm:$false'" /f
#reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !OpenWinUpdate /t REG_SZ /d "cmd.exe /c control update" /f
#reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !StartWinUpdate /t REG_SZ /d "cmd.exe /c UsoClient StartInteractiveScan" /f

write-host "`n"
write-host "`n"

Write-Host "DONE. Wait for all Windows Updates and restart the machine.."

pause