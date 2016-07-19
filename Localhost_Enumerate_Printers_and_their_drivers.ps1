        $printers = Get-WmiObject -Class Win32_Printer
        $results = foreach ($printer in $printers)
        {
           
                [PSCustomObject]@{
                    Systemname = $printer.SystemName
                    Name = $printer.Name
                    PortName = $printer.PortName
                    DriverName = $printer.DriverName
                }
            }
       $results | ft -AutoSize