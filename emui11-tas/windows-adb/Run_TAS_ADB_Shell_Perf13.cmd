@echo off
setlocal
chcp 65001 >nul
echo ==========================================================
echo TAS-AN00 OPTIONAL 13-case perf diagnostics via ADB shell
echo Uploads one pinned read-only probe to /data/local/tmp
echo Removes the probe after execution; does not request root
echo ==========================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0TAS_ADB_Shell_Perf_13Case.ps1" %*
set "RUN_EXIT=%ERRORLEVEL%"
echo.
if not "%RUN_EXIT%"=="0" (
    echo The optional test failed. Check ADB authorization or ZIP files.
) else (
    echo Test finished. Find TAS_ADB_Shell_Perf13 ZIP under TAS_ADB_Results.
)
echo.
pause
exit /b %RUN_EXIT%
