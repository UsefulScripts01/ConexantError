
# disable Conexant sound card
Write-Host "Disable Conexant ISST Audio device"

#$DeviceID = (Get-PnpDevice -FriendlyName "*Conexant*").InstanceID
#Disable-PnpDevice -InstanceID $DeviceID
Get-PnpDevice -FriendlyName "*Conexant*" | Disable-PnpDevice -Confirm:$false

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
Copy-Item -path "C:\Users\dawid\Documents\GitHub\ConexantError\*" -Destination "C:\Temp\" -Force


# dodaje jednorazowy klucz rejestru, ktory uruchamia EnableSound.bat przy nastepnym restarcie
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableSound /t REG_SZ /d "C:\Temp\EnableSound.bat"

write-host "`n"
write-host "`n"

Write-Host "DONE. Wait for all Windows Updates and restart the machine.."

pause