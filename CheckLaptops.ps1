cls
$laptops = Get-Content c:\iso\laptops.txt

foreach ($computername in $laptops){

If (Test-Connection -Count 1 -ComputerName $ComputerName -Quiet) {
    
Try {
        
    Write-output "$ComputerName is online" 
    New-Item c:\iso\$computername -ItemType Directory -Force
    Copy-Item "\\$computername\c$\windows\system32\ccm\logs\execmgr.log" -Destination c:\iso\$computername
    
    }

Catch [System.exception] {
    "[$computername] failed"
    }
}
Else {
    write-output "$computername is unreachable."
    }

}
