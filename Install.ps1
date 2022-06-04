#Containerized Windows
#Project Initialized by Gregory Heidenescher Jr and Christopher Southerland 5/30/2022

#The main goal is to create a User Experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be compromised, it was all done in a containment area seperate from the main Windows Installation.
#This project will help seperate personal information when browsing the internet through conatinment and compartmentizing applications.
#We dont need others to see our credentials during a casual browsing session.

#Term Definitions
#"Secure Sandbox"(Where personal credentials and information is saved and loaded during startup)
#"UnSecure Sandbox" (Where no credentials are stored during startup)

#This will leave you with templates to create your own sandboxes with your prefered applications, should they have a portable version or you want to run them in a contained enviornment.

Push-Location $PSScriptRoot

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
	Write-Host "Root And User Account Added. Default Passwords = Lowercase Name." -ForegroundColor Green
}1{
	Push-Location $PSScriptRoot
}
}

#Hyper-V Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
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
	Restart-Computer
}1{
	Push-Location $PSScriptRoot
	Write-Host "Windows Pro" -ForegroundColor Green
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
}2{
	Push-Location $PSScriptRoot
	Write-Host "Hyper-V Enabled" -ForegroundColor Green
}
}

#Sandbox Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Sandbox Setup"
$mess = "What Version Of Sandbox Do You Need?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	Write-Host "Windows Home Edition" -ForegroundColor Green
	start-process "cmd.exe" "/c .\Sandbox.bat"
	pause 
	Restart-Computer
}1{
	Push-Location $PSScriptRoot
	Write-Host "Windows Pro Edition" -ForegroundColor Green
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

}2{
	Push-Location $PSScriptRoot
	Write-Host "Sandbox Installed" -ForegroundColor Green
}
}

#Virtual Drives Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Virtual Drives Setup"
$mess = "Virtual Drives Setup?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
	Write-Host "Windows Home Edition" -ForegroundColor Green
		#Creating Virtual Drives
			New-VHD -Path ".\VirtualDrives.vhdx" -Dynamic -SizeBytes 240GB 
		pause
	
		start-process -FilePath ".\virtualdrives.bat"
		pause
}1{
	Push-Location $PSScriptRoot
	Write-Host "Windows Pro Edition" -ForegroundColor Green
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

}
}

Push-Location $PSScriptRoot

#Creating Required Directories And Clean Up
	New-Item ".\PortableApps" -itemType Directory
	New-Item ".\Documents" -itemType Directory
	New-Item ".\Picutres" -itemType Directory
	New-Item ".\Downloads" -itemType Directory
	Copy-Item ".\Secure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
	Copy-Item ".\UnSecure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
	Copy-Item ".\Secure%Internet.wsb" -Destination ".\"
	Copy-Item ".\Secure%Internet.wsb" -Destination ".\"
	Remove-Item ".\Secure%Internet.wsb"
	Remove-Item ".\UnSecure%Internet.wsb"
	Remove-Item ".\Hyper-V.bat"
	Remove-Item ".\Sandbox.bat"
	Remove-Item ".\Virtual Drives.bat"

#Recommended Applications
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Recommended Applications"
$mess = "Would You Like To Install Recommended Applications. Change Installation Destination to ContainerApps Drive!!!"
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
			Invoke-WebRequest -Uri https://download.sourceforge.net/portableapps/ThunderbirdPortable_91.9.1_English.paf.exe -OutFile .\Thunderbird.exe
		#Install file
			start-process -FilePath ".\Thunderbird.exe" -Verb runas -Wait
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
			Invoke-WebRequest -Uri https://sourceforge.net/projects/portableapps/files/PortableApps.com%20Platform/PortableApps.com_Platform_Setup_21.2.2.paf.exe/download?use_mirror=cytranet -OutFile .\PortableApps.exe
		#Install file
			start-process -FilePath ".\PortableApps.exe" -Verb runas -Wait
			Remove-Item '.\PortableApps.com_Platform_Setup_21.2.2.paf.exe'

}1{
	Push-Location $PSScriptRoot
	
}
}

Restart-Computer

#Rebooting With Changes
#Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
#$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
#set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "D:\EnviornmentsSetup.ps1")
#Restart-Computer

#Notepad++
#Write-Host "Installing Notepad++" -ForegroundColor Yellow
#$LocalTempDir = $env:TEMP
#$href = ((Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/downloads/').Links | Where-Object { $_.innerText -match 'current version' }).href
#$downloadUrl = ((Invoke-WebRequest "https://notepad-plus-plus.org/$href").Links | Where-Object { $_.innerHTML -match 'installer' -and $_.href -match 'x64.exe' }).href
#Invoke-RestMethod $downloadUrl -OutFile "$LocalTempDir/np++.exe"
#start-process -FilePath "$LocalTempDir\np++.exe" -ArgumentList /InstallDirectoryPath:"C:\PortableApps",/S -Verb runas -Wait
#Write-Host "Notepad++ Installed" -ForegroundColor Green

#Chris Titus Tech Toolbox
#Write-Host "Chris Titus Tech Toolbox"
#Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
#iwr -useb https://christitus.com/win | iex
