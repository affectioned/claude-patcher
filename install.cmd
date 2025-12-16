@echo off
setlocal

echo Claude Code Patcher Installer
echo ==============================
echo.

:: check if running as admin for PATH modification
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Note: Run as Administrator to add to system PATH automatically.
    echo Otherwise, manually add %~dp0 to your PATH.
    echo.
)

:: apply patch immediately
echo Applying patches...
node "%~dp0patcher.js"
echo.

:: create scheduled task to patch on login (survives updates)
echo Creating scheduled task for auto-patching...
schtasks /create /tn "ClaudeCodePatcher" /tr "node \"%~dp0patcher.js\"" /sc onlogon /rl highest /f >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Scheduled task created - will auto-patch on login
) else (
    echo [WARN] Could not create scheduled task - run as admin or create manually
)

:: create file watcher alternative using powershell
echo.
echo Creating file watcher script...
(
echo $watcher = New-Object System.IO.FileSystemWatcher
echo $watcher.Path = "$env:APPDATA\npm\node_modules\@anthropic-ai\claude-code"
echo $watcher.Filter = "cli.js"
echo $watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
echo $watcher.EnableRaisingEvents = $true
echo $action = { node "%~dp0patcher.js" }
echo Register-ObjectEvent $watcher "Changed" -Action $action
echo while ($true^) { Start-Sleep -Seconds 60 }
) > "%~dp0watcher.ps1"
echo [OK] File watcher script created at %~dp0watcher.ps1
echo.

echo ==============================
echo Installation complete!
echo.
echo Usage options:
echo   1. Use wrapper:  %~dp0claude.cmd [args]
echo   2. Add %~dp0 to PATH (before npm path) to override 'claude' command
echo   3. Run watcher:  powershell -ExecutionPolicy Bypass -File "%~dp0watcher.ps1"
echo.
echo Run 'node %~dp0patcher.js --status' to check patch status anytime.
echo.

endlocal
