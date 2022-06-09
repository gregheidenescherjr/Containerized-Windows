#Containerized Windows
#Project Initialized on 5/30/2022 by:
#Gregory Heidenescher Jr - Creator/Tester
#Christopher Southerland - Contributor/Tester

#Somehow this thing is working... it's ugly... but its working...

#The main goal is to create a User Experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be compromised, it was all done in a containment area seperate from the main Windows Installation.
#This project, combined with good internet practices, will help seperate personal information when browsing the internet through conatinment and compartmentizing applications.
#We dont need other people to see our credentials during a casual browsing session.

#Term Definitions
#"Secure Sandbox"(Where personal credentials and information is saved and loaded during startup)
#"UnSecure Sandbox" (Where no credentials are stored during startup)

PowerShell -NoProfile -ExecutionPolicy "Unrestricted" -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy "Unrestricted" -File "".\Install.ps1""'-Verb RunAs}";

Push-Location $PSScriptRoot

#Copying Required Files
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$heading = "Containerized Windows Setup"
$mess = "Copying Required Files."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
	0{
Copy-Item ".\Secure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\UnSecure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\Install.ps1" -Destination "C:\Users\Public\Documents"
}
}

#Root Account Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$heading = "Root And User Accounts Setup"
$mess = "Would You Like To Install Root And User Accounts??"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	
	Start-Process "cmd.exe" -File ".\Scripts\Users.bat" -Verb RunAs
	
}1{
	Push-Location $PSScriptRoot
}
}

#Sandbox Setup
$homee = New-Object System.Management.Automation.Host.ChoiceDescription "&Home","Description."
$pro = New-Object System.Management.Automation.Host.ChoiceDescription "&Pro","Description."
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Installed","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($homee, $pro, $yes)
$heading = "Sandbox Setup"
$mess = "What Version Of Sandbox Do You Need?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	
	Start-Process -File ".\Scripts\Sandbox.bat" -Verb RunAs
	
	#Rebooting With Changes
		Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
		$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Users\Public\Documents\Install.ps1")
}1{
	Push-Location $PSScriptRoot
	
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
	
	#Rebooting With Changes
		Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
		$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Users\Public\Documents\Install.ps1")
}2{
	Push-Location $PSScriptRoot
}
}

#Hyper-V Setup (Not Working)
$homee = New-Object System.Management.Automation.Host.ChoiceDescription "&Home","Description."
$pro = New-Object System.Management.Automation.Host.ChoiceDescription "&Pro","Description."
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Installed","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($homee, $pro, $yes)
$heading = "Hyper-V Setup"
$mess = "What Version Of Hyper-V Do You Need?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	
	Start-Process -File ".\Scripts\Hyper-V.bat" -Verb RunAs
	
	#Rebooting With Changes
	Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
	$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
	set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Users\Public\Documents\Install.ps1")
}1{
	Push-Location $PSScriptRoot
	
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
	
	#Rebooting With Changes
	Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
	$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
	set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Users\Public\Documents\Install.ps1")
}2{
	Push-Location $PSScriptRoot
}
}

#Restart If Needed
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$heading = "Containerized Windows Setup"
$mess = "Please Restart Your Computer After Installing Sandbox and Hyper-V. If Sandbox and Hyper-V are installed, please continue."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
	0{
Write-Host "Please Restart Your Computer After Installing Sandbox and Hyper-V." -foregroundcolor "yellow"
Write-Host "If Sandbox and Hyper-V are installed, please continue." -foregroundcolor "yellow"
pause
}
}

#Virtual Drives Setup (Super Jank... Needs Improvement) - Works Properly with Diskpart Commands, Why Can't Diskpart SideLoad Properly?
Push-Location $PSScriptRoot
New-VHD -Path "C:\Users\Public\Documents\VirtualDrives.vhdx" -SizeBytes 240GB
#Diskpart
#select vdisk file="C:\Users\Public\Documents\VirtualDrives.vhdx"
#attach vdisk
#rem == 1. ContainerApps Drive =========================
#create partition primary
#format quick fs=ntfs label="ContainerApps"
#assign letter="G"
#automount enable
#rem == 2. Downloads Drive =========================
#create partition primary
#format quick fs=ntfs label="ContainerApps"
#assign letter="H"
#automount enable
#exit
Start-Process -FilePath 'C:\Users\Public\Documents\VirtualDrives.vhdx' -Wait -Passthru | Out-Null
pause
Write-Host "The error is normal. Disk Management will open up, and you will need to finish the virtual drive setup. (Initializing - Assigning Next Available Disk Number)" -foregroundcolor "yellow"
Write-Host "Right-click on the unassigned space and select New Simple Volume option (Half Size for G: "ContainerApps" and Half Size for H: "Downloads")." -foregroundcolor "yellow"
Write-Host "Assign Drive G to ContainerApps and Drive H to Downloads. (Formating)" -foregroundcolor "yellow"
Write-Host "Create New Simple Volume (Max Size) And Assign Drive G to ContainerApps and Drive H to Downloads. (Formating)" -foregroundcolor "yellow"
Write-Host "Select Format this volume with the other settings option and make sure the other options are selected like (file system, Allocation Unit Size, and Volume Label etc). Click Next >> Finish." -foregroundcolor "yellow"
Write-Host "The error is normal. Disk Management will open up, and you will need to finish the virtual drive setup. (Initializing - Assigning Next Available Disk Number)" -foregroundcolor "red"
Write-Host "Right-click on the unassigned space and select New Simple Volume option (Half Size for G: "ContainerApps" and Half Size for H: "Downloads")." -foregroundcolor "red"
Write-Host "Assign Drive G to ContainerApps and Drive H to Downloads. (Formating)" -foregroundcolor "red"
Write-Host "Create New Simple Volume (Max Size) And Assign Drive G to ContainerApps and Drive H to Downloads. (Formating)" -foregroundcolor "red"
Write-Host "Select Format this volume with the other settings option and make sure the other options are selected like (file system, Allocation Unit Size, and Volume Label etc). Click Next >> Finish." -foregroundcolor "red"
Write-Host "The error is normal. Disk Management will open up, and you will need to finish the virtual drive setup. (Initializing - Assigning Next Available Disk Number)" -foregroundcolor "yellow"
Write-Host "Right-click on the unassigned space and select New Simple Volume option (Half Size for G: "ContainerApps" and Half Size for H: "Downloads")." -foregroundcolor "yellow"
Write-Host "Assign Drive G to ContainerApps and Drive H to Downloads. (Formating)" -foregroundcolor "yellow"
Write-Host "Create New Simple Volume (Max Size) And Assign Drive G to ContainerApps and Drive H to Downloads. (Formating)" -foregroundcolor "yellow"
Write-Host "Select Format this volume with the other settings option and make sure the other options are selected like (file system, Allocation Unit Size, and Volume Label etc). Click Next >> Finish." -foregroundcolor "yellow"
pause
diskmgmt.msc
pause

#AutoMount Drives At Startup
#Register-ScheduledTask -xml (Get-Content "C:\Users\Public\Documents\AutoMountVDrives.xml" | Out-String) -TaskName "AutoMountDrives" -TaskPath "C:\Windows\System32\Tasks" –Force

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
}
}

#Set Directory to PSScriptRoot
if ((Get-Location).Path -NE $PSScriptRoot) { Set-Location $PSScriptRoot }


#Recommended Applications
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Let Me Choose","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Recommended Applications"
$mess = "Install recommended applications? 4 in total. If you do, change your Installation Destination to G:\ContainerApps"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	#PowerShell
		#Download file
			#Invoke-WebRequest -Uri https://www.github.com/PowerShell/PowerShell/releases/download/v7.2.4/PowerShell-7.2.4-win-x64.msi -verb RunAs -OutFile .\PowerShell.msi
		#Install file
			#start-process -FilePath ".\PowerShell.msi"
			#Remove-Item '.\PowerShell.msi'
	#Mozilla Thunderbird Portable
		#Download file
			Invoke-WebRequest -Uri https://download.sourceforge.net/portableapps/ThunderbirdPortable_91.9.1_English.paf.exe -verb RunAs -OutFile .\Thunderbird.paf.exe
		#Install file
			start-process -FilePath ".\Thunderbird.paf.exe" -verb RunAs
			Remove-Item '.\Thunderbird.paf.exe'
	#Comodo Dragon Broswer - Chrome Based Broswer ("Secure" Line)
		#Download file
			Invoke-WebRequest -Uri https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe -verb RunAs -OutFile .\dragonsetup.exe
		#Install file
			start-process -FilePath ".\dragonsetup.exe" -Verb runas
			Remove-Item '.\dragonsetup.exe'
	#Ice Dragon Browser - FireFox Based Browser ("UnSecure" Line)
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
}1{
	Push-Location $PSScriptRoot
}
}








#Setup Complete
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$heading = "Setup Complete"
$mess = "Base Settings Applied. Shortcuts are in your Documents folder to create your own sandboxes. Now restarting,"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Push-Location $PSScriptRoot
#Cleanup
Remove-Item ".\Shortcuts"
Remove-Item ".\Scripts"
Remove-Item "C:\Users\Public\Documents\Install.ps1"
Restart-Computer
}
}

#Special Thanks

#(VirtualDrives.ps1) Jeffery Hicks @ https://www.altaro.com/hyper-v/creating-generation-2-disk-powershell/
#(Sandbox.bat Home Edition) Benny @ https://www.deskmodder.de/blog/2019/04/20/windows-10-home-windows-sandbox-installieren-und-nutzen/
#(Hyper-V Home Edition) Usman Khurshid @ https://www.itechtics.com/enable-hyper-v-windows-10-home/

#Community Effort Tools
#Tor Network
#System Hardening

#Chris Titus Tech Toolbox
#Write-Host "Chris Titus Tech Toolbox"
#Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
#iwr -useb https://christitus.com/win | iex



