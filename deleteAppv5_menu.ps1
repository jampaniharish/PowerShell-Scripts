cls

$array1 = Get-AppvClientPackage -All | Select -ExpandProperty Name

$list = 0
foreach ($arr in $array1)
{
  $list += 1
  write-host "[",$list,"]" , $arr
}
write-host ""
$choice1 = Read-Host "Choose a package to delete 1-$list"
$sel = $array1[$choice1-1]

Write-Host "Deleting ", $sel, "..."

Stop-AppvClientPackage -name $sel | Unpublish-AppvClientPackage | Remove-AppvClientPackage

Write-Host $sel, "has been deleted."
