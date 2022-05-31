#Windows Sandbox Pro Edition
#This script is for those with Windows Pro editions.

#Create Required Directories
New-Item "G:\PortableApps" -itemType Directory
New-Item "G:\Documents" -itemType Directory
New-Item "H:\Picutres" -itemType Directory
New-Item "H:\Downloads" -itemType Directory

#Installs Windows Host Apps
Write-Host "The Following Apps Create Your Containerized Enviornments" -ForegroundColor Green

#Windows Sandbox
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

#PowerShell
# URL and Destination
$url = "https://github.com/PowerShell/PowerShell/releases/download/v7.2.4/PowerShell-7.2.4-win-x64.msi"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "G:\PowerShell-7.2.4-win-x64.msi"
Write-Host "PowerShell Installed" -ForegroundColor Green
Remove-Item 'G:\PowerShell-7.2.4-win-x64.msi'

#Notepad++
Write-Host "Installing Notepad++" -ForegroundColor Yellow
$LocalTempDir = $env:TEMP
$href = ((Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/downloads/').Links | Where-Object { $_.innerText -match 'current version' }).href
$downloadUrl = ((Invoke-WebRequest "https://notepad-plus-plus.org/$href").Links | Where-Object { $_.innerHTML -match 'installer' -and $_.href -match 'x64.exe' }).href
Invoke-RestMethod $downloadUrl -OutFile "$LocalTempDir/np++.exe"
start-process -FilePath "$LocalTempDir\np++.exe" -ArgumentList /InstallDirectoryPath:"G:\PortableApps",/S -Verb runas -Wait
Write-Host "Notepad++ Installed" -ForegroundColor Green

#Installs ContainerApps
#Change Installation Destination to ContainerApps Drive

#Mozilla Thunderbird Portable
Write-Host "Downloading Mozilla Thunderbird Portable" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://download.sourceforge.net/portableapps/ThunderbirdPortable_91.9.1_English.paf.exe"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "G:\ThunderbirdPortable_91.9.1_English.paf.exe" -Verb runas -Wait
Write-Host "Mozilla Thunderbird Portable Installed" -ForegroundColor Green
Remove-Item 'G:\ThunderbirdPortable_91.9.1_English.paf.exe'

#Comodo Dragon Broswer
Write-Host "Downloading Comodo Dragon Broswer" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "G:\dragonsetup.exe" -Verb runas -Wait
Write-Host "Comodo Dragon Installed" -ForegroundColor Green
Remove-Item 'G:\dragonsetup.exe'

#Ice Dragon Browser
Write-Host "Downloading Ice Dragon Browser." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://download.comodo.com/icedragon/update/icedragonsetup.exe"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "G:\icedragonsetup.exe" -Verb runas -Wait
Write-Host "Ice Dragon Installed" -ForegroundColor Green
Remove-Item 'G:\icedragonsetup.exe'

#Portable Apps Menu
Write-Host "Downloading Portable Apps Menu." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://sourceforge.net/projects/portableapps/files/PortableApps.com%20Platform/PortableApps.com_Platform_Setup_21.2.2.paf.exe/download?use_mirror=cytranet"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "G:\PortableApps.com_Platform_Setup_21.2.2.paf.exe" -Verb runas -Wait
Write-Host "Portable Apps Menu" -ForegroundColor Green
Remove-Item 'G:\PortableApps.com_Platform_Setup_21.2.2.paf.exe'

#Enviornments Download
# URL and Destination
$url = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/Secure%Internet.wsb"
$url2 = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/UnSecure%Internet.wsb" 
$url3 = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/Testing%Zone.wsb"
$url4 = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/DefenderRules.wfw"
$url5 = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/Enviornments%Setup.ps1"

$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url $url2 $url3 $url4 $url5 -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
Write-Host "Enviornments Saved to G:\" -ForegroundColor Green


#Rebooting With Changes
Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + G:\Enviornments%Setup.ps1")
Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 2