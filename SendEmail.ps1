cls
$from = "Matt Balzan <sccm@ggc-apps.scot.nhs.uk>"
$to = "Arunava Banerjee <arunava.banerjee@ggc.scot.nhs.uk>"
$subject = "Test POSH Email"
$body = "test email from powershell.....yes, i know....lazy....but useful... ;) matt"
$smtp = "10.3.1.15"
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtp