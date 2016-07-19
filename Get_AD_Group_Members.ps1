# Matt Balzan 07-05-2016
# just replace text name_of_your_AD_Group with your AD Group name
$ADGroupName = "APPV50042_Q-Pulse_6.2_Test" 

Get-ADUser -Filter "memberOf -RecursiveMatch '$((Get-ADGroup "$adgroupname").DistinguishedName)'" | Select Name, UserPrincipalName, Enabled | FT -AutoSize

(Get-ADUser -Filter "memberOf -RecursiveMatch '$((Get-ADGroup "$adgroupname").DistinguishedName)'").Count  #| Export-Csv c:\users.csv