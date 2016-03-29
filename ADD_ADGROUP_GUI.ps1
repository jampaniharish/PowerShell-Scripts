# script by Matt Balzan 27-01-16
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.location = New-Object System.Drawing.Size(5,40)
$textbox.size = New-Object System.Drawing.Size(120,20)
$form.Controls.Add($textbox)

$Add_Group_Click
{
import-module ActiveDirectory

$server = "xggc-adds-01P.xggc.scot.nhs.uk"
$path = "OU=SCCM Application Deployment Groups,OU=Standard Groups,OU=Groups,DC=xggc,DC=scot,DC=nhs,DC=uk"

# edit the 3 fields below only
$name = $textbox.Text
#$desc = ""
$machines = ""

# check to see if group exists, if not create it...

Try
{
    New-ADGroup -Server $server -name $name -GroupCategory Security -GroupScope DomainLocal -Path $path -Description $desc -DisplayName $name -ErrorAction stop
    Write-Host "AD Group: $name added!" -ForegroundColor Green
   }
Catch [System.exception]
{ 
    write-host "AD Group: $name already exists!" -ForegroundColor Red
    }

# check to see if device exists in group, if not add it...
Try{
    Add-ADGroupMember $name -Members $machines -Server $server
    Write-Host "Device: $machines added to group: $name" -ForegroundColor Green
    }
Catch [System.exception]
{ 
    write-host "AD Group member: $machines already exists!" -ForegroundColor Red
    }

}

$OKButton = New-Object System.Windows.Forms.TextBox
$OKButton.location = New-Object System.Drawing.Size(140,38)
$OKButton.size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click($Add_Group_Click)
$form.Controls.Add($OKButton)