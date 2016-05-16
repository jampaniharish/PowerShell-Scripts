<#
.Synopsis
   List all programs installed on a device
.DESCRIPTION
   List all programs installed on a device. You can run localhost or remote devices.
.EXAMPLE
   This example gets all the software on a remote device using a wildcard query of "virt"
   
   Get-Progams DC123456 Virt
.EXAMPLE
   This example gets all the software on a local device using a wildcard query
   
   Get-Programs localhost ""
#>
function Get-Programs {
    [cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [ValidateLength(1,20)]
    [String[]]$ComputerName, 
    [string]$search
    ) 
    
    cls
If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
        
    Write-Progress -Activity "Connecting to WMI of $ComputerName..." 

    Get-WmiObject -Class win32_Product -ComputerName $ComputerName | ? {$_.Name -match $search} -ErrorAction SilentlyContinue |
    
    Select @{n='Machine';e={$_.PSComputerName}},Name,Version,InstallDate,@{n='GUID';e={$_.IdentifyingNumber}} | FT -AutoSize -wrap
    }

Catch [System.exception] {
    "failed"
    }
}
Else {
    write-output "$computer is unreachable."
    }

}


<#
.Synopsis
   List all members in an Active Directory group
.DESCRIPTION
   List all members in an Active Directory group
.EXAMPLE
   This example retrieves all the members in the administrators group
   
   Get-ADMembers Administrators
#>
function Get-ADMembers {
    [cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$ADGroupName
    ) 

(Get-ADUser -Filter "memberOf -RecursiveMatch '$((Get-ADGroup "$ADGroupName").DistinguishedName)'").Name 
}


<#
.Synopsis
   List a collection from an SCCM 2007 site server
.DESCRIPTION
   List a collection from an SCCM 2007 site server using WMI query on SMS_Collection
.EXAMPLE
   This example retrieves the collection based on a keyword query called "Adobe"
   
   Get-SCCMCollection -SiteServer SERVER1 -SiteCode S01 -Search Adobe
#>
function Get-SCCMCollection {
    [cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$SiteServer,
    [parameter(Mandatory=$true)]
    [String[]]$SiteCode,
    [String[]]$Search
    ) 

﻿cls

$coll = Get-WmiObject -Computername $SiteServer -Namespace root\sms\site_$SiteCode -Class SMS_Collection | Select Name, CollectionID 
$coll | Where-Object {$_.Name -like "$search"} |  Select Name 
}


<#
.Synopsis
   Triggers the machine policy update from an SCCM 2007 client
.DESCRIPTION
   Triggers the machine policy update from an SCCM 2007 client
.EXAMPLE
   This example fires the machine policy for the device COMPUTER1
   
   TriggerMachinePolicy COMPUTER1
#>
function TriggerMachinePolicy {

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [ValidateLength(1,20)]
    [String[]]$ComputerName
    )
If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
    $trigger = "{00000000-0000-0000-0000-000000000021}"
    Invoke-WmiMethod -ComputerName $ComputerName -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger

}
Catch [System.exception] {
    "failed"
    }
}
Else {
    write-output "$ComputerName is unreachable."
    }

}
