<# 
.SYNOPSIS  
This function will take text written between quotes or single quotes and "type" it on the screen. 
.DESCRIPTION  
Invoking a TYPE-THIS -console 'String' or TYPE-THIS -console (GET-CONTENT textfile)
.EXAMPLE  
TYPE-THIS -console 'Jacqi is great at getting us cakes!' and "Jacqi is great at getting us cakes!" will be typed on your screen. 
.EXAMPLE  
TYPE-THIS -console (GET-CONTENT C:\TEXTFILE.txt) 
This imports text from a text file and types it out on your screen. 
#> 

function Type-This() { 
cls
    param([string]$console)
    #get string length
    $length = ($console.Length)
    
#create array loop
    foreach ($x in 0..$length)
        {
            $letter=$console[$x]
            write-host $letter -NoNewline
            start-sleep -Milliseconds (Get-Random 5)
        }
}