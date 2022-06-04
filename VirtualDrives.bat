diskpart
pause
select vdisk file=".:\VirtualDrives.vhdx"
pause
attach vdisk
create partition efi size=120000000
format fs=NTFS label="ContainerApps" quick
assign letter=G
automount enable
pause
create partition efi size=120000000
format fs=NTFS label="Downloads" quick
assign letter=H
automount enable
exit