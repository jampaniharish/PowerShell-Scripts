# script by Matt Balzan - 20.04.2016

cls
# just edit the below two lines between the quotes only.
$FromGroup = "APPV50042_Q-Pulse_6.2_Test"
$ToGroup = "APPV-TEST"

$FromMembers = (Get-ADGroupMember $FromGroup).distinguishedName
$MemberCount= (Get-ADGroupMember $FromGroup).count

Write-Host "Copying members: $MemberCount" -ForegroundColor Cyan
Write-Host "From AD Group: $FromGroup to $ToGroup..." -ForegroundColor Magenta

Add-ADGroupMember $ToGroup -members $FromMembers

Write-Host "Copy complete!" -ForegroundColor Green