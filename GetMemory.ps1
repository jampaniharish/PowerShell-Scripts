get-WmiObject -ComputerName xggc-pkg-01 -class win32_physicalmemory | ft PSComputerName,@{n='Memory (GB)';e={$_.capacity / 1GB -as [int]}} -autosize

