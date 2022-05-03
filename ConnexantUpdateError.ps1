Write-Host "Disable Conexant ISST Audio device"
Get-PnpDevice -Class media -InstanceId 'intel*' -OutVariable audio
Disable-PnpDevice -InputObject $audio -Confirm:$false


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
Copy-Item ".\EnableSound.bat" -Destination "C:\Temp"


# dodaje jednorazowy klucz rejestru, ktory uruchamia EnableSound.bat przy nastepnym restarcie
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableSound /t REG_SZ /d "C:\Temp\EnableSound.bat"

write-host "`n"
write-host "`n"

Write-Host "DONE"
Write-Host "PRESS ANY KEY TO RESTART"

pause
Restart-Computer