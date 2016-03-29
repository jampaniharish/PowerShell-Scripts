$startTime = (Get-Date).AddDays(-2)
# Get the used event-logs of the target machine
$EventLogs = Get-WinEvent -FilterHashTable @{LogName = "Microsoft-AppV-Client/Operational" ; ID=19001,19002; StartTime=$StartTime} -ErrorAction SilentlyContinue -MaxEvents 2
$EventLogs