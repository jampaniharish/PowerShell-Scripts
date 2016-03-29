$Group = "APPV50020_MicroStrategy_CNISSA"
$Added = Add-ADGroupMember $Group CMH1\JWILSON1
$Added
#IF A PC use quotes for the computername this script -> Add-ADGroupMember $Group -Members "pkg01-w7-64$"
#ForEach-Object (Get-ADPrincipalGroupMembership -Identity $Added | where {$_.Name -like $Group} | Select Name | Sort-Object -Descending)
