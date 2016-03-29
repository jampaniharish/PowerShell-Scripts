#$a = "matt.balzan@ggc.scot.nhs.uk"

#[string]::Join(' ',($a.ToCharArray()|%{[convert]::ToString([byte]$_,16)}))

"6d 61 74 74 2e 62 61 6c 7a 61 6e 40 67 67 63 2e 73 63 6f 74 2e 6e 68 73 2e 75 6b".Split(“ “) | % {WRITE-HOST –object( [CHAR][BYTE]([CONVERT]::toint16($_,16))) –nonewline}