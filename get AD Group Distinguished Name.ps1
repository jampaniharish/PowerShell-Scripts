Get-ADGroup -Filter {name -like "*Orca*"} -Properties Description | Select DistinguishedName