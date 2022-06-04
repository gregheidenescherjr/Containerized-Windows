select vdisk file=".:\VirtualDrives.vhdx"
pause
attach vdisk
pause
create partition efi size=120000000
pause
format fs=NTFS label="ContainerApps" quick
pause
assign letter=G
pause
automount enable
exit


pause
create partition efi size=120000000
pause
format fs=NTFS label="Downloads" quick
pause
assign letter=H
pause
automount enable
exit