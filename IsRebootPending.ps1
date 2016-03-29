#Invoke-WmiMethod -Namespace root\ccm\clientsdk -Class CCM_ClientUtilities -Name DetermineIfRebootPending -ComputerName 

Get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" | Format-List -Property *