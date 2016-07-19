New-Item -ItemType Directory -path "C:\Windows\NHS_Desktop_Icons" -Force
Copy-Item "\\xggc-vrtl-03\SCCMContent\Compliance\DesktopShortcuts\ISD.ico" -Destination "C:\Windows\NHS_Desktop_Icons" -Force
$TargetFile = "http://www.staffnet.ggc.scot.nhs.uk/Corporate%20Services/Health%20Information%20Technology/ITSD/Pages/ITServiceDesk.aspx"
$ShortcutFile = "$env:Public\Desktop\IT Service Desk.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.IconLocation = "C:\Windows\NHS_Desktop_Icons\ISD.ico"
$Shortcut.Save()