#Create Drives To Containerize
Write-Host "Creating 2 New Drives To Help Containerize Applications and Downloads" -ForegroundColor Yellow
Resize-Partition -DiskNumber 1 -PartitionNumber 2 -Size 250GB | format-volume -new filesystemlabel Home
New-Partition -DiskNumber 1 -Size 64GB -DriveLetter G -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | format-volume -filesystem NTFS -new filesystemlabel ContainerApps
New-Partition -DiskNumber 1 -Size $MaxSize GB -DriveLetter H -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | format-volume -filesystem NTFS -new filesystemlabel Downloads
Write-Host "Drive Creation Complete" -ForegroundColor Green

#Create Required Directories
New-Item "G:\PortableApps" -itemType Directory
New-Item "G:\Documents" -itemType Directory
New-Item "H:\Picutres" -itemType Directory
New-Item "H:\Downloads" -itemType Directory

#Rebooting With Changes
Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "G:\ContainerApps.ps1")
Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 2