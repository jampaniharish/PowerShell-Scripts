$app = "*winscribe*"
$adv = import-csv "\\xggc-mgmt-11\ideproject$\Matt Balzan\Reports\SCCM_Adverts.csv" -Header Name | where {$_.name -like $app}
$pac = import-csv "\\xggc-mgmt-11\ideproject`$\Matt Balzan\Reports\PackagingList.csv" -Header Name,Version | where {$_.name -like $app}
$res = $adv + $pac | Select Name, Version
$res 