$model = "x230"
Get-WmiObject -computername xggc-sccm-15 -Namespace "root\SMS\Site_E01" -Class SMS_G_System_COMPUTER_SYSTEM | Where Name -like "*TC147040*" | Select Model,Name
Get-WmiObject -computername xggc-sccm-01 -Namespace "root\SMS\Site_C01" -Class SMS_G_System_COMPUTER_SYSTEM | where Model -like "*$model*"  | Select Model, Name -Last 5