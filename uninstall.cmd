@echo off
setlocal

echo Claude Code Patcher Uninstaller
echo ================================
echo.

:: remove marker file (will cause fresh patch detection next time)
set "markerFile=%APPDATA%\npm\node_modules\@anthropic-ai\claude-code\.patched"
if exist "%markerFile%" (
    del "%markerFile%"
    echo [OK] Marker file removed
)

echo.
echo Uninstall complete.
echo Note: The patched cli.js remains until Claude Code updates.
echo       Delete %~dp0 to fully remove the patcher.
echo.

endlocal
