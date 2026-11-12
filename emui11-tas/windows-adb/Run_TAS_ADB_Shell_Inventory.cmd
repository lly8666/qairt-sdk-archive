@echo off
setlocal
chcp 65001 >nul
echo =====================================================
echo TAS-AN00 Windows ADB shell read-only survey
echo Need: Windows + adb.exe + authorized USB debugging
echo No root, no kernel exploit, no flash, no service start
echo =====================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0TAS_ADB_Shell_Inventory.ps1" %*
set "RUN_EXIT=%ERRORLEVEL%"
echo.
if not "%RUN_EXIT%"=="0" (
    echo Survey failed. Run "adb devices" and confirm USB authorization.
) else (
    echo Survey finished. Find the ZIP under TAS_ADB_Results.
)
echo.
pause
exit /b %RUN_EXIT%
