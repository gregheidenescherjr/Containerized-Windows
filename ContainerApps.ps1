#Winget
Write-Host "Downloading Winget" -ForegroundColor Yellow
winget install --id Microsoft.Powershell --source winget
Write-Host "Winget" -ForegroundColor Green

#PowerShell LTS
Write-Host "Downloading PowerShell LTS" -ForegroundColor Yellow
winget install --id Microsoft.Powershell --source winget
Write-Host "PowerShell LTS" -ForegroundColor Green

#Install ContainerApps
#Change Installation Destination to ContainerApps Drive

#Mozilla Thunderbird Portable
Write-Host "Downloading Mozilla Thunderbird Portable" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://downloads.sourceforge.net/portableapps/ThunderbirdPortable_91.9.1_English.paf.exe"
$dest = "G:\"

# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Mozilla Thunderbird Portable" -ForegroundColor Green

# Install file
start-process -FilePath "G:\ThunderbirdPortable_91.9.1_English.paf.exe" -Verb runas -Wait
Write-Host "Mozilla Thunderbird Portable Installed" -ForegroundColor Green

#Comodo Dragon Broswer
Write-Host "Downloading Comodo Dragon Broswer" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe"
$dest = "G:\"

# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Comodo Dragon" -ForegroundColor Green

# Install file
start-process -FilePath "G:\dragonsetup.exe" -Verb runas -Wait
Write-Host "Comodo Dragon Installed" -ForegroundColor Green

#Ice Dragon Browser
Write-Host "Downloading Ice Dragon Browser." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://download.comodo.com/icedragon/update/icedragonsetup.exe"
$dest = "G:\"

# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Ice Dragon" -ForegroundColor Green

# Install file
start-process -FilePath "G:\icedragonsetup.exe" -Verb runas -Wait
Write-Host "Ice Dragon Installed" -ForegroundColor Green

#Notepad++
Write-Host "Downloading Notepad++" -ForegroundColor Yellow
$LocalTempDir = $env:TEMP
$href = ((Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/downloads/').Links | Where-Object { $_.innerText -match 'current version' }).href
$downloadUrl = ((Invoke-WebRequest "https://notepad-plus-plus.org/$href").Links | Where-Object { $_.innerHTML -match 'installer' -and $_.href -match 'x64.exe' }).href
Invoke-RestMethod $downloadUrl -OutFile "$LocalTempDir/np++.exe"
start-process -FilePath "$LocalTempDir\np++.exe" -ArgumentList /InstallDirectoryPath:"G:\PortableApps",/S -Verb runas -Wait
Write-Host "Notepad++ Installed" -ForegroundColor Green

#Download and Install Windows Sandbox
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online



#Rebooting With Changes
#Get-WindowsUpdate
Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "G:\ContainerApps.ps1")
Restart-Computer -Wait -For PowerShell -Timeout 300 -Delay 2


