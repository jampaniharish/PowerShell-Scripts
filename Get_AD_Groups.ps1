cls
Get-ADGroup -Filter {name -like "westway"} -Properties Description | Select Name

#Get-ADGroup | where {$_.name -like "*visio*"} -Properties Description | Select Name