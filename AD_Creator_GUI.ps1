[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "AD Group Creator"
$objForm.Size = New-Object System.Drawing.Size(300,280) 
$objForm.StartPosition = "CenterScreen"
$objform.MaximumSize = $objform.size
$objform.MinimumSize = $objform.size

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$objTextBox.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,180)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click($adgroup_click)
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,180)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Please enter the name of the AD group below:"
$objForm.Controls.Add($objLabel) 

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBox) 

$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(10,70) 
$objLabel2.Size = New-Object System.Drawing.Size(280,20) 
$objLabel2.Text = "[OPTIONAL] Add name of the machine below:"
$objForm.Controls.Add($objLabel2) 

$objTextBox2 = New-Object System.Windows.Forms.TextBox 
$objTextBox2.Location = New-Object System.Drawing.Size(10,90) 
$objTextBox2.Size = New-Object System.Drawing.Size(260,20) 
$objForm.Controls.Add($objTextBox2) 

$adgroup_click ={

$CMSiteCode = "XG1" #Your site code
$CMSiteServerFQDN = "XGGC-SCCM-PR-01" #FQDN to your site server
New-Item -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name DomainName -Value "" -PropertyType String -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name ServerName -Value $CMSiteServerFQDN -PropertyType String -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name SiteCode -Value $CMSiteCode -PropertyType String -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1 -Name SiteName -Value "Primary Site $($CMSiteCode)" -PropertyType String -Force

Import-Module ‘c:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1’

Import-Module ActiveDirectory

$server = "xggc-adds-01P.xggc.scot.nhs.uk"
$path = "OU=SCCM Application Deployment Groups,OU=Standard Groups,OU=Groups,DC=xggc,DC=scot,DC=nhs,DC=uk"

$statusBar1.Text = “Adding…”
$name = $objTextBox.Text
$machines = $objTextBox2.Text

Try
{
    New-ADGroup -Server $server -name $name -GroupCategory Security -GroupScope DomainLocal -Path $path -Description $desc -DisplayName $name -ErrorAction stop
    Write-Host "AD Group: $name added!" -ForegroundColor Green
    $result_label.ForeColor= "Green"
    $result_label.Text = "AD Group: $name added!"
   }
Catch [System.exception]
{ 
    write-host "AD Group: $name already exists!" -ForegroundColor Red
    $result_label.ForeColor= "Red"
    $result_label.Text = "AD Group: $name already exists!"
    }

# check to see if device exists in group, if not add it...
Try{
    Add-ADGroupMember $name -Members $machines -Server $server
    Write-Host "Device: $machines added to group: $name" -ForegroundColor Green
    $result_label2.ForeColor= "Green"
    $result_label2.Text = "Device: $machines added!"
    }
Catch [System.exception]
{ 
    write-host "AD Group member: $machines already exists!" -ForegroundColor Red
    $result_label2.ForeColor= "Red"
    $result_label2.Text = "Device: $machines already exists!"
    }

# check to see if CM Query Collection exists, if not add it...
Try{
    CD XG1:
    
    $schedule = New-CMSchedule -RecurInterval Minutes -RecurCount 15

    New-CMDeviceCollection -Name $name -LimitingCollectionName "All Systems" -RefreshSchedule $schedule

    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $name -QueryExpression "select *  from  SMS_R_System where SMS_R_System.SystemGroupName = 'XGGC\\$name'" -RuleName "Query_$name"

    $coll = Get-CMDeviceCollection -Name $name

    Move-CMObject -FolderPath "XG1:\DeviceCollection\Application Deployment" -InputObject $coll

    Write-Host "Collection: $name created." -ForegroundColor Green
    $result_label3.ForeColor= "Green"
    $result_label3.Text = "Collection: $name created."
    }
Catch [System.exception]
{ 
    write-host "Collection: $name already exists!" -ForegroundColor Red
    $result_label3.ForeColor= "Red"
    $result_label3.Text = "Collection: $name already exists!"
    }

$statusBar1.Text = "AD Group & Query Collection creation complete."
}

$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter"){&amp; $adgroup_click}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
{$objForm.Close()}})

$statusBar1 = New-Object System.Windows.Forms.StatusBar
$statusBar1.Name = "statusBar1"
$statusBar1.Text = "Matt Balzan 02.02.16 - v2"
$objform.Controls.Add($statusBar1)

$result_label = New-Object System.Windows.Forms.Label
$result_label.Location = New-Object System.Drawing.Size(10,120) 
$result_label.Size = New-Object System.Drawing.Size(280,20) 
$result_label.Text = ""
$objForm.Controls.Add($result_label)

$result_label2 = New-Object System.Windows.Forms.Label
$result_label2.Location = New-Object System.Drawing.Size(10,140) 
$result_label2.Size = New-Object System.Drawing.Size(280,20) 
$result_label2.Text = ""
$objForm.Controls.Add($result_label2)

$result_label3 = New-Object System.Windows.Forms.Label
$result_label3.Location = New-Object System.Drawing.Size(10,160) 
$result_label3.Size = New-Object System.Drawing.Size(280,20) 
$result_label3.Text = ""
$objForm.Controls.Add($result_label3)


$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()