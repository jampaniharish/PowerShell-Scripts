# install msi software using Invoke-WMIMethod
# M. Balzan
cls
$servers = Get-Content "C:\ISO\AllServers.TXT"

ForEach ($server in $servers) {
    Write-Output "Processing $server..." | out-file c:\iso\SnowInstalls.log

    $OS = (Get-WmiObject Win32_Processor -computername $server).AddressWidth | Out-File C:\ISO\Server_OS.txt

If ($OS -eq "32"){
    Write-Output "OS Architecture is $OS" | out-file c:\iso\SnowInstalls.log -Append
    $file = "\\xggc\ggcdata\sccmsource\Package\app-d0385\GlasgowNHS_3704_x86.msi"
    $filename = "GlasgowNHS_3704_x86.msi"
    }
Else {
    Write-Output "OS Architecture is $OS" | out-file c:\iso\SnowInstalls.log -Append
    $file = "\\xggc\ggcdata\sccmsource\Package\app-d0385\GlasgowNHS_3704_x64.msi"
    $filename = "GlasgowNHS_3704_x64.msi"
    }
        
    Copy-Item $file -Destination \\$server\C$ -Force | out-file c:\iso\SnowInstalls.log -Append
    $installpath = "\\$server\c$\$filename"  
    Invoke-WMIMethod -path Win32_Product -Name Install -ComputerName $server -ArgumentList @($true,$null,$installpath) | Select ReturnValue | out-file c:\iso\SnowInstalls.log -Append
}