[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Provision Machine"
$objForm.Size = New-Object System.Drawing.Size(400,300) 
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
$OKButton.Add_Click($provision_click)
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
$objLabel.Text = "Enter the new computer name below:"
$objForm.Controls.Add($objLabel) 

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox.Size = New-Object System.Drawing.Size(200,20) 
$objForm.Controls.Add($objTextBox) 

$groupBox = New-Object System.Windows.Forms.GroupBox #create the group box
$groupBox.Location = New-Object System.Drawing.Size(10,70) #location of the group box (px) in relation to the primary window's edges (length, height)
$groupBox.size = New-Object System.Drawing.Size(270,125) #the size in px of the group box (length, height)
$groupBox.text = "Choose device to provision:" #labeling the box
$objForm.Controls.Add($groupBox) #activate the group box

$RadioButton1 = New-Object System.Windows.Forms.RadioButton #create the radio button
$RadioButton1.Location = new-object System.Drawing.Point(10,15) #location of the radio button(px) in relation to the group box's edges (length, height)
$RadioButton1.size = New-Object System.Drawing.Size(70,40) #the size in px of the radio button (length, height)
$RadioButton1.Checked = $true #is checked by default
$RadioButton1.Text = "Tablet" #labeling the radio button
$groupBox.Controls.Add($RadioButton1) #activate the inside the group box

$RadioButton2 = New-Object System.Windows.Forms.RadioButton #create the radio button
$RadioButton2.Location = new-object System.Drawing.Point(10,45) #location of the radio button(px) in relation to the group box's edges (length, height)
$RadioButton2.size = New-Object System.Drawing.Size(70,40) #the size in px of the radio button (length, height)
$RadioButton2.Text = "Laptop" #labeling the radio button
$groupBox.Controls.Add($RadioButton2) #activate the inside the group box

$RadioButton3 = New-Object System.Windows.Forms.RadioButton #create the radio button
$RadioButton3.Location = new-object System.Drawing.Point(10,75) #location of the radio button(px) in relation to the group box's edges (length, height)
$RadioButton3.size = New-Object System.Drawing.Size(70,40) #the size in px of the radio button (length, height)
$RadioButton3.Text = "Desktop" #labeling the radio button
$groupBox.Controls.Add($RadioButton3) #activate the inside the group box

$provision_click ={ 

$DOMAIN="xggc.scot.nhs.uk"
$userid="$DOMAIN\svc_win10bc"
$secure_string_pwd = convertto-securestring "!QAZ1qaz" -asplaintext -force
$creds = New-Object System.Management.Automation.PSCredential $userid,$secure_string_pwd
$newcomputername = $objTextBox.Text



Try{

if ($newcomputername -eq "") {$statusBar1.ForeColor= "Red"
    $statusBar1.Text = "Please enter a computer name!"}
if ($RadioButton1.Checked -eq $true) {$OUPath="OU=Windows 10 Tablets,OU=Portable PCs,OU=PCs,DC=xggc,DC=scot,DC=nhs,DC=uk"}
if ($RadioButton2.Checked -eq $true) {$OUPath="OU=Windows 10 Laptops,OU=Portable PCs,OU=PCs,DC=xggc,DC=scot,DC=nhs,DC=uk"}
if ($RadioButton3.Checked -eq $true) {$OUPath="OU=Win10 Desktops,OU=Standard Desktop PCs,OU=PCs,DC=xggc,DC=scot,DC=nhs,DC=uk"}
    Write-Host "$newcomputername added to $OUPath"
    $statusBar1.ForeColor= "Green"
    $statusBar1.Text = "$newcomputername added to $OUPath"
    
    Add-Computer -NewName $newcomputername -DomainName $DOMAIN -Credential $creds -OUPath $OUPath -Force -WhatIf
    #WARNING: The changes will take effect after you restart the computer OLDHOSTNAME.

    Restart-Computer -Confirm

    $statusBar1.ForeColor= "Green"
    $statusBar1.Text = "Rebooting..."
    }
Catch [System.exception]
{ 
    
    $statusBar1.ForeColor= "Red"
    $statusBar1.Text = "Please fill in a computer name!"
    }

    
}

$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter"){&amp; $provision_click}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
{$objForm.Close()}})

$statusBar1 = New-Object System.Windows.Forms.StatusBar
$statusBar1.Name = "statusBar1"
$statusBar1.Text = "Matt Balzan 06.07.16"
$objform.Controls.Add($statusBar1)

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()