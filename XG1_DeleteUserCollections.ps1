# imports list of collections, creates the collection names and moves them into Device Collection folder
# M. Balzan 10.05.2016
<# cls
Import-Module '\\xggc-sccm-pr-01\E$\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' -Verbose

set-location XG1: #>

$colls = Get-Content C:\temp\RemoveUserCollections.txt

    foreach ($coll in $colls){

    Write-Output "Removing $Coll..."

    Remove-CMUserCollection -name $coll -Force

    Write-Output "Done!"
    }
