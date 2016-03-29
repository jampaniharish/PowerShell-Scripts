#Find collection
 param($collectionid,$Direction)

$script:siteserver = “xggc-sccm-01”
$script:sitecode = “C01”
function FindCollectionDown
 {
 param($parentcollID)

$subcollections = Get-WmiObject -ComputerName $script:siteserver -namespace root\sms\site_$Script:sitecode -query “select * from sms_collection where collectionid in (select subcollectionid from sms_collecttosubcollect where parentcollectionid = ‘$parentcollID’)”
if ($subcollections -ne $null)
 {
 foreach ($subcoll in $subcollections)
 {
 write-host $subcoll.name
 FindCollectionDown $subcoll.collectionid
 }
 }
 }

function FindCollectionUP
 {
 param($collID)
 do
 {
 $parentColl = (Get-WmiObject -ComputerName $script:siteserver -namespace root\sms\site_$Script:sitecode -query “select name from sms_collection where collectionid in (select parentcollectionid from sms_collecttosubcollect where subcollectionid = ‘$collid’)”).name
 $collID = (Get-WmiObject -ComputerName $script:siteserver -namespace root\sms\site_$Script:sitecode -query “select collectionid from sms_collection where name = ‘$parentcoll'”).collectionid
 write-host $ParentColl

}
 while ($parentColl -ne “Root Collection”)

}

if ($direction -eq “up”) {FindCollectionUP $collectionid}
 if ($direction -eq “down”) {FindCollectionDown $collectionid}
