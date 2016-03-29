$user = gwmi Win32_ComputerSystem | select username
$serial = gwmi win32_bios | fl SerialNumber
$comp = gwmi win32_