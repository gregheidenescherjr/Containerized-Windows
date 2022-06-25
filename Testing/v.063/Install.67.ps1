PowerShell -NoProfile -ExecutionPolicy "Unrestricted" -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy "Unrestricted" -File "".\Install.ps1""'-Verb RunAs}";

#Set Directory to PSScriptRoot
if ((Get-Location).Path -NE $PSScriptRoot) { Set-Location $PSScriptRoot }

#I Need help. Awesome welcome script. How to work as welcome message header?

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('                          Containerized Windows Setup.
    Containerized Windows
    Project Initialized on 5/30/2022 
                                by:
    Gregory Heidenescher Jr - Creator/Tester
    Christopher Southerland - Creator/Alpha Tester
  
                                             Tested On:
 Edition	Windows 11 Pro -Version	21H2
 Installed on	2/28/2022 -OS build	22000.708
 Experience	Windows Feature Experience Pack
 1000.22000.708.0
 Processor	AMD Ryzen 9 5900X 12-Core Processor
 3.70 GHz
 Installed RAM	64.0 GB
 System type	64-bit operating system, x64-based processor


                          Special Thanks for the Public Material!


-Microsoft @ https://docs.microsoft.com/en-us/

-(Hyper-V Home Edition) Usman Khurshid @ https://www.itechtics.com/enable-hyper-v-windows-10-home/

-(Sandbox Home Edition) Benny @ https://www.deskmodder.de/blog/2019/04/20/windows-10-home-windows-sandbox-installieren-und-nutzen/

-(ScoopBoxManager) LAB02-Research @ https://github.com/LAB02-Research/ScoopBoxManager

-(Ketarin) Canneverbe @ https://github.com/canneverbe/Ketarin

')}" 

#Virtual Drives Setup
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$mess = "Creating Virtual Apps, Downloads, and Email drives."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Start-Process "cmd.exe" -File ".\Containerize\Scripts\VMs.bat" -Verb RunAs

#Virtual Drives Setup (Something is broken with Initializing. Must be done manually.)
New-VHD -Path "C:\Users\Public\Documents\Apps.vhdx" -Dynamic -SizeBytes 120GB 
New-VHD -Path "C:\Users\Public\Documents\Downloads.vhdx" -Dynamic -SizeBytes 120GB 
New-VHD -Path "C:\Users\Public\Documents\Email.vhdx" -Dynamic -SizeBytes 20GB 
Mount-VHD -path "C:\Users\Public\Documents\Apps.vhdx"
Mount-VHD -path "C:\Users\Public\Documents\Downloads.vhdx"
Mount-VHD -path "C:\Users\Public\Documents\Email.vhdx"
Write-Host "You will have to manually initialize and exit Drive Management. This is a current bug with powershell." -foregroundcolor "Yellow"
pause
Write-Host "After Initializing, remember your disk number if you need to edit this script for yourself." -foregroundcolor "Yellow"
pause
Start-Process diskmgmt.msc
pause
Get-VHD -path "C:\Users\Public\Documents\Apps.vhdx"
New-Partition -DiskNumber 2 -Size 120GB -DriveLetter A | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Get-VHD -path "C:\Users\Public\Documents\Downloads.vhdx"
New-Partition -DiskNumber 3 -Size 120GB -DriveLetter B | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Get-VHD -path "C:\Users\Public\Documents\Email.vhdx"
New-Partition -DiskNumber 4 -Size 20GB -DriveLetter L | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Write-Host "Virtual Drives Enabled" -foregroundcolor "green"	
}
}"

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('
                                            -The main goal!!!!!

    Is to create a User Experience that exposes as little as
    possible to the internet while creating a playground for
    developers.Should anything be compromised, it was all done
    in a containment area seperate from the main Windows Installation.
    This project, combined with good internet practices...
    
    Will help seperate personal information when browsing
    the internet through conatinment and compartmentizing
    applications. We dont need other people to see our 
    credentials during a casual browsing session.

    If you make changes to this, please make it easy to identify 
    by adding your name to the main task you edited. It will be easier
    later down the road. Thank You.

    I will later make a word document that will have highlights on
    recommended user changes. If a way to simplify, please share.')}"

#Root User Setup
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$heading = "Containerized Windows Setup"
$mess = "Would You Like To Install Root And User Accounts??"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Push-Location $PSScriptRoot
Start-Process "cmd.exe" -File ".\Containerize\Scripts\Users.bat""" -Verb RunAs
}1{
Push-Location $PSScriptRoot
}}
                   


#Creating Shortcuts and Directories
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$mess = "Creating Shortcuts and Directories."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
	0{
$SourceFilePath = "G:\"
$ShortcutPath = "C:\Users\Public\Documents\Apps.lnk"
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

Copy-Item ".\Secure Internet.wsb" -Destination "C:\Users\Public\Documents"
Copy-Item ".\UnSecure Internet.wsb" -Destination "C:\Users\Public\Documents"

Write-Host "Shortcuts and Directories Enabled" -foregroundcolor "Green"
}
}

#Recommended Applications (Ketarin)
$abort = New-Object System.Management.Automation.Host.ChoiceDescription "&Let Me Choose","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $abort)
$mess = "Install recommended applications?"
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
	Push-Location $PSScriptRoot
		#Ketarin
		Copy-Item .\Containerize\InitialSetups -Destination G:\ -recurse -Force -PassThru
			#Install file
			start-process -FilePath ".\Containerize\InitialSetups\Ketarin\Released\Ketarin-1.8.11\Ketarin.exe" -Verb runas
			Remove-Item '.\Containerize\InitialSetups\'
	Write-Host "Recomended Applications Installed" -foregroundcolor "green"
}1{
	Push-Location $PSScriptRoot
}
}

#Setup Complete
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$mess = "Base Settings Applied.
Shortcuts are in your Documents folder to create your own sandboxes.
Please Restart your system."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Push-Location $PSScriptRoot
#Cleanup

#AutoMount Drives At Startup
Register-ScheduledTask -xml (Get-Content "C:\Users\Public\Documents\AutoMountVDrives.xml" | Out-String) -TaskName "AutoMountDrives" -TaskPath "C:\Windows\System32\Tasks" –Force

Write-Host "Sandbox User Folders: %PROGRAMDATA%\Microsoft\Windows\Containers\<GUID>\BaseLayer\Files\Users\WDAGUtilityAccount\Documents" "
pause
Restart-Computer
}
}


#Things I might use later...

#Remove Apps
#Get-AppXPackage *bingweather* | Remove-AppXPackage

#Prevent install for new users
#Get-AppxProvisionedPackage -online | select PackageName

#$appname = @(
#"*BingWeather*"
#"*ZuneMusic*"
#"*ZuneVideo*"
#)

#ForEach($app in $appname){
#Get-AppxProvisionedPackage -Online | where {$_.PackageName -like $app} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
#