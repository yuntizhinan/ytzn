$published = Get-Content content/published.json -Raw -Encoding UTF8 | ConvertFrom-Json
$sitemap = Get-Content sitemap.xml -Raw -Encoding UTF8
$allHtml = Get-ChildItem -Path . -Filter *.html -Recurse

Write-Host "==========================="
Write-Host "SEO AUDIT REPORT (STAGE 4)"
Write-Host "==========================="

$failCount = 0

foreach ($p in $published) {
    Write-Host "
CHECKING: $($p.title)"
    $path = ".$($p.url)"
    
    if (-not (Test-Path $path)) {
        Write-Host "FAIL: File not found $path" -ForegroundColor Red
        $failCount++
        continue
    }
    
    $html = Get-Content $path -Raw -Encoding UTF8
    
    # 1. H1
    if ($html -match '(?s)<h1.*?>.*?</h1>') { Write-Host "PASS: H1 exists" -ForegroundColor Green }
    else { Write-Host "FAIL: Missing H1" -ForegroundColor Red; $failCount++ }
    
    # 2. Canonical
    if ($html -match '<link rel="canonical" href="https://nodehub168.com(.*?)"') { 
        if ($matches[1] -eq $p.url) { Write-Host "PASS: Canonical correct" -ForegroundColor Green }
        else { Write-Host "FAIL: Canonical wrong $($matches[1])" -ForegroundColor Red; $failCount++ }
    } else { Write-Host "FAIL: Missing Canonical" -ForegroundColor Red; $failCount++ }
    
    # 3. OG Title
    if ($html -match '<meta property="og:title" content=".*?" />') { Write-Host "PASS: OG tags exist" -ForegroundColor Green }
    else { Write-Host "FAIL: Missing OG tags" -ForegroundColor Red; $failCount++ }
    
    # 4. Schema
    if ($html -match '"@type":\s*"Article"') { Write-Host "PASS: Schema Article exists" -ForegroundColor Green }
    else { Write-Host "FAIL: Missing Schema Article" -ForegroundColor Red; $failCount++ }
    
    if ($html -match '"@type":\s*"BreadcrumbList"') { Write-Host "PASS: Schema Breadcrumb exists" -ForegroundColor Green }
    else { Write-Host "FAIL: Missing Schema Breadcrumb" -ForegroundColor Red; $failCount++ }
    
    # 5. Robots
    if ($html -match '<meta name="robots" content="index, follow">') { Write-Host "PASS: Robots index, follow" -ForegroundColor Green }
    else { Write-Host "FAIL: Missing Robots tag" -ForegroundColor Red; $failCount++ }

    # 6. Sitemap
    if ($sitemap -match $p.url) { Write-Host "PASS: Found in Sitemap" -ForegroundColor Green }
    else { Write-Host "FAIL: Not in Sitemap" -ForegroundColor Red; $failCount++ }
}

Write-Host "
==========================="
if ($failCount -eq 0) {
    Write-Host "ALL SEO AUDIT TESTS PASSED" -ForegroundColor Green
} else {
    Write-Host "FAILED TESTS: $failCount" -ForegroundColor Red
}
