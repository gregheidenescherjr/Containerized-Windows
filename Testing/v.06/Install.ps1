  ####     ####    ##  ##   ######     ##      ####    ##  ##   ######   #####     ####    ######   ######   ####    
 ##  ##   ##  ##   ### ##     ##      ####      ##     ### ##   ##       ##  ##     ##         ##   ##       ## ##   
 ##       ##  ##   ######     ##     ##  ##     ##     ######   ##       ##  ##     ##        ##    ##       ##  ##  
 ##       ##  ##   ######     ##     ######     ##     ######   ####     #####      ##       ##     ####     ##  ##  
 ##       ##  ##   ## ###     ##     ##  ##     ##     ## ###   ##       ####       ##      ##      ##       ##  ##  
 ##  ##   ##  ##   ##  ##     ##     ##  ##     ##     ##  ##   ##       ## ##      ##     ##       ##       ## ##   
  ####     ####    ##  ##     ##     ##  ##    ####    ##  ##   ######   ##  ##    ####    ######   ######   ####    
                                                                                                                     
						 ##   ##   ####    ##  ##   ####      ####    ##   ##   ####   
						 ##   ##    ##     ### ##   ## ##    ##  ##   ##   ##  ##  ##  
						 ##   ##    ##     ######   ##  ##   ##  ##   ##   ##  ##      
						 ## # ##    ##     ######   ##  ##   ##  ##   ## # ##   ####   
						 #######    ##     ## ###   ##  ##   ##  ##   #######      ##  
						 ### ###    ##     ##  ##   ## ##    ##  ##   ### ###  ##  ##  
						 ##   ##   ####    ##  ##   ####      ####    ##   ##   ####   

									#Containerized Windows
									#Project Initialized on 5/30/2022 by:
									#Gregory Heidenescher Jr - Creator/Tester
									#Christopher Southerland - Alpha Tester

#Special Thanks
#(Sandbox Home Edition) Benny @ https://www.deskmodder.de/blog/2019/04/20/windows-10-home-windows-sandbox-installieren-und-nutzen/
#(Hyper-V Home Edition) Usman Khurshid @ https://www.itechtics.com/enable-hyper-v-windows-10-home/

						#Tested On:
						#Edition	Windows 11 Pro
						#Version	21H2
						#Installed on	‎2/‎28/‎2022
						#OS build	22000.708
						#Experience	Windows Feature Experience Pack 1000.22000.708.0
						#Processor	AMD Ryzen 9 5900X 12-Core Processor               3.70 GHz
						#Installed RAM	64.0 GB
						#System type	64-bit operating system, x64-based processor

#The main goal is to create a User Experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be compromised, it was all done in a containment area seperate from the main Windows Installation.
#This project, combined with good internet practices...
#will help seperate personal information when browsing the internet through conatinment and compartmentizing applications.
#We dont need other people to see our credentials during a casual browsing session.

PowerShell -NoProfile -ExecutionPolicy "Unrestricted" -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy "Unrestricted" -File "".\Install.ps1""'-Verb RunAs}";

#Set Directory to PSScriptRoot
if ((Get-Location).Path -NE $PSScriptRoot) { Set-Location $PSScriptRoot }

#Copying Required Files
Copy-Item ".\Secure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\UnSecure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\Install.ps1" -Destination "C:\Users\Public\Documents"
Remove-Item ".\Shortcuts"

#Root Account Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$heading = "Containerized Windows Setup"
$mess = "Would You Like To Install Root And User Accounts??"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	
	Start-Process "cmd.exe" -File ".\Containerize\Scripts\Users.bat" -Verb RunAs
	
}1{
	Push-Location $PSScriptRoot
}
}

#Virtual Enviornment Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Ok","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$heading = "Containerized Windows Setup. You will have to manually initialize and exit Drive Management."
$mess = "Now Enabling Virtual Enviornments"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Start-Process "cmd.exe" -File ".\Containerize\Scripts\VMs.bat" -Verb RunAs

#Virtual Drives Setup (Something is broken with Initializing. Must be done manually.)
New-VHD -Path "C:\Users\Public\Documents\VirtualDrive.vhdx" -Dynamic -SizeBytes 241GB 
Mount-VHD -path "C:\Users\Public\Documents\VirtualDrive.vhdx"
Start-Process diskmgmt.msc
Write-Host "You will have to manually initialize and exit Drive Management." -foregroundcolor "Yellow"
Write-Host "After Initializing, remember your disk number if you need to edit this script for yourself." -foregroundcolor "Yellow"
pause
Get-VHD -path "C:\Users\Public\Documents\VirtualDrive.vhdx"
New-Partition -DiskNumber 2 -Size 120GB -DriveLetter A | Format-Volume -FileSystem NTFS -Confirm:$false -Force
pause
Get-VHD -path "C:\Users\Public\Documents\VirtualDrive.vhdx"
New-Partition -DiskNumber 2 -Size 120GB -DriveLetter B | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Write-Host "Virtual Enviornment Enabled" -foregroundcolor "green"	
}
}

#Creating Shortcuts and Directories
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$heading = "Containerized Windows Setup"
$mess = "Creating Shortcuts and Directories."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
	0{
$SourceFilePath = "G:\"
$ShortcutPath = "C:\Users\Public\Documents\ContainerApps.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()
$SourceFilePath = "H:\"
$ShortcutPath = "C:\Users\Public\Documents\Downloads.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()

New-Item -FilePath "H:\Documents" -itemType Directory
New-Item -FilePath "H:\Picutres" -itemType Directory
New-Item -FilePath "H:\Downloads" -itemType Directory
Write-Host "Shortcuts and Directories Enabled" -foregroundcolor "Green"
}
}

#Recommended Applications
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Let Me Choose","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Containerized Windows Setup"
$mess = "Install recommended applications? 4 in total. If you do, change your Installation Destination to G:\ContainerApps"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	#PowerShell
		#Download file
			Invoke-WebRequest -Uri https://www.github.com/PowerShell/PowerShell/releases/download/v7.2.4/PowerShell-7.2.4-win-x64.msi -verb RunAs -OutFile .\PowerShell.msi
		#Install file
			start-process -FilePath ".\PowerShell.msi"
			Remove-Item '.\PowerShell.msi'
	#Mozilla Thunderbird Portable
		#Download file
			Invoke-WebRequest -Uri https://download.sourceforge.net/portableapps/ThunderbirdPortable_91.9.1_English.paf.exe -verb RunAs -OutFile .\Thunderbird.paf.exe
		#Install file
			start-process -FilePath ".\Thunderbird.paf.exe" -verb RunAs
			Remove-Item '.\Thunderbird.paf.exe'
	#Comodo Dragon Broswer - Chrome Based Broswer ("Secure" Line)
	#"Secure Sandbox"(Where personal credentials and information is saved and loaded during startup)
		#Download file
			Invoke-WebRequest -Uri https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe -verb RunAs -OutFile .\dragonsetup.exe
		#Install file
			start-process -FilePath ".\dragonsetup.exe" -Verb runas
			Remove-Item '.\dragonsetup.exe'
	#Ice Dragon Browser - FireFox Based Browser ("UnSecure" Line)
	#"UnSecure Sandbox" (Where no credentials are loaded during startup)
		#Download file
			Invoke-WebRequest -Uri https://download.comodo.com/icedragon/update/icedragonsetup.exe -OutFile .\icedragonsetup.exe 
		#Install file
			start-process -FilePath ".\icedragonsetup.exe" -Verb runas
			Remove-Item '.\icedragonsetup.exe'
	#Portable Apps Menu - Start Menu Linked To Portable Versions Of Popular Apps
		#Download file
			Invoke-WebRequest -Uri https://sourceforge.net/projects/portableapps/files/PortableApps.com%20Platform/PortableApps.com_Platform_Setup_21.2.2.paf.exe/download?use_mirror=cytranet -OutFile .\PortableApps.paf.exe
		#Install file
			start-process -FilePath ".\PortableApps.exe" -Verb runas
			Remove-Item '.\PortableApps.paf.exe'
	Write-Host "Recomended Applications Installed" -foregroundcolor "green"
}1{
	Push-Location $PSScriptRoot
}
}

#Setup Complete
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$heading = "Containerized Windows Setup"
$mess = "Base Settings Applied.
Shortcuts are in your Documents folder to create your own sandboxes.
Please Restart your system."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Push-Location $PSScriptRoot
#Cleanup
Remove-Item ".\Scripts"
Remove-Item "C:\Users\Public\Documents\Install.ps1"

#Get-AppXPackage *bingweather* | Remove-AppXPackage

#AutoMount Drives At Startup
#Register-ScheduledTask -xml (Get-Content "C:\Users\Public\Documents\AutoMountVDrives.xml" | Out-String) -TaskName "AutoMountDrives" -TaskPath "C:\Windows\System32\Tasks" –Force
Restart-Computer
}
}

#Chris Titus Tech Toolbox
#iwr -useb https://christitus.com/win | iex