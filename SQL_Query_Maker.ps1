# SQL Query Creator for SCCM 
# Code by TekMonster

$sql1 = 'select SMS_R_System.Name from  SMS_R_System where SMS_R_System.Name not like "%-%" and ('
$sql2 = 'SMS_R_System.Name like "%'
$sql2end = '%"'
$sql3 = ' or '
$sql4 = ')'

Clear-Content -Path c:\ISO\SQL_QUERY.txt -Force
Add-Content -Value $sql1 -Path c:\ISO\SQL_QUERY.txt -Force -NoNewline

$GPCodes = gc c:\ISO\gpcodes.txt
foreach ($GPCode in $GPCodes) {Add-Content -value $sql2$GPCode$sql2end$sql3 -path c:\ISO\SQL_Query.txt -Force -NoNewline}
$l1 = Get-Content -path c:\ISO\SQL_Query.txt
$l2 = $l1.Length
$l1.Remove($l2-4) | Set-Content -path c:\ISO\SQL_Query.txt -Force -NoNewline
Add-Content -Value $sql4 -path c:\ISO\SQL_Query.txt -Force -NoNewline 
write-output "SQL Query complete!"