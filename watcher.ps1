$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "$env:APPDATA\npm\node_modules\@anthropic-ai\claude-code"
$watcher.Filter = "cli.js"
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
$watcher.EnableRaisingEvents = $true
$action = { node "C:\Users\Helz\claude-patcher\patcher.js" }
Register-ObjectEvent $watcher "Changed" -Action $action
while ($true) { Start-Sleep -Seconds 60 }
