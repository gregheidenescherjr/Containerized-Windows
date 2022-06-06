select vdisk file=".:\VirtualDrives.vhdx"
attach vdisk
create partition efi size=120000000
format fs=NTFS label="ContainerApps" quick
assign letter=G
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