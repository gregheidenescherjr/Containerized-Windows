#Creating Container Enviornment
#This will create 2 drives for your conainter experience.
#From there you will need to watch for the application that install.
#Some of them need to be mannually installed in their proper locations.
#The script will give you visual warning with reminders.

#Set File After Restart
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "G:\InstallApps.ps1")

#Create Drives To Containerize
Write-Host "Creating G and H Drives To Containerize" -ForegroundColor Yellow
Resize-Partition -DiskNumber 1 -PartitionNumber 2 -Size 250GB | format-volume -new filesystemlabel Home
New-Partition -DiskNumber 1 -Size 64GB -DriveLetter G -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | format-volume -filesystem NTFS -new filesystemlabel ContainerApps
New-Partition -DiskNumber 1 -Size $MaxSize GB -DriveLetter H -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | format-volume -filesystem NTFS -new filesystemlabel Downloads
Write-Host "Drives Resized, Created, and Formatted." -ForegroundColor Green

Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 2
