diskpart
pause
select vdisk file=".:\VirtualDrives.vhdx"
pause
attach vdisk
create partition primary size=120000000
format fs=NTFS label="Virtual Drives" quick
assign letter=M
pause
create partition primary size=120000000
format fs=NTFS label="Virtual Drives" quick
assign letter=N
pause
automount enable
exit