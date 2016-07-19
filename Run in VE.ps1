$AppVName = Get-AppvClientPackage *name*

Start-AppvVirtualProcess -AppvClientObject $AppVName cmd.exe
