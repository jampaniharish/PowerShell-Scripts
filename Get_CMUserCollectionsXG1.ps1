cls
# get Mac address of devices
#gwmi -Class SMS_R_SYSTEM -ComputerName $SCCMServer -Namespace root\SMS\site_$siteCode | ? {$_.MACAddresses -like "9C*"}| select name, macaddresses

function AddUserToCollection{
# get all the "User_" user collections
$colls = (gwmi -Class SMS_Collection -ComputerName $SCCMServer -Namespace root\SMS\site_$siteCode | ? {$_.Name -like "User_*"}).Name
$list=0

Foreach ($coll in $colls){

$list+=1
write-host "[$list]" , $coll
}
$choice1 = Read-Host "Choose a user collection 1-$list"
$sel = $colls[$choice1-1]
$user = Read-Host "Type user name to add to $sel"

#here comes add to coll code...

}

#get ccm application state (return results are located here: https://msdn.microsoft.com/en-us/library/jj874280.aspx)
#Get-WmiObject -Namespace "Root\CCM\Clientsdk" -Class "CCM_Application" | select name, EvaluationState