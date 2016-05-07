# Matt Balzan 05-05-2016
﻿$RunProgram ={
cls
$packs = (Get-ChildItem C:\Windows\diagnostics\system).Name

$list=0
foreach ($pack in $packs)

{
$list+=1
write-host "[$list]"- "$pack"
}

Write-Host ""
$choice = Read-host "Choose a Troubleshooting Pack: 1-$list"
$sel = $packs[$choice-1]
write-host "You have selected: $sel"


Get-TroubleshootingPack -path C:\windows\diagnostics\system\$sel | Invoke-TroubleshootingPack
}

&$RunProgram

$again = Read-Host "Back to menu?"
    
switch ($again)
 {
     "y" {&$RunProgram}
     "n" {}
    
 }
