#Containerized Windows
#Project Initialized by Gregory Heidenescher Jr and Christopher Southerland 5/30/2022

#The main goal is to create a User Experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be compromised, it was all done in a containment area seperate from the main Windows Installation.
#This project, combined with good internet practices, will help seperate personal information when browsing the internet through conatinment and compartmentizing applications.
#We dont need other people to see our credentials during a casual browsing session.

#Term Definitions
#"Secure Sandbox"(Where personal credentials and information is saved and loaded during startup)
#"UnSecure Sandbox" (Where no credentials are stored during startup)

Push-Location $PSScriptRoot
Invoke-WebRequest -Uri https://github.com/gregheidenescherjr/Containerized-Windows/Install.ps1 -OutFile C:\Install.ps1
Invoke-WebRequest -Uri https://github.com/gregheidenescherjr/Containerized-Windows/Hyper-V.bat -OutFile .\Hyper-V.bat
Invoke-WebRequest -Uri https://github.com/gregheidenescherjr/Containerized-Windows/Sandbox.bat -OutFile .\Sandbox.bat
Invoke-WebRequest -Uri https://github.com/gregheidenescherjr/Containerized-Windows/VirtualDrives.bat -OutFile .\VirtualDrives.bat

#Root Account Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Root And User Accounts Setup"
$mess = "Would You Like To Install Root And User Accounts??"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	New-LocalUser -Name "Root" -Description "Management Account." -root
	New-LocalUser -Name "User" -Description "User Account." -user
}1{
	Push-Location $PSScriptRoot
}
}

#Hyper-V Setup
$homee = New-Object System.Management.Automation.Host.ChoiceDescription "&Home","Description."
$pro = New-Object System.Management.Automation.Host.ChoiceDescription "&Pro","Description."
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Installed","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Hyper-V Setup"
$mess = "What Version Of Hyper-V Do You Need?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	Write-Host "Windows Home" -ForegroundColor Green
	start-process "cmd.exe" "/c .\Hyper-V.bat"
	pause
	#Rebooting With Changes
	Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
	$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
	set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Install.ps1")
	Restart-Computer
}1{
	Push-Location $PSScriptRoot
	Write-Host "Windows Pro" -ForegroundColor Green
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
	#Rebooting With Changes
	Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
	$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
	set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Install.ps1")
	Restart-Computer
}2{
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
	Write-Host "Windows Home Edition" -ForegroundColor Green
	start-process "cmd.exe" "/c .\Sandbox.bat"
	pause 
		#Rebooting With Changes
		Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
		$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Install.ps1")
	Restart-Computer
}1{
	Push-Location $PSScriptRoot
	Write-Host "Windows Pro Edition" -ForegroundColor Green
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
		#Rebooting With Changes
		Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
		$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "C:\Install.ps1")
	Restart-Computer

}2{
	Push-Location $PSScriptRoot
	Write-Host "Sandbox Installed" -ForegroundColor Green
}
}

#Virtual Drives Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Ok","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Virtual Drives Setup"
$mess = "Virtual Drives Setup"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
		#Creating Virtual Drives
			New-VHD -Path ".\VirtualDrives.vhdx" -Dynamic -SizeBytes 240GB 
			pause
		#Select Drive
			start-process -FilePath ".\virtualdrives.bat"
			pause
}
}

Push-Location $PSScriptRoot

#Creating Directories
New-Item ".\PortableApps" -itemType Directory
New-Item ".\Documents" -itemType Directory
New-Item ".\Picutres" -itemType Directory
New-Item ".\Downloads" -itemType Directory
#Copying Required Files
Copy-Item ".\Secure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item ".\UnSecure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item ".\Secure%Internet.wsb" -Destination ".\"
Copy-Item ".\Secure%Internet.wsb" -Destination ".\"

#Recommended Applications
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Let Me Choose","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Recommended Applications"
$mess = "Install Recommended Applications? If You Do, Change Installation Destination to ContainerApps Drive!!!"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	#PowerShell
		#Download file
			Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.2.4/PowerShell-7.2.4-win-x64.msi -OutFile .\PowerShell.msi
		#Install file
			start-process -FilePath ".\PowerShell.msi"
			Remove-Item '.\PowerShell.msi'
	#Mozilla Thunderbird Portable
		#Download file
			Invoke-WebRequest -Uri https://download.sourceforge.net/portableapps/ThunderbirdPortable_91.9.1_English.paf.exe -OutFile .\Thunderbird.paf.exe
		#Install file
			start-process -FilePath ".\Thunderbird.paf.exe" -Verb runas -Wait
			Remove-Item '.\ThunderbirdPortable_91.9.1_English.paf.exe'
	#Comodo Dragon Broswer
		#Download file
			Invoke-WebRequest -Uri https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe -OutFile .\dragonsetup.exe
		#Install file
			start-process -FilePath ".\dragonsetup.exe" -Verb runas -Wait
			Remove-Item '.\dragonsetup.exe'
	#Ice Dragon Browser
		#Download file
			Invoke-WebRequest -Uri https://download.comodo.com/icedragon/update/icedragonsetup.exe -OutFile .\icedragonsetup.exe 
		#Install file
			start-process -FilePath ".\icedragonsetup.exe" -Verb runas -Wait
			Remove-Item '.\icedragonsetup.exe'
	#Portable Apps Menu
		#Download file
			Invoke-WebRequest -Uri https://sourceforge.net/projects/portableapps/files/PortableApps.com%20Platform/PortableApps.com_Platform_Setup_21.2.2.paf.exe/download?use_mirror=cytranet -OutFile .\PortableApps.paf.exe
		#Install file
			start-process -FilePath ".\PortableApps.exe" -Verb runas -Wait
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
Remove-Item ".\PowerShell.msi"
Remove-Item ".\Thunderbird.paf.exe"
Remove-Item ".\dragonsetup.exe"
Remove-Item ".\icedragonsetup.exe"
Remove-Item ".\PortableApps.paf.exe"
Remove-Item "C:\Install.ps1"

#Complete Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Ok","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Setup Complete"
$mess = "This will leave you with templates to create your own sandboxes with your prefered applications."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	Restart-Computer
}
}

#Chris Titus Tech Toolbox
#Write-Host "Chris Titus Tech Toolbox"
#Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
#iwr -useb https://christitus.com/win | iex
