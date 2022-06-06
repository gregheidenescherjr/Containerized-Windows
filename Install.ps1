#Containerized Windows
#Project Initialized on 5/30/2022 by:
#Gregory Heidenescher Jr - Creator/Tester
#Christopher Southerland - Contributor/Tester

#Special Thanks

#(VirtualDrives.ps1) Jeffery Hicks @ https://www.altaro.com/hyper-v/creating-generation-2-disk-powershell/
#(Sandbox.bat Home Edition)
#(Hyper-V Home Edition)

#Chris Titus Tech Toolbox
#Write-Host "Chris Titus Tech Toolbox"
#Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
#iwr -useb https://christitus.com/win | iex

#The main goal is to create a User Experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be compromised, it was all done in a containment area seperate from the main Windows Installation.
#This project, combined with good internet practices, will help seperate personal information when browsing the internet through conatinment and compartmentizing applications.
#We dont need other people to see our credentials during a casual browsing session.

#Term Definitions
#"Secure Sandbox"(Where personal credentials and information is saved and loaded during startup)
#"UnSecure Sandbox" (Where no credentials are stored during startup)

PowerShell -NoProfile -ExecutionPolicy "Unrestricted" -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy "Unrestricted" -File "".\Containerize.ps1""'-Verb RunAs}";

Push-Location $PSScriptRoot

#Copying Required Files
Copy-Item ".\Secure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\UnSecure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\Install.ps1" -Destination "C:\Users\Public\Documents"

#Root Account Setup (Not Working)
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$heading = "Root And User Accounts Setup"
$mess = "Would You Like To Install Root And User Accounts??"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	
	PowerShell -NoProfile -ExecutionPolicy "Unrestricted" -Command "New-LocalUser -Name "Root" -Description "Management Account." -verb runas}"
	
	New-LocalUser -Name "Live User" -Description "User Account." -verb runas
}1{
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
	
	Start-Process "cmd.exe" -ArgumentList ' -ExecutionPolicy "Unrestricted" -File "".\Hyper-V.bat""'-Verb RunAs
	
	pause
	
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

#Sandbox Setup (Not Working)
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
	
	Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy "Unrestricted" -File ""Sandbox.bat""'-Verb RunAs
	
	#Rebooting With Changes
		Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
		$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Users\Public\Documents\Install.ps1")
	pause
Restart-Computer
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

#Virtual Drives Setup (Not Working)
Push-Location $PSScriptRoot
$vhdpath = ".\ContainerApps.vhdx"
$vhdsize = 12GB
New-VHD -Path $vhdpath -Dynamic -SizeBytes $vhdsize | Mount-VHD -Passthru |Initialize-Disk -Passthru |New-Partition -AssignDriveLetter 'G' -UseMaximumSize |Format-Volume -FileSystem NTFS -Confirm:$false -Force
			
$vhdpath = ".\Downloads.vhdx"
$vhdsize = 12GB
New-VHD -Path $vhdpath -Dynamic -SizeBytes $vhdsize | Mount-VHD -Passthru |Initialize-Disk -Passthru |New-Partition -AssignDriveLetter 'H' -UseMaximumSize |Format-Volume -FileSystem NTFS -Confirm:$false -Force

#Creating Shortcuts
$SourceFilePath = "G:\"
$ShortcutPath = "C:\Users\Public\Documents"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()
$SourceFilePath = "H:\"
$ShortcutPath = "C:\Users\Public\Documents"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()

#Creating Directories
#New-Item -FilePath "H:\Documents" -itemType Directory
#New-Item -FilePath "H:\Picutres" -itemType Directory
#New-Item -FilePath "H:\Downloads" -itemType Directory

#Recommended Applications (Functioning Properly)
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Let Me Choose","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Recommended Applications"
$mess = "Install recommended applications? 5 in total. If you do, change your Installation Destination to G:\ContainerApps"
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

#Cleanup
Remove-Item ".\Secure%Internet.wsb"
Remove-Item ".\UnSecure%Internet.wsb"
Remove-Item ".\Hyper-V.bat"
Remove-Item ".\Sandbox.bat"
Remove-Item ".\Virtual Drives.bat"
Remove-Item "C:\Users\Public\Documents\Install.ps1"

#Complete Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Ok","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Setup Complete"
$mess = "Base Settings Applied. Shortcuts are in your Documents folder to create your own sandboxes. Now restarting,"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	Restart-Computer
}
}

