 # In case of running this script more than once: delete existing profiles
 netsh mbn delete profile interface="Cellular" name="NHSGGC-APN"

 # Copy APN xml template file to local machine
 New-Item -ItemType Directory -path "C:\Windows\SIM" -Force
 Copy-Item "\\xggc-vrtl-03\SCCMContent\Compliance\APN\Settings.xml" -Destination "C:\Windows\SIM" -Force
 $XMLFile = "C:\Windows\SIM\Settings.xml"
 
 <# Get SIM Subscriber ID
 $subid = ((netsh mbn sh readyinfo * | select-string "Subscriber Id").toString())
 $subid = $subid.substring($subid.length - 15, 15)
 $subid#>

 # Get SIM Id
 $simid = ((netsh mbn sh readyinfo * | select-string "SIM ICC Id").toString())
 $simid = $simid.substring($simid.length - 19, 19)
 $simid

 # Add to the XML file
 $xml = [xml](Get-Content $XMLFile)
 #$xml.MBNProfileExt.SubscriberID = $subid
 $xml.MBNProfileExt.SimIccID = $simid
 $xml.Save($XMLFile)

 # Add new APN Profile
 netsh mbn add profile interface="Cellular" name="$XMLFile"
