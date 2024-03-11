@echo off
setlocal
echo Hard Remover - The program that deletes your stubborn files and folders.
echo.

:: Check if the PC is in safe mode
reg query "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Option" >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo You are in safe mode.
    goto RemoveProcess
) else (
    echo Configuring to start in safe mode on the next reboot...
    bcdedit /set {current} safeboot minimal
    echo Please restart your computer now and run this script again in safe mode.
    goto End
    pause
)

:getTarget
echo Enter the full path of the file or folder to be deleted:
set /p targetPath=
if "%targetPath%"=="" goto getTarget

:confirmDelete
echo You are about to delete: "%targetPath%"
echo Are you sure? (Y/N)
set /p confirm=
if /I "%confirm%" neq "Y" goto end

:deleteProcess
echo Attempting to delete...
takeown /f "%targetPath%" /r > NUL
icacls "%targetPath%" /grant %username%:F /t /q
del /f /q "%targetPath%" > NUL 2>&1
if exist "%targetPath%" (
    echo Unable to delete the specified file/folder. It may be in use by another program.
) else (
    echo Deletion successful.
)
bcdedit /deletevalue {current} safeboot
echo Safe mode has been removed and will not be present on the next restart.
pause

:end
echo Operation completed.
pause
