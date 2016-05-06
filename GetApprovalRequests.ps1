
$CMSiteServerFQDN = "" # type FQDN to your site server

Enter-PSSession -ComputerName $CMSiteServerFQDN -ConfigurationName Microsoft.PowerShell32

Import-Module "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"

$SMSDRV = Get-PSDrive -PSProvider CMSite

CD "$($SMSDRV):"

Get-CMApprovalRequest | ? {$_.CurrentState -eq 1} | select Application, LastModifiedBy, Comment

Exit-PSSession