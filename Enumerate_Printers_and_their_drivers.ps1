$excludeList = "Microsoft XPS Document Writer",
    "Calyx Document Converter","Fax","Send To OneNote 2010",
    "Send To OneNote 2013","CutePDF Writer","M2M PDFWriter","Adobe PDF"
$computers = Get-ADComputer -Filter {Enabled -eq "True"}
$results = foreach ($computer in $computers)
{
    $name = $computer.Name
    Write-Verbose "Checking $name"
    if (Test-Connection -ComputerName $name -Count 1 -Quiet)
    {
        $printers = Get-WmiObject -Class Win32_Printer -ComputerName $computer.Name
        foreach ($printer in $printers)
        {
            if ($printer.Name -notin $excludeList)
            {
                [PSCustomObject]@{
                    Systemname = $printer.SystemName
                    Name = $printer.Name
                    PortName = $printer.PortName
                    DriverName = $printer.DriverName
                }
            }
        }
    }
}

# Sample outputs - pick one or more, your choice
$results
$results | Format-Table -AutoSize
$results | sort -Property SystemName | Out-GridView
$results | Export-Csv -Path .\foo.csv -NoTypeInformation -Encoding ASCII
$results | Out-File -FilePath .\foo.txt -Encoding ASCII
$results | Export-Clixml -Path .\foo.xml -Encoding ASCII
