Gwmi -query "Select * from Application" -Namespace root\Microsoft\appvirt\client | Select @{n='Machine';e={$_.PSComputerName}},Name,Version | Sort-Object PSComputerName | ft -AutoSize

