$computers = "c:\computers.txt"

foreach($computer in (Get-Content -Path $computers)){

Start-Process - Filepath 'C:\psexec.exe' -ArgumentList "\\$computer  -u xggc\da-packaging -p !QAZ1qaz -h -d powershell.exe "enable-psremoting -force""

}