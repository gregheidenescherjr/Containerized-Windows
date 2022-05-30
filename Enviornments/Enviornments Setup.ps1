#Enviornments
#This script will only pull the enviornments after installation.

#Enviornment Sandboxes

# URL and Destination
$url = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/Secure%Internet.wsb"
$url2 = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/UnSecure%Internet.wsb" 
$url3 = "https://github.com/gregheidenescherjr/Containerized-Windows/tree/master/Enviornments/Testing%Zone.wsb"
$dest = "G:\"
# Download file
Start-BitsTransfer -Source $url $url2 $url3 -Destination $dest | Complete-BitsTransfer 
Write-Host "Saved" -ForegroundColor Green
Write-Host "Enviornments Saved to G:\" -ForegroundColor Green
