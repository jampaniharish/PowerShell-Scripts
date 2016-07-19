$TargetFile = "$env:LOCALAPPDATA\Microsoft\AppV\Client\Integration\AD966525-0809-4665-9F67-D1A2280AFABC\Root\VFS\ProgramFilesX86\Google\Chrome\Application\chrome.exe"
$ShortcutFile = "$env:Public\Desktop\Mental Health Landing Page.lnk"
$Arguments = '--no-default-browser-check --allow-outdated-plugins --disable-direct-write http://nhsggcbiprodweb/MicroStrategy/asp/Main.aspx?evt=2048001&src=Main.aspx.2048001&visMode=0&currentViewMedia=1&documentName=Mental%20Health%20Landing%20Page&server=NHSGGCBIPROD&Project=Clinical%20Mental%20Health&port=0&share=1'
$Icon = "$env:LOCALAPPDATA\Microsoft\AppV\Client\Integration\AD966525-0809-4665-9F67-D1A2280AFABC\Root\VFS\ProgramFilesX86\Google\Chrome\Application\chrome.exe.0.ico"

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Arguments = $Arguments
$Shortcut.IconLocation = $Icon
$Shortcut.Save()