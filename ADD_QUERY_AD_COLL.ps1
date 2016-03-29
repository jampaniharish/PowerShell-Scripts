$CMSiteCode = "XG1" #Your site code
$CMSiteServerFQDN = "XGGC-SCCM-PR-01" #FQDN to your site server
New-Item -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name DomainName -Value "" -PropertyType String -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name ServerName -Value $CMSiteServerFQDN -PropertyType String -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name SiteCode -Value $CMSiteCode -PropertyType String -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name SiteName -Value "Primary Site $($CMSiteCode)" -PropertyType String -Force

Import-Module ‘c:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1’

CD XG1:

$name = "APPS0001"

New-CMDeviceCollection -Name $name -LimitingCollectionName "All Systems" -RefreshType Both

Add-CMDeviceCollectionQueryMembershipRule -CollectionName $name -QueryExpression "select *  from  SMS_R_System where SMS_R_System.SystemGroupName = 'XGGC\\$name'" -RuleName "Query_$name"

$coll = Get-CMDeviceCollection -Name $name

Move-CMObject -FolderPath "XG1:\DeviceCollection\Application Deployment" -InputObject $coll
