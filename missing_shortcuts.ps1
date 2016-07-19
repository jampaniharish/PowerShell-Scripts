
$isd = "C:\Users\Public\Desktop\IT Service Desk.lnk"
if (test-path $isd)
{write-host "Compliant"}
else {write-host "Non-Compliant"}



Copy-Item "\\xggc-vrtl-03\SCCMContent\Compliance\APN\{EF9A5AFA-A17B-4A75-84F7-B3EB03542817}.xml" -Destination "C:\ProgramData\microsoft\WwanSvc\Profiles" -Force -Credential 

<#
New-Item -ItemType Directory -path "C:\Program Files\NHS_Desktop_Icons" -Force
Copy-Item "\\xggc-vrtl-03\SCCMContent\Compliance\CFG0001_IT_Service_Desk_Desktop_Shortcut_1.0\IT Service Desk.ico" -Destination "C:\Program Files\NHS_Desktop_Icons" -Force
#>