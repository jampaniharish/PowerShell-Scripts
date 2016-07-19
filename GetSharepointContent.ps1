# grab content from web page and parse it
# M.Balzan 27.05.2016
$URI = "http://teams.staffnet.ggc.scot.nhs.uk/teams/CorpSvc/HIT/ITInfra/Ops/TechSvc/AP/Lists/Packaging%20Numbers%20Assignment/RSS.aspx"
$html = Invoke-WebRequest -Uri $URI -UseDefaultCredentials -ErrorAction SilentlyContinue
#$html.ParsedHtml | get-member
($html.ParsedHtml.getElementsByTagName("td") | Where {$_.className -eq ‘ms-vb2’} ).innerText | Select-string -Pattern "pkg"
