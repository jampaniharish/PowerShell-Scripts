$comps = gc c:\iso\appvmachines.txt
foreach ($ComputerName in $comps){

If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
        
    Write-Progress -Activity "Searching $ComputerName using wild card search term: (App-V)" 
 
    Get-WmiObject -Class win32_Product -ComputerName $ComputerName | ? {$_.Name -match "(App-V)"} -ErrorAction SilentlyContinue |
    
    Select PSComputerName,Name,Version | FT -AutoSize -wrap -HideTableHeaders | Out-File c:\ISO\ConfidenceReportAPPV5.txt -Append
    }

Catch [System.exception] {
    write-output “Caught an exception: $($_.Exception.Message)"  | Out-File c:\ISO\ConfidenceReportAPPV5_ExceptionError.txt -Append
    }
}
Else {
    write-output "$ComputerName" | Out-File c:\ISO\ConfidenceReportAPPV5_Unreachable.txt -Append
    }

}
