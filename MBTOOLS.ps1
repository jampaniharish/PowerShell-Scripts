#require -runasadministrator

function Get-Programs {
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
        
    Write-Progress -Activity "Searching $ComputerName using wild card search term: '$search'" 
 
    Get-WmiObject -Class win32_Product -ComputerName $ComputerName | ? {$_.Name -match $search} -ErrorAction SilentlyContinue |
    
    Select @{n='Machine';e={$_.PSComputerName}},Name,Version,InstallDate,@{n='GUID';e={$_.IdentifyingNumber}} | FT -AutoSize -wrap
    }

Catch [System.exception] {
    write-output “Caught an exception:"
    write-output “Exception Type: $($_.Exception.GetType().FullName)”
    write-output “Exception Message: $($_.Exception.Message)”
    }
}
Else {
    write-output "$ComputerName is unreachable."
    }

}


function Get-ADMembers {
<#
.Synopsis
   List all members in an Active Directory group
.DESCRIPTION
   List all members in an Active Directory group
.EXAMPLE
   This example retrieves all the members in the administrators group
   
   Get-ADMembers Administrators
#>

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$ADGroupName
    ) 

Clear-Host
write-progress -Activity "Searching AD members for: '$ADGroupName'"
(Get-ADUser -Filter "memberOf -RecursiveMatch '$((Get-ADGroup "$ADGroupName").DistinguishedName)'").Name 
}

function Add-ADMembers {
<#
.Synopsis
   List all members in an Active Directory group
.DESCRIPTION
   List all members in an Active Directory group
.EXAMPLE
   This example retrieves all the members in the administrators group
   
   Get-ADMembers Administrators
#>

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$ADGroupName
    ) 

Clear-Host
write-progress -Activity "Searching AD members for: '$ADGroupName'"
(Get-ADUser -Filter "memberOf -RecursiveMatch '$((Get-ADGroup "$ADGroupName").DistinguishedName)'").Name 
}


function Get-ADGROUPS {
<#
.Synopsis
   List all AD Groups in an Active Directory group
.DESCRIPTION
   List all AD Groups in an Active Directory group
.EXAMPLE
   This example retrieves all the AD Groups based on a wild card search "PACS"
   
   Get-ADGROUPS PACS
#>

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$ADGRPS
    ) 

    Clear-Host
    write-progress -Activity "Searching for AD Groups with wild card: '$ADGRPS'"
    Get-ADGroup | ? {$_.name -like "*$ADGRPS*"} -Properties Description | Select Name
    
}


function Get-AllUserGroups {
<#
.Synopsis
   List all Active Directory groups a user is a member of
.DESCRIPTION
   List all Active Directory groups a user is a member of
.EXAMPLE
   This example retrieves all the groups the user USER1 is a member of
   
   Get-AllUserGroups -ADUser USER1
.EXAMPLE
   This example retrieves a wild card search of the groups the user USER1 is a member of
   
   Get-AllUserGroups - ADUser USER1 -ADGroup APPV5
.EXAMPLE
    This example counts the amount of groups a user is a member of and exports the results to a text file.

    (Get-AllUserGroups svc-view appv0).count | Out-File c:\svc-view.txt
    Get-AllUserGroups svc-view appv0 | Out-File c:\svc-view.txt -Append
    
#>

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$ADUser,
    [String]$ADGroup
    ) 

Get-ADPrincipalGroupMembership -Identity $aduser | ? {$_.name -like "*$ADGroup*"} | select name

}


function Get-SCCMCollection {
<#
.Synopsis
   List a collection from an SCCM 2007 site server
.DESCRIPTION
   List a collection from an SCCM 2007 site server using WMI query on SMS_Collection
.EXAMPLE
   This example retrieves the collection based on a keyword query called "Adobe"
   
   Get-SCCMCollection -SiteServer SERVER1 -SiteCode S01 -Search Adobe
#>

[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$SiteServer,
    [parameter(Mandatory=$true)]
    [String[]]$SiteCode,
    [String[]]$Search
    ) 

Clear-Host
write-progress -Activity "Searching $SiteServer for: '$search'"
$coll = Get-WmiObject -Computername $SiteServer -Namespace root\sms\site_$SiteCode -Class SMS_Collection | Select Name
$coll | Where-Object {$_.Name -like "*$search*"} |  Select Name | FT -HideTableHeaders
}


function TriggerMachinePolicy {
<#
.Synopsis
   Triggers the machine policy update from an SCCM 2007 client
.DESCRIPTION
   Triggers the machine policy update from an SCCM 2007 client
.EXAMPLE
   This example fires the machine policy for the device COMPUTER1
   
   TriggerMachinePolicy COMPUTER1
#>
[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [ValidateLength(1,20)]
    [String[]]$ComputerName
    )
If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
    Write-Progress -Activity "Running a machine policy update on $ComputerName"
    $trigger = "{00000000-0000-0000-0000-000000000021}"
    Invoke-WmiMethod -ComputerName $ComputerName -Namespace root\ccm -Class sms_client -Name TriggerSchedule $trigger - | Select ReturnValue
}
Catch [System.exception] {
    "failed"
    }
}
Else {
    write-output "$ComputerName is unreachable."
    }

}


function Run-TroubleshootingPack {
<#
.Synopsis
   Starts the troubleshooting packs on the local device
.DESCRIPTION
   Starts the troubleshooting packs on the local device, eg. Audio troubleshooting pack.
   The entire packs are in the parameters for -pack:
   
    AERO
    Apps
    Audio
    BITS
    Device
    DeviceCenter
    HomeGroup
    IEBrowseWeb
    IESecurity
    Networking
    PCW
    Performance
    Power
    Printer
    Search
    UsbCore
    Video
    WindowsMediaPlayerConfiguration
    WindowsMediaPlayerMediaLibrary
    WindowsMediaPlayerPlayDVD
    WindowsUpdate

.EXAMPLE
   This example launches the Networking troubleshooting pack
   
   Run-TroubleshootingPack -packs Networking

.EXAMPLE
   This example launches the AERO troubleshooting pack with a specified answer file
   
   Run-TroubleshootingPack -packs AERO -AnswerFile "AudioAnswerFile.xml" -Unattended

.EXAMPLE
    This example runs the Audio pack in interactive mode and saves the results to a folder.
    
    Run-TroubleshootingPack -Pack Audio -Result "C:\DiagResult"
#>

[CmdletBinding()]

    Param(
    [Parameter( Position = 0, Mandatory = $true)]
    [ValidateSet('AERO','Apps','Audio','BITS','Device','DeviceCenter','HomeGroup','IEBrowseWeb','IESecurity','Networking','PCW','Performance','Power','Printer','Search','UsbCore','Video','WindowsMediaPlayerConfiguration','WindowsMediaPlayerMediaLibrary','WindowsMediaPlayerPlayDVD','WindowsUpdate')]
    [String]$pack
    )

cls
Get-TroubleshootingPack -path $env:windir\diagnostics\system\$pack | Invoke-TroubleshootingPack

}


function Delete-Appv5Pkg {
<#
.Synopsis
   Removes all or specified APPV 5 packages from the machine.
.DESCRIPTION
   Removes all or specified APPV 5 packages from the machine.
.EXAMPLE
   Running the below command will display a selection menu that lists all the APPV5 packages on the machine giving you options to delete seperately or all.
   
   Delete-Appv5Pkg
#>

If ((Get-AppvClientPackage).Count -eq 0) {
    Write-Output "There are no APPV 5.x packages present on this machine."
}

Else{
    $array1 = (Get-AppvClientPackage -All).Name
    $list = 0

foreach ($arr in $array1)
{
  $list += 1
  write-host "[$list]" , $arr
}

# adds the Delete Everything selection to the array/list
$list += 1
write-host "[$list] Delete Everything!`n" -ForegroundColor Gray

$choice1 = Read-Host "Choose a package to delete 1-$list"

If ($choice1 -eq $list[-1]){

    $Answer = Read-Host "Are You Sure? Press [Y] to delete apps or [N] to cancel"
            If ($Answer -eq "Y"){
                Write-Output "Deleting ALL APPV 5.x packages..."
                write-progress -Activity "Deleting ALL APPV 5.x packages..."
                Get-AppvClientPackage -All | Stop-AppvClientPackage | Unpublish-AppvClientPackage | Remove-AppvClientPackage
            }
            ElseIf ($Answer -eq "N") {
                Write-Output "Cancelled deleting ALL APPV 5.x packages..."
                }
            Else {
                Write-Output "Invalid key!"} 
            }


ElseIf ($choice1 -eq ''){
        Write-Output "Invalid selection!"
}
ElseIf ($choice1 -gt $list){
        Write-Output "Not a listed selection!"
}
Else {
        $sel = $array1[$choice1-1]

        Write-Progress "Deleting [$sel]..."

        Stop-AppvClientPackage -name $sel | Unpublish-AppvClientPackage | Remove-AppvClientPackage

        Write-Output "[$sel] has been deleted."
        }

    }
}


function Sync-APPVServer {
<#
.Synopsis
   Forces a sync to the APPV Publishing Server
.DESCRIPTION
   Forces a sync to the APPV Publishing Server
.EXAMPLE
   Sync with the APPV Publishing Server with server id 1
   
   Sync-APPVServer
#>
    $PubSrv= (Get-AppvPublishingServer).Name
    write-progress "Syncing with APPV Publishing Server: $PubSrv"
    Sync-AppvPublishingServer -ServerId 1 -Force
}


function Get-MacAddress {

<#
.Synopsis
   Gets the MAC Address of a device from an SCCM Server
.DESCRIPTION
   Gets the MAC Address of a device from an SCCM Server
.EXAMPLE
   Gets the MAC Address of a device from server SERVER01 with site code D01 and search word "9C"
   
   Get-MacAddress -sccmserver SERVER01 -sitecode D01 -search 9C
#>
 
[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String[]]$SiteServer,
    [parameter(Mandatory=$true)]
    [String[]]$SiteCode,
    [String[]]$Search
    ) 

Get-WmiObject -class SMS_R_System -namespace root\SMS\site_$SiteCode -ComputerName $SiteServer | ? {$_.MACAddresses -like "$Search*"} | Select Name, MACAddresses | FT -AutoSize 
}


function Get-APPVLog {

<#
.Synopsis
   Retrieves the APPV Log File
.DESCRIPTION
   Retrieves the APPV Log File from the Event Viewer
.EXAMPLE
   Retrieves the APPV Log File from COMPUTER01 with a wild card search of "script" and returns maximum 4 results.
   
   Get-APPVLog -ComputerName COMPUTER01 -search script -max 4
#>
    
[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [ValidateLength(1,20)]
    [String]$ComputerName, 
    [String]$search,
    [int]$max
    ) 

If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
    $startTime = (Get-Date).AddDays(-2)
    Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{LogName="Microsoft-AppV-Client/Operational";StartTime=$startTime} -ErrorAction SilentlyContinue -MaxEvents $max | ? Message -like "*$search*" | FT ID,TaskDisplayName,Message -AutoSize -Wrap
}
Catch [System.exception] {
    write-output “Caught an exception:"
    write-output “Exception Type: $($_.Exception.GetType().FullName)”
    write-output “Exception Message: $($_.Exception.Message)”
    }
}
Else {
    write-output "$ComputerName is unreachable."
    }
}

function Get-PCinfo {

<#
.Synopsis
   Retrieves all the details of the computer
.DESCRIPTION
   Retrieves all the details of the computer
.EXAMPLE
   Retrieves the details from COMPUTER01
   
   Get-PCinfo -ComputerName COMPUTER01
#>
    
[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [ValidateLength(1,20)]
    [String]$ComputerName
    ) 

If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
    
   Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName | Select Model,Name,@{n='RAM(Gigs)';e={[int]($_.TotalPhysicalMemory/1GB)}},Bootupstate | FT -AutoSize -wrap
   Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select Version,@{n='Service Pack';e={$_.ServicePackMajorVersion}}, OSArchitecture, Status  | FT -AutoSize -wrap
   Get-WMIObject Win32_logicaldisk -ComputerName $ComputerName | Select-Object @{n='Drive Letter';e={$_.DeviceID}},`
                                                                    @{n='Drive Label';e={$_.VolumeName}},`
                                                                    @{n='Size(MB)';e={[int]($_.Size / 1MB)}},`
                                                                    @{n='FreeSpace(%)';e={[math]::Round($_.FreeSpace / $_.Size,2)*100}}  | FT -AutoSize -wrap

             
}
Catch [System.exception] {
    write-output “Caught an exception:"
    write-output “Exception Type: $($_.Exception.GetType().FullName)”
    write-output “Exception Message: $($_.Exception.Message)”
    }
}
Else {
    write-output "$ComputerName is unreachable."
    }
}

function Get-SCCM12members {

<#
.Synopsis
   Retrieves all the members of an SCCM 2012 collection
.DESCRIPTION
   Retrieves all the members of an SCCM 2012 collection
.EXAMPLE
   Retrieves the members from collections starting with "meta"
   
   Get-SCCM12members meta 

   Connect to SCCM 2012 primary Site
   
   Enter-PSSession xggc-sccm-pr-01 -Authentication Default 

Import-Module "E:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"

CD XG1:
#>
    
[cmdletbinding()]
    
    Param (
    [parameter(Mandatory=$true)]
    [String]$CollectionName
    ) 


get-cmdevicecollection -name "*$CollectionName*" | ForEach-Object {Get-CMDevice -CollectionName $_.name | Select-Object name, $_.name}

}