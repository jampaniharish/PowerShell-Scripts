# pings machine and finds version of filename
cls
$computer = "10.50.9.119"
#$filename = "windows\system32\msiexec.exe"
$filename = "Program Files\Internet Explorer\iexplore.exe"
if
(
   Test-Connection -Count 1 -ComputerName $computer -Quiet
    )
{
try 
{
get-item "\\$computer\C$\$filename" | Format-list -Property *version*
}
catch [system.exception]
{
        "not found"
    }
        }
    else
    {
        write-host "$computer is unreachable."
        }

