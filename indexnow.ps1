$hostName = "nodehub168.com"
$key = "f3b39707e7b447f59d437ec9b533a1e9" 
$keyLocation = "https://nodehub168.com/$key.txt"

$urlList = @()
$publishedFiles = Get-ChildItem -Path "content/published" -Filter "*.json"
foreach ($pf in $publishedFiles) {
    $data = Get-Content $pf.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $urlList += "https://nodehub168.com$($data.newPath)"
}

$payload = @{
    host = $hostName
    key = $key
    keyLocation = $keyLocation
    urlList = $urlList
} | ConvertTo-Json

Write-Host "Simulating IndexNow Submission to Bing & Yandex (All Published Articles)..."
Write-Host $payload
Write-Host "Status: HTTP 200 OK (Simulated)"
