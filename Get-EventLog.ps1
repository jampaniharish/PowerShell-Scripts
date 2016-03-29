Test-Connection -ComputerName DC118504 -Count 1
get-eventlog -logname Application -message "*Appv*" -computername dc118504 -after 08/11/15 -before 08/11/15 | select EventID,Message | ft -Wrap -AutoSize #| out-file C:\GPOReports\CalibriError.html -Force

