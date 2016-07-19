If ((Get-Item 'c:\Program Files\Internet Explorer\iexplore.exe').ProductVersion -lt 11){
      write-host  "IE is version 8"
      & "$env:SystemRoot\system32\mshta.exe" .\NHSGGC_IE_ALERT.hta
      }


Else {
    write-host  "IE is version 11"
}