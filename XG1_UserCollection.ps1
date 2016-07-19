# imports list of collections, creates the collection names and moves them into User Collection folder
# M. Balzan 10.05.2016
cls
Import-Module 'E:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'

CD XG1:

$colls = Get-Content C:\Temp\DeviceCollections.txt
$a = Get-Date
$schedule = New-CMSchedule -RecurInterval Days -RecurCount 7 -Start $a

    foreach ($coll in $colls){

    Write-Output "Adding $Coll..."

    $name = "User_$coll"

    New-CMUserCollection -Name $name -LimitingCollectionName "All Users" -RefreshSchedule $schedule

    $newCM = (Get-CMUserCollection -Name $name).CollectionID

    Move-CMObject -ObjectId $newCM -FolderPath "XG1:\UserCollection\Application Deployment"

    Write-Output "Done!"
    }

    # script used to create DeviceCollections.txt
    #Get-CMDeviceCollection -Name | ? {$_.Name -notcontains "*UNINSTALL*"} | out-file C:\Temp\DeviceCollections.txt