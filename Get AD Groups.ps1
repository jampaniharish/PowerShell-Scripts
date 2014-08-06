# edit search term between asterisks below - MB 2014

$a = Get-ADGroup -Filter {name -like "*efin*"}
$a -replace ",.*" -replace ".*=" | out-file C:\AD_Groups.txt