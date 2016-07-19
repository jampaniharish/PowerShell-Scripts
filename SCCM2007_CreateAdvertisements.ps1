$AppName = "DMW - IE11 v8"
$Site = "site_c01"
$CollectionID = 
$PackageID = 
$SCCMServer = "xggc-sccm-01"

$Program = Get-WmiObject -ComputerName $Computer -Namespace "root\SMS\Site_$Site" -Query "Select * from SMS_Program WHERE PackageID = '$packageID'"

# Get the current date + time
$Format = get-date -format yyyyMMddHHmmss
$Date = $Format + ".000000+***"

# Create Assigment Time
$sceduleTime = ([WMIClass] "\\$Computer\root\sms\site_$site`:SMS_ST_NonRecurring").CreateInstance()

$sceduleTime.DayDuration = 0
$sceduleTime.HourDuration = 0
$sceduleTime.MinuteDuration = 0
$sceduleTime.IsGMT = "false"
$sceduleTime.StartTime = $Date

# Create Advertisment
$Advertisement = ([WMIClass] "\\$Computer\root\sms\site_$site`:SMS_Advertisement").CreateInstance()

$Advertisement.AdvertFlags = "33685504";
$Advertisement.AdvertisementName = $AppName;
$Advertisement.CollectionID = $CollectionID;
$Advertisement.PackageID = $packageID;
$Advertisement.AssignedSchedule = $sceduleTime;
$Advertisement.DeviceFlags = 0x01000000;
$Advertisement.ProgramName = $Program.ProgramName;
$Advertisement.RemoteClientFlags = "72";
$Advertisement.PresentTime = $Date;
$Advertisement.SourceSite = $Site;
$Advertisement.TimeFlags = "24593"

# Apply Advertisement
$Advertisement.put()