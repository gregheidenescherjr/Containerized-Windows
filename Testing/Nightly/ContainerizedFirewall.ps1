CLS
$choice = Read-Host "1.Export Policy 2.Import Policy"
if ($choice -eq 1)
{ netsh advfirewall export "c:\advfirewallpolicy.wfw" }
else
{ netsh advfirewall import "c:\advfirewallpolicy.wfw" } 