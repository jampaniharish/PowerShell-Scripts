cls
$startTime = (Get-Date).AddHours(-1)
$EventLogs = Get-WinEvent -FilterHashTable @{LogName = “Microsoft-AppV-Client/Admin” ; ID=4001,4009 ; StartTime=$StartTime; Message=$Message} -ErrorAction SilentlyContinue -MaxEvents 20 | Format-Table -Wrap -AutoSize
$EventLogs 