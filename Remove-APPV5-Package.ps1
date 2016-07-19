cls
Stop-AppvClientPackage -name * | Unpublish-AppvClientPackage | Remove-AppvClientPackage
$startTime = (Get-Date).AddMinutes(-1)
$EventLogs = Get-WinEvent -FilterHashTable @{LogName = “Microsoft-AppV-Client/Operational” ; ID=4004,1007; StartTime=$StartTime} -ErrorAction SilentlyContinue -MaxEvents 20
$EventLogs | Format-Table -Wrap -AutoSize