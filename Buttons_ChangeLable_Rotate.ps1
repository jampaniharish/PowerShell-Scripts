<#
Labels do not have the ability to perform a textwrap, so any lines that are bigger than
the label will not be shown. 
#>

Function Set-Rotation {
    [cmdletbinding()]
    Param (
        [object]$Control,
        [int]$Angle = 45,
        [int]$X = 0,
        [int]$Y = 0
    )
    $Control.RenderTransform = New-Object System.Windows.Media.RotateTransform -ArgumentList $Angle,$X,$Y
}

#Build the GUI
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Initial Window" WindowStartupLocation = "CenterScreen"
    Width = "800" Height = "600" ShowInTaskbar = "True" Background = "lightgray">    
        <Canvas x:Name="Canvas">
            <Button x:Name = "Button1" Height = "75" Width = "150" Content = 'Change Label Colors' ToolTip = "Button1"
                Background="Red" Canvas.Left = '150' Canvas.Top = '50'/>
            <Button x:Name = "Button2" Height = "75" Width = "150" Content = 'Rotate Label' ToolTip = "Button2"
                Background="Red" Canvas.Right = '150' Canvas.Top = '50'/>                
            <Label x:Name = "label1" Height = "75" Width = "300" Content = 'Label1' ToolTip = "label1"
                Background="Red" Canvas.Left = '250' Canvas.Bottom = '200'/>                               
        </Canvas>
</Window>
"@

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )
$script:i = 1
#Connect to Control
$button1 = $Window.FindName("Button1")
$button2 = $Window.FindName("Button2")
$label1 = $Window.FindName("label1")
$Canvas = $Window.FindName("Canvas")

#You can change the font to any style, similiar to what was done previously with other examples
$label1.FontSize = "16"
$label1.FontWeight = "Bold"
$label1.FontFamily = "Consolas"
$Script:Label = $label1.Content

$button1.Add_Click({    
    $backgroundColor = (Get-Random -InputObject @("red","black","blue","yellow","green"))
    $foregroundColor = (Get-Random -InputObject @("red","black","blue","yellow","green"))
    $label1.background = $backgroundColor
    $label1.Foreground = $foregroundColor
    $label1.Content = ("Changed foreground color to {0} `rand background color to {1}" -f $foregroundColor,$backgroundColor)
    $Script:Label = $label1.Content
})
$button2.Add_Click({
    <#
        Define the Rotate object and supply the Angle, X position and Y position to determine how the angle is applied
        The top left of the label is considered X:0 Y:0
    #>
     Switch ($i) {
       0 {Set-Rotation -Control $label1 -Angle 0 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 360{1}" -f $Label,[char]176)}
       1 {Set-Rotation -Control $label1 -Angle 45 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 45{1}" -f $Label,[char]176)}
       2 {Set-Rotation -Control $label1 -Angle 90 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 90{1}" -f $Label,[char]176)}
       3 {Set-Rotation -Control $label1 -Angle 135 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 135{1}" -f $Label,[char]176)}       
       4 {Set-Rotation -Control $label1 -Angle 180 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 180{1}" -f $Label,[char]176)}  
       5 {Set-Rotation -Control $label1 -Angle 225 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 225{1}" -f $Label,[char]176)}
       6 {Set-Rotation -Control $label1 -Angle 270 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 270{1}" -f $Label,[char]176)}
       7 {Set-Rotation -Control $label1 -Angle 315 -X 150 -Y 37;$label1.Content= ("{0}`r`rRotated 315{1}" -f $Label,[char]176)}       
    }
    $Script:i++
    If ($i -eq 8) {$Script:i=-1}
})

$Window.ShowDialog() | Out-Null