powershell.exe -executionpolicy bypass -Command "& {Get-PnpDevice -Class media -InstanceId 'intel*' -OutVariable audio; Enable-PnpDevice -InputObject $audio -Confirm:$false}"
control update
UsoClient StartInteractiveScan