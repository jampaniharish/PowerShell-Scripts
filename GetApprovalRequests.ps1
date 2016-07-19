cls
# import CM module and connect to SQL
import-module ‘e:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1’
CD XG1:
$info = Get-WmiObject -Class SMS_UserApplicationRequest -Namespace root\SMS\Site_XG1 | ?{$_.CurrentState -eq 1} | Select Application, User, Comments, RequestGuid
$reqUser = $info.User
$reqApp = $info.Application
$reqComms = $info.Comments
$reqGUID = $info.RequestGUID
#create menu list array
$list=0
foreach ($req in $info)
{
    $list+=1
    write-host "[$list]" - "$reqUser" \ "$reqApp" \ "$reqComms"
}
write-host ""
$choice = Read-host "Choose a request to Approve 1-$list"
$sel = $info[$choice-1]
write-host "You have approved: $list"

#Approve-CMApprovalRequest -ApplicationName $sel.Application -User $sel.User -Comment "Request Approved." -Verbose

$email = (get-aduser -filter 'userPrincipalName -like "$($sel.User)"').UserPrincipalName

Send-MailMessage -From sccm@ggc-apps.scot.nhs.uk -Subject "Application Request: '${sel.Application}'" -To $sel.User -Body "Your application request has been approved." -DeliveryNotificationOption Never -Port 25 -SmtpServer 10.3.1.15