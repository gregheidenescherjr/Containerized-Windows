#Enviornments Setup
#This script will only pull the enviornments after installation.

#Chris Titus Tech Toolbox
Write-Host "Chris Titus Tech Toolbox"
Write-Host "This allows the user to define additional setting within Windows 11 relevant to the user."
iwr -useb https://christitus.com/win | iex

pause

Copy-Item "G:\Secure%Internet.wsb" -Destination "C:\Users\Public\Desktop"
Copy-Item "G:\UnSecure%Internet.wsb" -Destination "C:\Users\Public\Desktop"

Remove-Item "G:\Secure%Internet.wsb
Remove-Item "G:\UnSecure%Internet.wsb

Write-Host "YourTesting playground is located at G:\"
Write-Host "This is the first setup in the vision."
Write Host "The Secure and UnSecure enviornments are only labled as such so that you can tell the difference between what has stored information.
Write-Host "I would strongly reccomend relocating your user folders such as documents, photos, etc. to G:\"
Write-Host "This does not hide your IP. THIS DOES NOT HIDE YOUR ONLINE ACTIVITY."
Write-Host "We can limit what information companies and others can see, but lets continue to improve this vision."