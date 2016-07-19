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
