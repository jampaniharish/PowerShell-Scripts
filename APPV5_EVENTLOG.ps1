cls
$startTime = (Get-Date).AddHours(-1)
$EventLogs = Get-WinEvent -ComputerName dc107302-b7-01 -FilterHashTable @{LogName = “Microsoft-AppV-Client/Admin” ; ID=4004,4009 ; StartTime=$StartTime} -ErrorAction SilentlyContinue -MaxEvents 20
$EventLogs | Format-Table -Wrap -AutoSize