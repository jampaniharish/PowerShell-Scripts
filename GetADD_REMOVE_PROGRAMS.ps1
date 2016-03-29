#% {Get-WmiObject -Class win32Reg_AddRemovePrograms -ComputerName (gc C:\MEDV_Machines.txt)  -filter "DisplayName like '%MED-V%'" -ErrorAction SilentlyContinue | Select @{n='Machine';e={$_.PSComputerName}}, DisplayName, Version, ProdID} | out-file c:\MEDV_Results.txt -Append #| % {$_.Uninstall()} -WhatIf
cls
$computer = "lc124239"
$search = "virt"
if
(
   Test-Connection -Count 1 -ComputerName $computer -Quiet
    )
{
Try
{
    Get-WmiObject -Class win32Reg_AddRemovePrograms -ComputerName $computer -filter "DisplayName like '%$search%'" -ErrorAction SilentlyContinue | Select @{n='Machine';e={$_.PSComputerName}}, DisplayName, Version, ProdID, InstallDate | ft -Wrap -AutoSize
    
    }
Catch [System.exception]
{
    "failed"
    }
}
Else
{
    write-host "$computer is unreachable."
    }

