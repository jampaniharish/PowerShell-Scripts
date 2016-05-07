# Matt Balzan 07-05-2016

$ADGroupName = "SCCM Reporting Administrators" # just replace text name_of_your_AD_Group with your AD Group name

(Get-ADUser -Filter "memberOf -RecursiveMatch '$((Get-ADGroup "$adgroupname").DistinguishedName)'").Name # | Select Name, UserPrincipalName, Enabled | FT