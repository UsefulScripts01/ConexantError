powershell.exe -executionpolicy bypass Get-CimInstance -Class Win32_PNPEntity -Property Manufacturer -Filter 'Manufacturer LIKE "%conexant%"' | Disable-PnpDevice -confirm:$false
control update
UsoClient StartInteractiveScan
pause