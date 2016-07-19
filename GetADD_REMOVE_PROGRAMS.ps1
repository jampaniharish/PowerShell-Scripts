#script by M.Balzan 01/02/2015
# to import multiple machines use the below line
#% {Get-WmiObject win32_Product -ComputerName (gc C:\MEDV_Machines.txt) | ? {$_.Name -match "$search"} -ErrorAction SilentlyContinue  | Select @{n='Machine';e={$_.PSComputerName}}, Name, Version, IdentifyingNumber, InstallDate | ft -Wrap -AutoSize} | out-file c:\MEDV_Results.txt -Append #| % {$_.Uninstall()} -WhatIf
cls
$computer = "DC150724"
$search = ""
if
(
   Test-Connection -Count 1 -ComputerName $computer -Quiet
    )
{
Try
{
    Get-WmiObject win32_Product -ComputerName $computer  | ? {$_.Name -match "$search"} -ErrorAction SilentlyContinue  | Select @{n='Machine';e={$_.PSComputerName}}, Name, Version, IdentifyingNumber, InstallDate | ft -Wrap -AutoSize
    
    #for reports, rem out above line and rem off the below line
    #Get-WmiObject win32_Product -ComputerName $computer | ? {$_.Name -match "$search"} -ErrorAction SilentlyContinue  | Select @{n='Machine';e={$_.PSComputerName}}, Name, Version, IdentifyingNumber, InstallDate | export-csv c:\arp.csv
    
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