cls
Get-ADGroup -Filter {name -like "*emis*"} -Properties Description | Select Name