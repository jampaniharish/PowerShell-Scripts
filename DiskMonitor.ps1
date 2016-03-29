$inputXML = @"
<Window x:Name="DiskMonitor" x:Class="WpfApplication2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication2"
        mc:Ignorable="d"
        Title="Disk Monitor" Height="350" Width="420">
     <Grid Margin="0,0,2,11" Background="Black">
        <ListView x:Name="listView" HorizontalAlignment="Left" Height="222" Margin="0,78,0,0" VerticalAlignment="Top" Width="417" BorderBrush="#FFEAF2FF" FontSize="14">
            <ListView.View>
                <GridView>
                    <GridViewColumn Header="Drive Letter" DisplayMemberBinding ="{Binding 'Drive Letter'}" Width="100" />
                    <GridViewColumn Header="Drive Label" DisplayMemberBinding ="{Binding 'Drive Label'}" Width="100"/>
                    <GridViewColumn Header="Size(MB)" DisplayMemberBinding ="{Binding Size(MB)}" Width="100"/>
                    <GridViewColumn Header="FreeSpace%" DisplayMemberBinding ="{Binding FreeSpace%}" Width="100"/>
                </GridView>
            </ListView.View>
        </ListView>
        <TextBox x:Name="textbox" HorizontalAlignment="Left" Height="21" Margin="114,23,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="122"/>
        <Button x:Name="button" Content="START" HorizontalAlignment="Left" Height="21" Margin="241,23,0,0" VerticalAlignment="Top" Width="56"/>
        <Label x:Name="label" Content="ComputerName" HorizontalAlignment="Left" Height="28" Margin="15,19,0,0" VerticalAlignment="Top" Width="96" Foreground="#FF00D1FF"/>
        <Image x:Name="image" HorizontalAlignment="Left" Height="55" Margin="340,11,0,0" VerticalAlignment="Top" Width="55" Source="C:\ISO\TekMonster.png"/>
    </Grid>
</Window>
"@

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables
 
#===========================================================================
# Actually make the objects work
#===========================================================================
 
 
 
Function Get-DiskInfo {
param($computername =$env:COMPUTERNAME)
 
Get-WMIObject Win32_logicaldisk -ComputerName $computername | Select-Object @{Name='ComputerName';Ex={$computername}},`
                                                                    @{Name=‘Drive Letter‘;Expression={$_.DeviceID}},`
                                                                    @{Name=‘Drive Label’;Expression={$_.VolumeName}},`
                                                                    @{Name=‘Size(MB)’;Expression={[int]($_.Size / 1MB)}},`
                                                                    @{Name=‘FreeSpace%’;Expression={[math]::Round($_.FreeSpace / $_.Size,2)*100}}
                                                                 }
                                                                  
$WPFtextBox.Text = $env:COMPUTERNAME
 
$WPFbutton.Add_Click({

$a=0

$WPFlistView.Items.Clear()
Do {$a++
start-sleep -Milliseconds 840
Get-DiskInfo -computername $WPFtextBox.Text | % {$WPFlistView.AddChild($_)}
start-sleep -Milliseconds 3600
}Until ($a -le 5)
})
#Sample entry of how to add data to a field
 
 
#$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
 
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null

