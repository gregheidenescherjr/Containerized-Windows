@echo off
net user Root Root /add /expires:never
net localgroup administrators mylocaladmin /add
net user LiveUser LiveUser /add /expires:never
net localgroup Users LiveUser /add