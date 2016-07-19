# imports list of 2 columns with headers called CollectionName & SoftwareName, creates the Deployments for all the Applications using the csv.
# M.Balzan 18.05.2016

Import-Module 'E:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' -Verbose

CD XG1:

#Import-Csv C:\Temp\Applications2.csv -Header SoftwareName, CollectionName | ForEach-Object{Start-CMApplicationDeployment -Name $_.SoftwareName -CollectionName $_.CollectionName -DeployPurpose Available -DeployAction Install -UserNotification DisplayAll -AvailableDate (Get-Date) -AvailableTime (Get-Date)}




# the scripts used to import the lists:

#Get-CMApplication | ? {$_.LocalizedDisplayName -like "*Machine_APPS*"} | select LocalizedDisplayName | out-file C:\Temp\Applications2.csv
#Get-CMUserCollection | select Name | out-file C:\Temp\Applications2.csv -Append

(Get-CMDeviceCollection -name *meta*).Name

