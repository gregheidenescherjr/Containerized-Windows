#Enviornments Setup
#This script will only pull the enviornments after installation.

#Chris Titus Tech Toolbox
Write-Host "Chris Titus Tech Toolbox"
Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
iwr -useb https://christitus.com/win | iex

pause

Copy-Item "G:\Secure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item "G:\UnSecure%Internet.wsb" -Destination "C:\Users\Public\Desktop"


