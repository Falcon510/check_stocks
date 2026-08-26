$ApiKey = $env:FINNHUB_API_KEY

$Stocks = @(
    "LRCX",
    "AAPL",
    "MSFT",
    "NVDA",
    "SPCX",
    "INTC",
    "TSM",
    "MU",
    "SNDK",
    "SKHY",
    "AMD",
    "GOOG",
    "TSLA",
    "QQQM",
    "VCX"
)

$Lines = @()

foreach ($Stock in $Stocks)
{
    $Uri = "https://finnhub.io/api/v1/quote?symbol=$Stock&token=$ApiKey"

    $Data = Invoke-RestMethod -Uri $Uri

    $Lines += "$Stock : $($Data.c) ($($Data.dp)%)"
}
<#
$Today = Get-Date

$Report = @"

Market Close Report

Generated:
$Today
#>

$($Lines -join "`n")
"@

$Report | Out-File MarketReport.txt


$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587

$Username = $env:SMTP_USERNAME
$Password = $env:SMTP_PASSWORD

$SecurePassword = ConvertTo-SecureString `
    $Password `
    -AsPlainText `
    -Force

$Credential = New-Object `
    System.Management.Automation.PSCredential `
    ($Username, $SecurePassword)

Send-MailMessage `
    -From $Username `
    -To $env:SMS_TO `
    -Subject "Stocks update" `
    -Body $Report `
    -SmtpServer $SMTPServer `
    -Port $SMTPPort `
    -UseSsl `
    -Credential $Credential

Write-Host $Report
