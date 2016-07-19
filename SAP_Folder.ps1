<# Matt Balzan 09/05/2016 #>

$mydocdir = [environment]::getfolderpath(“mydocuments”)

If (!(Test-Path "$mydocdir\My SAP BusinessObjects Documents"))
{
New-Item -ItemType Directory -Path "$mydocdir\My SAP BusinessObjects Documents" -Force
}
 
Copy-Item -Path .\NSSBOSRV06_nss_scot_nhs_uk@6400_j2ee.extranet -Destination "$mydocdir\My SAP BusinessObjects Documents" -Force

Copy-Item -Path .\NSSBOSRV07_nss_scot_nhs_uk@6400_j2ee.extranet -Destination "$mydocdir\My SAP BusinessObjects Documents" -Force