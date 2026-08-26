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

    $Lines += "$Stock : $($Data.c) USD ($($Data.dp)%)"
}

$Today = Get-Date

$Report = @"
Market Close Report

Generated:
$Today

$($Lines -join "`n")
"@

$Report | Out-File MarketReport.txt

Write-Host $Report
