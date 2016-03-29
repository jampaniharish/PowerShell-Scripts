# Find Visio version and then uninstall it
# M.Balzan 14.12.2015

$log = "c:\windows\temp\1_Office_VISIO_Removal.log"
"Searching for Visio products..."  | Out-file $log

$app = Get-WmiObject -Class win32_Product -filter "Name like '%Microsoft Office Visio%'" -ErrorAction SilentlyContinue
$appname = $app.Name | Select -First 1
$ver = $app.Version.Substring(0,2) | select -First 1
$osc = "`"C:\Program Files\Common Files\Microsoft Shared\Office$ver\Office Setup Controller\setup.exe`""
$visStd = "/uninstall VISSTD /dll OSETUP.DLL /config $PSScriptRoot\VISSTD.xml"
$visPro = "/uninstall VISPRO /dll OSETUP.DLL /config $PSScriptRoot\VISPRO.xml"
$visio = "/uninstall VISIO /dll OSETUP.DLL /config $PSScriptRoot\VISIO.xml"

$remove = "Removing $appname..."  | Out-file -Append $log

if ($appname -like '*2003*')    
{
    $remove
    $app.Uninstall() 
    "$appname uninstalled successfully." | Out-file -Append $log
    Get-Date | Out-file -Append $log
}
elseif ($appname -like '*2010*')
  
{
    $remove
    Start-Process -FilePath $osc -ArgumentList $visio -Wait -Verbose
    "$appname uninstalled successfully." | Out-file -Append $log
    Get-Date | Out-file -Append $log
}
elseif ($appname -like '*Standard*')
  
{
    $remove
    Start-Process -FilePath $osc -ArgumentList $visStd -Wait -Verbose
    "$appname uninstalled successfully." | Out-file -Append $log
    Get-Date | Out-file -Append $log
}
elseif ($appname -like '*Pro*')
  
{
    $remove
    Start-Process -FilePath $osc -ArgumentList $visPro -Wait -Verbose
    "$appname uninstalled successfully." | Out-file -Append $log
    Get-Date | Out-file -Append $log
}
else 
{
    "No Visio products found on this machine at this time." | Out-file -Append $log
    Get-Date | Out-file -Append $log
}