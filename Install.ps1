#Containerized Windows
#Project Initialized by Gregory Heidenescher Jr and Christopher Southerland 5/30/2022

#The main goal is to create a user experience that exposes as little as possible to the internet while creating a playground for developers.
#Should anything be compromised, it was all done in a containment area seperate from the main Windows Installation.
#This project will help seperate personal information when browsing the internet through conatinment and compartmentizing applications.
#We dont need others to see our credentials during a casual browsing session.

#Term Definitions
#"Secure Sandbox"(Where personal credentials and information is saved and loaded during startup)
#"UnSecure Sandbox" (Where no credentials are stored during startup)

#This will leave you with templates to create your own sandboxes with your prefered applications, should they have a portable version or you want to run them in a contained enviornment.

#Chris Titus Tech Toolbox
#Write-Host "Chris Titus Tech Toolbox"
#Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
#iwr -useb https://christitus.com/win | iex


New-VHD -Path "C:\VirtualDrives.vhdx" -Dynamic -SizeBytes 250GB



diskpart
select vdisk file="Full path of .vhd or .vhdx location"
attach vdisk
create partition primary
format fs=NTFS label="FriendlyName" quick
assign letter=<Drive Letter>



Get-StoragePool
New-VirtualDisk -FriendlyName 'NewVirtualDisk'  `
                -StoragePoolFriendlyName "StoragePool-01" `
                -Size 10GB `
                -ProvisioningType Thin `
                -PhysicalDiskRedundancy 2

Get-VirtualDisk -FriendlyName 'NewVirtualDisk'|Initialize-Disk -PartitionStyle GPT -PassThru
New-Partition -DiskNumber 10 `
              -DriveLetter 'E' `
              -UseMaximumSize
New-Partition -DiskNumber 10 `
              -DriveLetter 'E' `
              -UseMaximumSize
Format-Volume -DriveLetter 'E' `
              -FileSystem NTFS `
              -AllocationUnitSize 65536 `
              -Confirm:$false `
              -Force
Format-Volume -DriveLetter 'E' `
              -FileSystem NTFS `
              -AllocationUnitSize 65536 `
              -Confirm:$false `
              -Force
Get-VirtualDisk


Mount-VHD -Path c:\test\testvhdx.vhdx

Push-Location $PSScriptRoot

Write-Host "BEFORE YOU BEGIN!!!" -ForegroundColor Yellow
Write-Host "Mount all virtual drives.  There are 2 inside." -ForegroundColor Yellow
Write-Host "All 3 Are Dynamically Expanding (Up To 500GB)." -ForegroundColor Yellow

#Root Setup
#This Account Is Your Management Account to Troubleshoot OS Issues

New-LocalUser -Name "Root" -Description "Management Account." -root
New-LocalUser -Name "User" -Description "User Account." -user

Write-Host "Root And User Account Added. Default Passwords = Lowercase Name." -ForegroundColor Yellow

pause

$homee = New-Object System.Management.Automation.Host.ChoiceDescription "&Home Edition","Description."
$pro = New-Object System.Management.Automation.Host.ChoiceDescription "&Pro Edition","Description."
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($homee, $pro, $abort)
$options2 = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$heading = "Containerized Windows"
$mess = "What Version Of Windows Do You Have?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 1)
switch ($rslt) {
0{
Write-Host "Windows Home Edition" -ForegroundColor White

start-process "cmd.exe" "/c D:SandboxInstaller.bat"

pause

#Creating Required Directories
New-Item "C:\PortableApps" -itemType Directory
New-Item "G:\PortableApps" -itemType Directory
New-Item "G:\Documents" -itemType Directory
New-Item "H:\Picutres" -itemType Directory
New-Item "H:\Downloads" -itemType Directory
Copy-Item "D:\Secure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item "D:\UnSecure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Remove-Item "D:\Secure%Internet.wsb
Remove-Item "D:\UnSecure%Internet.wsb

#PowerShell
# URL and Destination
$url = "https://github.com/PowerShell/PowerShell/releases/download/v7.2.4/PowerShell-7.2.4-win-x64.msi"
$dest = "C:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "C:\PowerShell-7.2.4-win-x64.msi"
Write-Host "PowerShell Installed" -ForegroundColor Green
Remove-Item 'C:\PowerShell-7.2.4-win-x64.msi'

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
Remove-Item 'A:\ThunderbirdPortable_91.9.1_English.paf.exe'

#Comodo Dragon Broswer
Write-Host "Downloading Comodo Dragon Broswer" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe"
$dest = "A:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "A:\dragonsetup.exe" -Verb runas -Wait
Write-Host "Comodo Dragon Installed" -ForegroundColor Green
Remove-Item 'A:\dragonsetup.exe'

#Ice Dragon Browser
Write-Host "Downloading Ice Dragon Browser." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://download.comodo.com/icedragon/update/icedragonsetup.exe"
$dest = "A:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "A:\icedragonsetup.exe" -Verb runas -Wait
Write-Host "Ice Dragon Installed" -ForegroundColor Green
Remove-Item 'A:\icedragonsetup.exe'

#Portable Apps Menu
Write-Host "Downloading Portable Apps Menu." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://sourceforge.net/projects/portableapps/files/PortableApps.com%20Platform/PortableApps.com_Platform_Setup_21.2.2.paf.exe/download?use_mirror=cytranet"
$dest = "A:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "A:\PortableApps.com_Platform_Setup_21.2.2.paf.exe" -Verb runas -Wait
Write-Host "Portable Apps Menu" -ForegroundColor Green
Remove-Item 'A:\PortableApps.com_Platform_Setup_21.2.2.paf.exe'

#Rebooting With Changes
Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "D:\EnviornmentsSetup.ps1")
}1{
Write-Host "Windows Pro Edition" -ForegroundColor White
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

#Creating Required Directories
New-Item "C:\PortableApps" -itemType Directory
New-Item "G:\PortableApps" -itemType Directory
New-Item "G:\Documents" -itemType Directory
New-Item "H:\Picutres" -itemType Directory
New-Item "H:\Downloads" -itemType Directory
Copy-Item "D:\Secure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item "D:\UnSecure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Remove-Item "D:\Secure%Internet.wsb
Remove-Item "D:\UnSecure%Internet.wsb

#PowerShell
# URL and Destination
$url = "https://github.com/PowerShell/PowerShell/releases/download/v7.2.4/PowerShell-7.2.4-win-x64.msi"
$dest = "C:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "C:\PowerShell-7.2.4-win-x64.msi"
Write-Host "PowerShell Installed" -ForegroundColor Green
Remove-Item 'C:\PowerShell-7.2.4-win-x64.msi'

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
Remove-Item 'A:\ThunderbirdPortable_91.9.1_English.paf.exe'

#Comodo Dragon Broswer
Write-Host "Downloading Comodo Dragon Broswer" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://cdn.download.comodo.com/browser/release/dragon/x86/dragonsetup.exe"
$dest = "A:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "A:\dragonsetup.exe" -Verb runas -Wait
Write-Host "Comodo Dragon Installed" -ForegroundColor Green
Remove-Item 'A:\dragonsetup.exe'

#Ice Dragon Browser
Write-Host "Downloading Ice Dragon Browser." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://download.comodo.com/icedragon/update/icedragonsetup.exe"
$dest = "A:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "A:\icedragonsetup.exe" -Verb runas -Wait
Write-Host "Ice Dragon Installed" -ForegroundColor Green
Remove-Item 'A:\icedragonsetup.exe'

#Portable Apps Menu
Write-Host "Downloading Portable Apps Menu." -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor Yellow
Write-Host "YOU MUST INSTALL PORTABLE VERSION IN CONTAINER APP DRIVE!!!" -ForegroundColor RED
# URL and Destination
$url = "https://sourceforge.net/projects/portableapps/files/PortableApps.com%20Platform/PortableApps.com_Platform_Setup_21.2.2.paf.exe/download?use_mirror=cytranet"
$dest = "A:\"
# Download file
Start-BitsTransfer -Source $url -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
# Install file
start-process -FilePath "A:\PortableApps.com_Platform_Setup_21.2.2.paf.exe" -Verb runas -Wait
Write-Host "Portable Apps Menu" -ForegroundColor Green
Remove-Item 'A:\PortableApps.com_Platform_Setup_21.2.2.paf.exe'

#Rebooting With Changes
Write-Host "Rebooting With Changes." -foregroundcolor "magenta"
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" (C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File "D:\EnviornmentsSetup.ps1")

}2{
Write-Host "Cancel" -ForegroundColor Red
}
}


#Notepad++
#Write-Host "Installing Notepad++" -ForegroundColor Yellow
#$LocalTempDir = $env:TEMP
#$href = ((Invoke-WebRequest -Uri 'https://notepad-plus-plus.org/downloads/').Links | Where-Object { $_.innerText -match 'current version' }).href
#$downloadUrl = ((Invoke-WebRequest "https://notepad-plus-plus.org/$href").Links | Where-Object { $_.innerHTML -match 'installer' -and $_.href -match 'x64.exe' }).href
#Invoke-RestMethod $downloadUrl -OutFile "$LocalTempDir/np++.exe"
#start-process -FilePath "$LocalTempDir\np++.exe" -ArgumentList /InstallDirectoryPath:"C:\PortableApps",/S -Verb runas -Wait
#Write-Host "Notepad++ Installed" -ForegroundColor Green