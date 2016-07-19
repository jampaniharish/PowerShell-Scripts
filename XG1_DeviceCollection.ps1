# imports list of collections, creates the collection names and moves them into Device Collection folder
# M. Balzan 10.05.2016
<# cls
Import-Module '\\xggc-sccm-pr-01\E$\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' -Verbose

set-location XG1: #>

$colls = Get-Content C:\temp\UserCollections.txt
$a = Get-Date
$schedule = New-CMSchedule -RecurInterval Days -RecurCount 7 -Start $a

    foreach ($coll in $colls){

    Write-Output "Adding $Coll..."

    $name = "Machine_$coll"

    New-CMDeviceCollection -Name $name -LimitingCollectionName "All Systems" -RefreshSchedule $schedule

    $newCM = Get-CMDeviceCollection -Name $name

    Move-CMObject -InputObject $newCM -FolderPath "XG1:\DeviceCollection\Application Deployment"

    Write-Output "Done!"
    }

    # script used to create DeviceCollections.txt
    #Get-CMDeviceCollection -Name | ? {$_.Name -notcontains "*UNINSTALL*"} | out-file C:\Temp\DeviceCollections.txt

