#Root Setup
#This Account Is Your Management Account to Troubleshoot OS Issues

New-LocalUser -Name "Root" -Description "Management Account." -root
Copy-Item "C:\Wabash\Logfiles\mar1604.log.txt" -Destination "C:\Presentation"

New-LocalUser -Name "User" -Description "User Account." -user
Copy-Item "C:\Wabash\Logfiles\mar1604.log.txt" -Destination "C:\Presentation"