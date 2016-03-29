    $CMModule = "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
    $CMSiteCode = "e01"
    $CMSiteCode = $CMSiteCode + ":"
    Import-Module $CMModule
    Set-Location $CMSiteCode
    Set-CMQueryResultMaximum 100
    $ErrorActionPreference = "SilentlyContinue"
    $Devices = Get-CMDevice -CollectionName "All Systems" | Select Name
    
    $serial = Get-wmiobject win32_bios -ComputerName $Devices | Select SerialNumber
    
    #$username = gwmi Win32_ComputerSystem -computername $computers| select username

    $obj = $Devices + " - " + $serial
    
    write-output $obj | Out-GridView