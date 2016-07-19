cls
$search = "*flash*"
$list = Get-WmiObject -Computername xggc-sccm-01 -Namespace root\sms\site_c01 -Class SMS_Collection | Select Name #, CollectionID 
$list | Where-Object {$_.Name -like "$search"} |  Select Name #Out-GridView -Title "SCCM 2007 Collections - Search term: $search" | Format-Wide -AutoSize

#Get-WmiObject -Computername xggc-sccm-01 -Namespace root\sms\site_c01 -Class SMS_Collection  | get-member
#$list = Get-WmiObject -Computername xggc-sccm-01 -Namespace root\sms\site_c01 -Class SMS_Collection | Select MemberClassName

#$list | Where-Object {$_.Name -like "$search"} <#| Out-File c:\ISO\CollectionID.csv #>| Select Name #Out-GridView -Title "SCCM 2007 Collections - Search term: $search" | Format-Wide -AutoSize

<#$CollectionID = "C010034F"

$subcollections = Get-WmiObject -ComputerName xggc-sccm-01 -namespace root\sms\site_C01 -class SMS_CollectToSubCollect -Filter "parentCollectionID = '$CollectionID'"

foreach ($subcoll in $subcollections)
{

$subcoll.collectionid | Select $_.Name
}

#>