powershell.exe -Command "Get-PnpDevice -FriendlyName "*Conexant*" | Enable-PnpDevice -Confirm:$false"
control update
UsoClient StartInteractiveScan
