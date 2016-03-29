# Find Visio version and Product ID and then uninstall it
# M.Balzan 14.12.2015

$app = Get-WmiObject -Class win32Reg_AddRemovePrograms -filter "DisplayName like '%Vis%'" -ErrorAction SilentlyContinue
$log = "c:\windows\temp\1_Office_VISIO_Removal.log"

$verpath = get-childitem "C:\program files\Microsoft Office\%Visio%" -Name
$visstd = "C:\Program Files\Common Files\Microsoft Shared\$verpath\Office Setup Controller\setup.exe /uninstall VISSTD /config %~dp0VISSTD.xml"
$vispro = "C:\Program Files\Common Files\Microsoft Shared\$verpath\Office Setup Controller\setup.exe /uninstall VISPRO /config %~dp0VISPRO.xml"

if ($app.ProdID -contains 'VISSTD')
{
    "Removing VISIO STD..." | Out-file $log
    Start-Job -ScriptBlock {$visstd} -Name VISSTD 
    Wait-Job -Name VISSTD
    "VISIO STD uninstalled." | Out-file -Append $log

}
elseif ($app.ProdID -contains 'VISPRO')
{
    "Removing VISIO PRO..." | Out-file $log
    Start-Job -ScriptBlock {$vispro} -Name VISPRO 
    Wait-Job -Name VISPRO
    "VISIO PRO uninstalled." | Out-file -Append $log
    
}
else {"No Visio products installed on this machine at this time." | Out-file $log
      Get-Date | Out-file -Append $log
}

