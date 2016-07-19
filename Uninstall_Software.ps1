$app = Get-WmiObject -Query “SELECT * FROM SMS_InstalledSoftware” -Namespace “root\cimv2\sms” | Where-Object { $_.ProductName -match “Google”}
cmd /c $app.UninstallString --force-uninstall