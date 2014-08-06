$File = Import-Csv 'C:\Users\da-balzama390\Desktop\BadgerNetComputers.csv' #NOTE: the first line of this file must say machinename

foreach ($line in $file)

{

$machinename = $line.machinename

#Continue the script even if an error happens

trap [Exception] {continue}

 

$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine",$MachineName)

#Set the Reg Container

$key = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\"

$regkey = "" #clears the value between loop runs

$regkey = $reg.opensubkey($key)

$regkey1 = "" #clears the value between loop runs

$regkey1 = $reg.opensubkey($key)

 

$SEPver = "" #clears the value between loop runs

#$SEPname = ""

#NOTE: the values between the " ' " symbols are the key you're looking for

$SEPver = $regKey.GetValue('DisplayVersion')
$SEPname = $regkey1.GetValue('DisplayName')

$Results = $MachineName , $SEPName , $SEPver

Write-host $Results #| export-csv -path "C:\Users\da-balzama390\Desktop\Apps.csv"

#Write-Output #########

}