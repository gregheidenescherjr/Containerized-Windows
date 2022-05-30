#Creating Container Enviornment
#This will create 2 drives for your conainter experience.
#From there you will need to watch for the application that install.
#Some of them need to be mannually installed in their proper locations.
#The script will give you visual warning with reminders.

#Project Initialized by Gregory Heidenescher Jr and Christopher Southerland 5/30/2022
#The main goal is to create a user experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be comprimised, it was all done in a containment area seperate from the main Windows Installation.

$homee = New-Object System.Management.Automation.Host.ChoiceDescription "&Windows Home Edition","Description."
$pro = New-Object System.Management.Automation.Host.ChoiceDescription "&Windows Pro Edition","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($homee, $pro, $abort)
$heading = "Containerized Windows"
$mess = "What Version Of Windows Do You Have?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 1)
switch ($rslt) {
0{
Write-Host "Windows Home Edition" -ForegroundColor White
#Set File After Restart
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "G:\WindowsHomeEditionSetup.ps1")
}1{
Write-Host "Windows Pro Edition" -ForegroundColor White
#Set File After Restart
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "G:\WindowsProEditionSetup.ps1")
}2{
Write-Host "Cancel" -ForegroundColor Red
#Need Action
}
}
$mess = "Ready To Adjust Your Home Drive?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 1)
switch ($rslt) {
0{
Write-Host "Yes" -ForegroundColor Green
#Create Drives To Containerize
Write-Host "Creating G and H Drives To Containerize" -ForegroundColor Yellow
Resize-Partition -DiskNumber 1 -PartitionNumber 2 -Size 250GB | format-volume -new filesystemlabel Home
New-Partition -DiskNumber 1 -Size 64GB -DriveLetter G -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | format-volume -filesystem NTFS -new filesystemlabel ContainerApps
New-Partition -DiskNumber 1 -Size $MaxSize GB -DriveLetter H -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | format-volume -filesystem NTFS -new filesystemlabel Downloads
Write-Host "Drives Resized, Created, and Formatted." -ForegroundColor Green
}1{
Write-Host "No" -ForegroundColor Red
}2{
Write-Host "Cancel" -ForegroundColor Red
}
}

Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 2