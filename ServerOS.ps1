$servers = Get-Content "c:\ISO\servers3.txt"

ForEach ($server in $servers) {
    Write-Output "Processing $server..." | out-file c:\iso\Server_OS.log
        $OS = (Get-WmiObject Win32_OperatingSystem -computername $server).OSArchitecture
    Write-Output "$server - $OS" | Out-File C:\ISO\Server_OS.log -Append

    }