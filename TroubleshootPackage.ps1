cls
$array1 = Get-ChildItem C:\Windows\diagnostics\system | Select Name

$list = 0
foreach ($arr in $array1)
{
  $list += 1
  $arr2 = $arr -replace "@{Name=",''
  $arr3 = $arr2 -replace "}",""
  write-host "[",$list,"]" , $arr3
  }
write-host ""
$choice1 = Read-Host "Choose a troubleshoot package 1-$list"
$sel = $list[$choice1-1]

Write-Host "Launching ", $choice1-$sel, "..."

Get-TroubleshootingPack -path C:\windows\diagnostics\system\$choice1 | Invoke-TroubleshootingPack
