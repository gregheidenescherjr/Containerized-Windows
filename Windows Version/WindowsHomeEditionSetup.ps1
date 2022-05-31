#Windows Sandbox Home Edition
#This script is for those with Windows Home edition.

#Windows Sandbox script was created by Benny at Deskmodder.
#https://www-deskmodder-de.translate.goog/blog/2019/04/20/windows-10-home-windows-sandbox-installieren-und-nutzen/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en-US######

# URL and Destination
$url = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Sourced%Scripts\Windows%Sandbox%Home%Edition%Script\Sandbox%Installer.bat"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
Start-Process G:\ -Verb RunAs
Write-Host "End of Bennys Windows Sandbox Install Script. Lets Continue..." -ForegroundColor Green
#End of Bennys Windows Sandbox Home Edition script#

pause
Write-Host "Hit Enter to continue..."

#Create Required Directories
New-Item "G:\PortableApps" -itemType Directory
New-Item "G:\Documents" -itemType Directory
New-Item "H:\Picutres" -itemType Directory
New-Item "H:\Downloads" -itemType Directory

#Installs Windows Host Apps
Write-Host "The Following Apps Create Your Containerized Enviornments" -ForegroundColor Green

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
#Change Installation Destination to ContainerApps Drive!!!

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

#Rebooting With Changes
Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "What is the next piece?.ps1")
Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 2