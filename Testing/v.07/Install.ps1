title Remember, Containerized-Windows Installer 
#Note from Gregory Heidenescher Jr.
#If anything comes from this project. No I am not certified. I got high and said, "Lets try something...", and this is the evolution of it...
#You dont need a formal education to learn this stuff, just a natrual curiosity.
#I am a nerd, not as big as others, but my curiosity to learn something can be shown in this project.
#I battle depression, and this can be considered a distraction from my dark thoughts.
#So yes, it is always good to learn something...

Write-Warning "You are using this at your own risk.
This will ask you to create additional User Accounts.
This will create virtual drives on your computer.
This will show you my reccomended applicantions with predefined locations.
This will Make Changes to your current Windows Installation.
Potentialy locking you out of some features for what I think should be a personal security concern.
Do you accept the risk?

P.S.
This will not make you anonymous... 
This is just what I did with public information and boredom." -WarningAction Inquire
#Run current script as Admin.
PowerShell -NoProfile -ExecutionPolicy "Unrestricted" -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy "Unrestricted" -File "".\Install.ps1""'-Verb RunAs}";
#Set Directory to PSScriptRoot
if ((Get-Location).Path -NE $PSScriptRoot) { Set-Location $PSScriptRoot }

#Suspend-BitLocker -MountPoint "C:"
Clear-Host
get-childitem
get-childitem cert:\. -recurse -codesigningcert

#User OS Information
PROCESS {
    write-host "[$ComputerName]"

    if( (Test-Connection $ComputerName -Quiet -count 1)) {
        $osinfo = Get-CimInstance Win32_OperatingSystem -computer $ComputerName | select Name, version, servicepackmajorversion, BuildNumber, CSName, OSArchitecture, OperatingSystemSKU

        $os = $osinfo.Name     # OS Name
        $bitness = $osinfo.OSArchitecture  # 32 or 64 bit
        $build = $osinfo.BuildNumber       # Build Number
        $machineName = $osinfo.CSName      # Name of the machine
        $edition = $osinfo.OperatingSystemSKU  # Windows Edition (home, enterprise etc)

        "Computer: $ComputerName Build: $build   Bitness: $bitness   Edition: $edition"

        # "Full OS String: $os"
        if ($Logfile) {"$ComputerName : $build : $bitness : $edition" | out-file -append -filepath $Logfile}        
    }
    else {
        Write-Error "$ComputerName Not Responding"
    }
}  
#endregion User OS Information

#Function Test-Demo
# {
#  Param ($Param1)
#  Begin{ write-host "Starting"}
#  Process{ write-host "processing" $_ for $Param1}
#  End{write-host "Ending"}
# }
#Echo Testing1, Testing2 | Test-Demo Sample

###################################################################################
# Update to Current 
###################################################################################
#region
$update = {
#Get the Windows capabilities for the local operating system:#
Get-WindowsCapability -Online
#Install all the available RSAT tools:
#Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
#List the currently installed RSAT tools:
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property Name, State

#Install all available Web features:
#Get-WindowsFeature Web-* | Add-WindowsFeature

#Grab Current
$m = Get-Module -ListAvailable BitsTransfer, ServerManager
Import-Module -ModuleInfo $m
#Update help for all modules and ignore any errors
Update-Help -force -erroraction silentlycontinue
#Update all modules
Update-Module
#List Current "User OS Features"
#Get-WindowsOptionalFeature –Online
Get-WindowsOptionalFeature –Online | Where {$_.state -eq 'Disabled'} | Select FeatureName | Sort FeatureName
#Get-WindowsOptionalFeature –Path "c:\offline" –PackageName "Microsoft-Windows-Backup-Package~31bf3856ad364e35~x86~~6.1.7601.16525"
#Get-WindowsOptionalFeature –Path "c:\offline" –FeatureName "MyFeature" –PackagePath "c:\packages\package.cab"

#Find-Package            Find software packages in available package sources.
#Install-Package            Install one or more software packages.
#Uninstall-Package            Uninstall one or more software packages.

#Install a PowerShell module from a local server:
#Register-PSRepository -Name 'Containerize Windows' -SourceLocation '.\'
#Install-Module 'Containerize-Module' -Repository 'Containerized Windows'
}
#Invoke-Command -ScriptBlock $update

#endregion

###################################################################################
# Welcome Message / User Setup
###################################################################################
#region
powershell -WindowStyle Normal -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('                          Containerized Windows Setup.
    Containerized Windows
	
	This installer does not have a GUI
	Nor is it pretty.
	Everything was made with what I learned about PowerShell.
    
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
')}"

powershell -WindowStyle Normal -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('                          Containerized Windows Setup.
                          Special Thanks for the Public Material!


- Microsoft @ https://docs.microsoft.com/en-us/

- SS64 @ https://ss64.com/ps

- ChrisTitusTech @ https://github.com/ChrisTitusTech

- Alex_Muc @ https://social.technet.microsoft.com/Forums/en-US/888ba154-79cd-41cf-8789-355374156b18/create-vhd-with-powershell-fails-solved

-(Hyper-V Home Edition) Usman Khurshid @ https://www.itechtics.com/enable-hyper-v-windows-10-home/

-(Sandbox Home Edition) Benny @ https://www.deskmodder.de/blog/2019/04/20/windows-10-home-windows-sandbox-installieren-und-nutzen/

-(ScoopBoxManager) LAB02-Research @ https://github.com/LAB02-Research/ScoopBoxManager

-(Ketarin) Canneverbe @ https://github.com/canneverbe/Ketarin

- (How to organize code) MCP Mag @ https://mcpmag.com/articles/2018/03/22/organizing-powershell-code-regions.aspx
')}"


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
Start-Process "cmd.exe" -File ".\Containerize\Scripts\Users.bat""" -Verb RunAs -Wait | Out-Null
}1{
Push-Location $PSScriptRoot
}}
#endregion

###################################################################################
#Welcome Message / Virtual Hard Drive Setup (Missing Header)
###################################################################################
#region
powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('
                                            -The main goal!!!!!

    Is to create a User Experience that exposes as little as
    possible to the internet while creating a playground for
    developers.
	
	Should anything be compromised, it was all done
    in a containment area seperate from the main Windows Installation.
    
	This project, combined with good internet practices...
    
    Will help seperate personal information when browsing
    the internet through conatinment and compartmentizing
    applications.

	We dont need other people to see our credentials during
	a casual browsing session.

    If you make changes to this, please make it easy to identify 
    by adding your name to the main task you edited. It will be easier
    later down the road. Thank You.

    I will later make a word document that will have highlights on
    recommended user changes.

	If a way to simplify, please share.
')}"

#Virtual Drives Setup
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes)
$mess = "Creating Virtual Apps, Downloads, and Email drives."
$rslt = $host.ui.PromptForChoice($heading, $mess, $options, 0)
switch ($rslt) {
0{
Start-Process "cmd.exe" -File ".\Containerize\Scripts\VMs.bat" -Verb RunAs | Out-Null

#Virtual Drives Setup
#(Something is broken with PowerShell Initializing. Must be done manually.)
#https://social.technet.microsoft.com/Forums/en-US/888ba154-79cd-41cf-8789-355374156b18/create-vhd-with-powershell-fails-solved

#Diskpart Format from Powershell. Can I create self writing scripts to seperate concepts?
#NEW-ITEM -Force -path "C:\TEMP" -name diskpartVHD.txt -itemtype "file"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "create vdisk file=$File type=expandable maximum=73728"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "select vdisk file=$File"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "attach vdisk"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "convert gpt"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "create partition primary"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "format FS=NTFS LABEL=""Recovery"" QUICK"
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "assign mount=""C:\SYSBackup"""
#        ADD-CONTENT -Path "C:\TEMP\diskpartVHD.txt" "exit"
#DISKPART /S "C:\TEMP\diskpartVHD.txt"
#Remove-Item "C:\TEMP\diskpartVHD.txt"

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
Start-Process diskmgmt.msc -Wait
pause
Get-VHD -path "C:\Users\Public\Documents\Apps.vhdx"
New-Partition -DiskNumber 2 -Size 120GB -DriveLetter G | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Get-VHD -path "C:\Users\Public\Documents\Downloads.vhdx"
New-Partition -DiskNumber 3 -Size 120GB -DriveLetter H | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Get-VHD -path "C:\Users\Public\Documents\Email.vhdx"
New-Partition -DiskNumber 4 -Size 20GB -DriveLetter Y | Format-Volume -FileSystem NTFS -Confirm:$false -Force
Write-Host "Virtual Drives Enabled" -foregroundcolor "green"	
}
}
#endregion

###################################################################################
# Copying Files (Missing Header)
###################################################################################
#region
#Ketarin (Consider Add-Type -LiteralPath "$packagesRoot\Data.dll")

#Note that you should be running PowerShell as an Administrator
#[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")            
#$publish = New-Object System.EnterpriseServices.Internal.Publish            
#$publish.GacInstall("C:\Path\To\DLL.dll")
#If installing into the GAC on a server hosting web applications in IIS, you need to restart IIS for the applications to pick up the change.
#Uncomment the next line if necessary...
#iisreset

Copy-Item .\Containerize\InitialSetups -Destination G:\ -recurse -Force -PassThru
#Open File
start-process -FilePath ".\Containerize\InitialSetups\Ketarin\Released\Ketarin-1.8.11\Ketarin.exe" -Verb runas -Wait | Out-Null
Remove-Item '.\Containerize\InitialSetups\'
Write-Host "Recomended Applications Installed" -foregroundcolor "green"

#Creating Shortcuts and Directories
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
$SourceFilePath = "Y:\"
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
Copy-Item ".\Containerize\Scripts\AutoMount.xml" -Destination "C:\Users\Public\Documents"
Copy-Item ".\Secure Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item ".\UnSecure Internet.wsb" -Destination "C:\Users\Public\Desktop"

Write-Host "Shortcuts and Directories Created" -foregroundcolor "Green"
#endregion

$system-harden = {     
###################################################################################
# System Hardening (From ChrisTitusTech) (Missing DOD Security (TENS Source?) - VM Disabling)
###################################################################################
#region
$Bloatware = @(
        #Unnecessary Windows 10 AppX Apps
        "Microsoft.3DBuilder"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.AppConnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.BingFoodAndDrink"
        "Microsoft.BingHealthAndFitness"
        "Microsoft.BingTravel"
        "Microsoft.MinecraftUWP"
        "Microsoft.GamingServices"
        # "Microsoft.WindowsReadingList"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.Sway"
        "Microsoft.Office.OneNote"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.Print3D"
        "Microsoft.SkypeApp"
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"
        "Microsoft.WindowsAlarms"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.XboxApp"
        "Microsoft.ConnectivityStore"
        "Microsoft.CommsPhone"
        "Microsoft.ScreenSketch"
        "Microsoft.Xbox.TCUI"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxGameCallableUI"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.MixedReality.Portal"
        "Microsoft.XboxIdentityProvider"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        #"Microsoft.YourPhone"
        "Microsoft.Getstarted"
        "Microsoft.MicrosoftOfficeHub"

        #Sponsored Windows 10 AppX Apps
        #Add sponsored/featured apps to remove in the "*AppName*" format
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Facebook*"
        "*Royal Revolt*"
        "*Sway*"
        "*Speed Test*"
        "*Dolby*"
        "*Viber*"
        "*ACGMediaPlayer*"
        "*Netflix*"
        "*OneCalendar*"
        "*LinkedInforWindows*"
        "*HiddenCityMysteryofShadows*"
        "*Hulu*"
        "*HiddenCity*"
        "*AdobePhotoshopExpress*"
        "*HotspotShieldFreeVPN*"

        #Optional: Typically not removed but you can if you need to
        "*Microsoft.Advertising.Xaml*"
        "*Microsoft.MSPaint*"
        #"*Microsoft.MicrosoftStickyNotes*"
        "*Microsoft.Windows.Photos*"
        #"*Microsoft.WindowsCalculator*"
        #"*Microsoft.WindowsStore*"
        )

Write-Host "Removing Bloatware"

foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Host "Trying to remove $Bloat."
    }

Write-Host "Finished Removing Bloatware Apps"

$services = @(
            "ALG"                                          # Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
            "AJRouter"                                     # Needed for AllJoyn Router Service
            "BcastDVRUserService_48486de"                  # GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
            #"BDESVC"                                      # Bitlocker Drive Encryption Service
            #"BFE"                                         # Base Filtering Engine (Manages Firewall and Internet Protocol security)
            #"BluetoothUserService_48486de"                # Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session.
            #"BrokerInfrastructure"                        # Windows Infrastructure Service (Controls which background tasks can run on the system)
            "Browser"                                      # Let users browse and locate shared resources in neighboring computers
            "BthAvctpSvc"                                  # AVCTP service (needed for Bluetooth Audio Devices or Wireless Headphones)
            "CaptureService_48486de"                       # Optional screen capture functionality for applications that call the Windows.Graphics.Capture API.
            "cbdhsvc_48486de"                              # Clipboard Service
            "diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
            "DiagTrack"                                    # Diagnostics Tracking Service
            "dmwappushservice"                             # WAP Push Message Routing Service
            "DPS"                                          # Diagnostic Policy Service (Detects and Troubleshoots Potential Problems)
            "edgeupdate"                                   # Edge Update Service
            "edgeupdatem"                                  # Another Update Service
            "EntAppSvc"                                    # Enterprise Application Management.
            "Fax"                                          # Fax Service
            "fhsvc"                                        # Fax History
            "FontCache"                                    # Windows font cache
            #"FrameServer"                                 # Windows Camera Frame Server (Allows multiple clients to access video frames from camera devices)
            "gupdate"                                      # Google Update
            "gupdatem"                                     # Another Google Update Service
            "iphlpsvc"                                     # ipv6(Most websites use ipv4 instead)
            "lfsvc"                                        # Geolocation Service
            #"LicenseManager"                              # Disable LicenseManager (Windows Store may not work properly)
            "lmhosts"                                      # TCP/IP NetBIOS Helper
            "MapsBroker"                                   # Downloaded Maps Manager
            "MicrosoftEdgeElevationService"                # Another Edge Update Service
            "MSDTC"                                        # Distributed Transaction Coordinator
            "ndu"                                          # Windows Network Data Usage Monitor (Disabling Breaks Task Manager Per-Process Network Monitoring)
            "NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
            "PcaSvc"                                       # Program Compatibility Assistant Service
            "PerfHost"                                     # Remote users and 64-bit processes to query performance.
            "PhoneSvc"                                     # Phone Service(Manages the telephony state on the device)
            #"PNRPsvc"                                     # Peer Name Resolution Protocol (Some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
            #"p2psvc"                                      # Peer Name Resolution Protocol(Enables multi-party communication using Peer-to-Peer Grouping.  If disabled, some applications, such as HomeGroup, may not function. Discord will still work)iscord will still work)
            #"p2pimsvc"                                    # Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly. Discord will still work)
            "PrintNotify"                                  # Windows printer notifications and extentions
            "QWAVE"                                        # Quality Windows Audio Video Experience (audio and video might sound worse)
            "RemoteAccess"                                 # Routing and Remote Access
            "RemoteRegistry"                               # Remote Registry
            "RetailDemo"                                   # Demo Mode for Store Display
            "RtkBtManServ"                                 # Realtek Bluetooth Device Manager Service
            "SCardSvr"                                     # Windows Smart Card Service
            "seclogon"                                     # Secondary Logon (Disables other credentials only password will work)
            "SEMgrSvc"                                     # Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
            "SharedAccess"                                 # Internet Connection Sharing (ICS)
            #"Spooler"                                     # Printing
            "stisvc"                                       # Windows Image Acquisition (WIA)
            #"StorSvc"                                     # StorSvc (usb external hard drive will not be reconized by windows)
            "SysMain"                                      # Analyses System Usage and Improves Performance
            "TrkWks"                                       # Distributed Link Tracking Client
            #"WbioSrvc"                                    # Windows Biometric Service (required for Fingerprint reader / facial detection)
            "WerSvc"                                       # Windows error reporting
            "wisvc"                                        # Windows Insider program(Windows Insider will not work if Disabled)
            #"WlanSvc"                                     # WLAN AutoConfig
            "WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
            "WpcMonSvc"                                    # Parental Controls
            "WPDBusEnum"                                   # Portable Device Enumerator Service
            "WpnService"                                   # WpnService (Push Notifications may not work)
            #"wscsvc"                                      # Windows Security Center Service
            "WSearch"                                      # Windows Search
            "XblAuthManager"                               # Xbox Live Auth Manager (Disabling Breaks Xbox Live Games)
            "XblGameSave"                                  # Xbox Live Game Save Service (Disabling Breaks Xbox Live Games)
            "XboxNetApiSvc"                                # Xbox Live Networking Service (Disabling Breaks Xbox Live Games)
            "XboxGipSvc"                                   # Xbox Accessory Management Service
             # Hp services
            "HPAppHelperCap"
            "HPDiagsCap"
            "HPNetworkCap"
            "HPSysInfoCap"
            "HpTouchpointAnalyticsService"
             # Hyper-V services
            "HvHost"
            "vmicguestinterface"
            "vmicheartbeat"
            "vmickvpexchange"
            "vmicrdv"
            "vmicshutdown"
            "vmictimesync"
            "vmicvmsession"
             # Services that cannot be disabled
            #"WdNisSvc"
)
		
Write-Host "Setting Manual Services"
        
foreach ($service in $services) {
            # -ErrorAction SilentlyContinue is so it doesn't write an error to stdout if a service doesn't exist
        
            Write-Host "Setting $service StartupType to Manual"
            Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual
}
                
Write-Host "FinishedSetting Manual Services"

Write-Host "Disabling Wi-Fi Sense..."
If (!(Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
            New-Item -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
}
			Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0

			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Type DWord -Value 00000001
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0000000

Write-Host "Adjusting visual effects for performance..."
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 200
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
			Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
			Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0
Write-Host "Adjusted visual effects for performance"

Write-Host "Enabling NumLock after startup..."
If (!(Test-Path "HKU:")) {
			New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}

Write-Host "Showing known file extensions..."
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0

Write-Host "Setting BIOS time to UTC..."
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1

Write-Host "Disabling Activity History..."
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0


Write-Host "Disabling Hibernation..."
			Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0

Write-Host "Allowing Home Groups services..."
			Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
			Set-Service "HomeGroupListener" -StartupType Manual
			Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
			Set-Service "HomeGroupProvider" -StartupType Manual

Write-Host "Disabling Location Tracking..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
			New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
Write-Host "Disabling automatic Maps updates..."
			Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0


Write-Host "Disabling Storage Sense..."
			Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue

Write-Host "Disabling Telemetry..."
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
Write-Host "Disabling Application suggestions..."
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
Write-Host "Disabling Feedback..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
Write-Host "Disabling Tailored Experiences..."
If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
            New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
Write-Host "Disabling Advertising ID..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
Write-Host "Disabling Error reporting..."
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
			Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
Write-Host "Restricting Windows Update P2P only to local network..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
Write-Host "Stopping and disabling Diagnostics Tracking Service..."
			Stop-Service "DiagTrack" -WarningAction SilentlyContinue
			Set-Service "DiagTrack" -StartupType Disabled
Write-Host "Stopping and disabling WAP Push Service..."
			Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
			Set-Service "dmwappushservice" -StartupType Disabled
Write-Host "Enabling F8 boot menu options..."
			bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
Write-Host "Disabling Remote Assistance..."
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
Write-Host "Stopping and disabling Superfetch service..."
			Stop-Service "SysMain" -WarningAction SilentlyContinue
			Set-Service "SysMain" -StartupType Disabled

        # Task Manager Details
If ((get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
            Write-Host "Showing task manager details..."
            $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
            Do {
                  Start-Sleep -Milliseconds 100
                $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
            } Until ($preferences)
            Stop-Process $taskmgr
            $preferences.Preferences[28] = 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
} else {Write-Host "Task Manager patch not run in builds 22557+ due to bug"}

Write-Host "Showing file operations details..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1
Write-Host "Hiding Task View button..."
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
Write-Host "Hiding People icon..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
}
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

Write-Host "Changing default Explorer view to This PC..."
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    
Write-Host "Hiding 3D Objects icon from This PC..."
			Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue  
        
        ## Performance Tweaks and More Telemetry
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 00000000
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0000000a
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0000000a
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
            Set-ItemProperty -Path "HKLM:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 0
            Set-ItemProperty -Path "HKLM:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
            Set-ItemProperty -Path "HKLM:\Control Panel\Desktop" -Name "HungAppTimeout" -Type DWord -Value 4000
            Set-ItemProperty -Path "HKLM:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
            Set-ItemProperty -Path "HKLM:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -Type DWord -Value 00001000
            Set-ItemProperty -Path "HKLM:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -Type DWord -Value 00002000
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 00000001
            Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu" -Name "Start" -Type DWord -Value 00000004
            Set-ItemProperty -Path "HKLM:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 00000010


            # Network Tweaks
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20

            # Group svchost.exe processes
            $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

Write-Host "Disable News and Interests"
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -Type DWord -Value 0
            # Remove "News and Interest" from taskbar
            Set-ItemProperty -Path  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

            # remove "Meet Now" button from taskbar

If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
                New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
}

				Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWord -Value 1

Write-Host "Removing AutoLogger file and restricting directory..."
				$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
            Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
			icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

Write-Host "Stopping and disabling Diagnostics Tracking Service..."
			Stop-Service "DiagTrack"
			Set-Service "DiagTrack" -StartupType Disabled


Write-Host "Disabling driver offering through Windows Update..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value 1
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Force | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -Type DWord -Value 1
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -Type DWord -Value 1
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -Type DWord -Value 0
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1
Write-Host "Disabling Windows Update automatic restart..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
			New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
}
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0
Write-Host "Disabled driver offering through Windows Update"
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "BranchReadinessLevel" -Type DWord -Value 20
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferFeatureUpdatesPeriodInDays" -Type DWord -Value 365
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "DeferQualityUpdatesPeriodInDays " -Type DWord -Value 4

Write-Output 'System Hardened.'
}
#endregion

$encoded = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($system-harden))
powershell.exe -NoProfile -EncodedCommand $encoded

###################################################################################
# Welcome Message / Setup Complete (Double Check after Install)
###################################################################################
#region
#AutoMount Drives At Startup
#Register-ScheduledTask -xml (Get-Content "C:\Users\Public\Documents\AutoMount.xml" | Out-String) -TaskName "AutoMount" -TaskPath "C:\Windows\System32\Tasks" -Force

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('                          Containerized Windows Setup.
    ***Sandbox User Folders: %PROGRAMDATA%\Microsoft\Windows\Containers\<GUID>
	\BaseLayer\Files\Users\WDAGUtilityAccount\Documents***

YOUR DEFAULT VIRTUAL DRIVES ARE:

G:\ APPS (Portable Applications Go Here)
H:\ DOWNLOADS (Change your default downloads user folder to "H:\Downloads")
Y:\ EMAIL (Email Program Here - Seperate from Main OS.)

Shortcuts @ "C:\Users\Public\Documents\"

')}"
Explorer.exe "C:\Users\Public\Documents\"
#Resume-BitLocker -MountPoint "C:"
Restart-Computer
#endregion

###################################################################################
title Remember, Notes for Creator...
###################################################################################

Write-Host "Things I might use later...

To the general user, they have a potential secure VM.
Containerizing allows minimizing exopsed data.
VM destroyed after use.
What is minimum traffic? (Windows Firewall)
Increased security for the general user. Potentialy.

#New-event 

#Backup-GPO \ #Restore-GPO  (How to make universal without hassel?)

#Does this do the same thing as a popup?

#$sess = new-pssession (get-content machines.txt)
#$commands = 'get-eventlog -log system | where {$_.EntryType -eq "error" -and $_.Source -eq "LSASRV"} | out-file errors.txt'

#invoke-command -session $sess -scriptblock {param($commands)start-job -scriptblock {$commands}} -ArgumentList $commands
#invoke-command -session $sess -scriptblock {wait-job -any}
#get-job | wait-job

#      Set-AuthenticodeSignature [-filePath] string[]
#           [-certificate] X509Certificate2  [-includeChain string]
#              [-timeStampServer string] [-HashAlgorithm string]
#                 [-force] [-whatIf] [-confirm] [CommonParameters]"
pause
exit