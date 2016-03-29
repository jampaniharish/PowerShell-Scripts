# script by Matt Balzan 27-01-16
cls
import-module ActiveDirectory

$server = "xggc-adds-01P.xggc.scot.nhs.uk"
$path = "OU=SCCM Application Deployment Groups,OU=Standard Groups,OU=Groups,DC=xggc,DC=scot,DC=nhs,DC=uk"

# edit the 3 fields below only
$name = "DEP0003_Microsoft_Visual_C++_2013"
$desc = ""
$machines = "DC106775-B7-01$"

# check to see if group exists, if not create it...

Try
{
    New-ADGroup -Server $server -name $name -GroupCategory Security -GroupScope DomainLocal -Path $path -Description $desc -DisplayName $name -ErrorAction stop
    Write-Host "AD Group: $name added!" -ForegroundColor Green
   }
Catch [System.exception]
{ 
    write-host "AD Group: $name already exists!" -ForegroundColor Red
    }

# check to see if device exists in group, if not add it...
Try{
    Add-ADGroupMember $name -Members $machines -Server $server
    Write-Host "Device: $machines added to group: $name" -ForegroundColor Green
    }
Catch [System.exception]
{ 
    write-host "AD Group member: $machines already exists!" -ForegroundColor Red
    }

<# Create SCCM New Device Collection - work in progress...

Import-Module ((Split-Path $env:SMS_ADMIN_UI_PATH)+"\ConfigurationManager.psd1")

CD XG1:

$NewCollection = New-CMDeviceCollection -Name "APPS9999_TEST" -LimitingCollectionName "All Systems" -RefreshType Continuous

Move-CMObject -FolderPath 'XG1:\DeviceCollection\Application Deployment' -InputObject $NewCollection

Add-CMDeviceCollectionQueryMembershipRule -CollectionName $NewCollection -QueryExpression "select *  from  SMS_R_System where SMS_R_System.SystemGroupName = 'XGGC\\$NewCollection'" -RuleName "Query_$NewCollection"

#>