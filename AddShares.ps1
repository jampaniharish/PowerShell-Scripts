$NasPath = 'Z:\EDrives\FredFlintstone'

$Shares=[WMICLASS]'WIN32_Share'

$ShareName='FredFlintstone`$'

New-Item -type directory -Path $NasPath

$Shares.Create($NasPath,$ShareName,0)

$Acl = Get-Acl $NasPath

$Ar = New-Object system.security.accesscontrol.filesystemaccessrule('Fred Flintstone','FullControl','ContainerInherit, ObjectInherit', 'None', 'Allow')

$Acl.AddAccessRule($Ar)

Set-Acl $NasPath $Acl
