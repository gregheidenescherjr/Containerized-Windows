@echo off

echo Checking for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

echo Permission check result: %errorlevel%

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

echo Running created temporary "%temp%\getadmin.vbs"
timeout /T 2
"%temp%\getadmin.vbs"
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0" 

echo Batch was successfully started with admin privileges
echo .
cls
GOTO:menu
:menu
Title Windows Sandbox Installer
echo --------------------------------------------------
echo Windows Sandbox?
echo 1 Install
echo 2 Uninstall
echo 3 Skip to Hyper-V
set /p uni= Select Option:
if %uni% ==1 goto :in
if %uni% ==2 goto :un
if %uni% ==3 goto :remenu

:in
cls
Title Install Sandbox

pushd "%~dp0"

dir /b %SystemRoot%\servicing\Packages\*Containers*.mum >sandbox.txt

for /f %%i in ('findstr /i . sandbox.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"

del sandbox.txt

Dism /online /enable-feature /featurename:Containers-DisposableClientVM /LimitAccess /ALL /NoRestart

goto :remenu

:un
cls
Title Uninstall Sandbox

pushd "%~dp0"

Dism /online /disable-feature /featurename:Containers-DisposableClientVM /NoRestart

dir /b %SystemRoot%\servicing\Packages\*Containers*.mum >sandbox.txt

for /f %%i in ('findstr /i . sandbox.txt 2^>nul') do dism /online /norestart /remove-package:"%SystemRoot%\servicing\Packages\%%i"

del sandbox.txt

goto :remenu

:remenu
cls
Title Hyper-V Installer
echo --------------------------------------------------
echo Hyper-V?
echo 1 Yes
echo 2 No
set /p uni=Select Option:
if %uni% ==1 goto :hv
if %uni% ==2 goto :ex

:hv
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
exit

:ex
exit


