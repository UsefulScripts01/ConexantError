Get-PnpDevice -FriendlyName "Conexant ISST Audio" | Disable-PnpDevice -confirm:$false

Start-Process -Wait -FilePath "C:\Program Files\CONEXANT\CNXT_AUDIO_HDA\UIU64a.exe" -ArgumentList "-U -R -G -S -Icisstrt.inf -OI=IntcAudioBus.inf"

Stop-Service -Name "wuauserv" -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download" -Recurse
#Remove-Item "C:\Windows\System32\DriverStore\FileRepository\cisstrt.inf_amd64_c4cece4cb44ec2e5\cisstrt.inf" -Force
Remove-WindowsDriver -Path "C:\Windows\System32\DriverStore\FileRepository" -Driver "cisstrt.inf"

# start windows update
control update
UsoClient StartInteractiveScan


# tworzenie jednorazowego skryptu "EnableSound.bat"
New-Item -Path "C:\Temp\EnableSound.txt" -ItemType File
Add-Content -Path "C:\Temp\EnableSound.txt" -Value 'powershell.exe  -NoProfile -ExecutionPolicy Bypass -Command "& {Get-PnpDevice -Class Media | Enable-PnpDevice -confirm:$false}"'
Add-Content -Path "C:\Temp\EnableSound.txt" -Value 'powershell.exe  -NoProfile -ExecutionPolicy Bypass -Command "& {Get-WindowsDriver -Online -All}"'
Rename-Item -Path "C:\Temp\EnableSound.txt" -NewName "C:\Temp\EnableSound.bat"

# dodaje jednorazowy klucz rejestru, ktory uruchamia EnableSound.bat przy nastepnym restarcie
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v !EnableSound /t REG_SZ /d "C:\Temp\EnableSound.bat"

Write-Host "PRESS ANY KEY TO RESTART?"
pause
Restart-Computer