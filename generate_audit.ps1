$files = Get-ChildItem -Path . -Filter *.html -Recurse -Exclude backup, .agents, .git
$results = @()
$txtOutput = ""

foreach ($file in $files) {
    if ($file.FullName -match "\\backup\\") { continue }
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    $title = if ($content -match '(?i)<title>(.*?)</title>') { $matches[1].Trim() } else { "" }
    $desc = if ($content -match '(?i)<meta\s+name=["'']description["'']\s+content=["''](.*?)["'']') { $matches[1].Trim() } else { "" }
    $canonical = if ($content -match '(?i)<link\s+rel=["'']canonical["'']\s+href=["''](.*?)["'']') { $matches[1].Trim() } else { "" }
    $h1Count = ([regex]::Matches($content, '(?i)<h1.*?>')).Count
    $noindex = if ($content -match '(?i)noindex') { $true } else { $false }
    $exampleCom = if ($content -match 'example\.com') { $true } else { $false }
    
    $results += [PSCustomObject]@{
        File = $file.Name
        Path = $file.FullName.Replace("c:\Users\PC\Desktop\落地页\nodehub168.com\", "")
        Title = $title
        Description = $desc
        Canonical = $canonical
        H1Count = $h1Count
        NoIndex = $noindex
        HasExampleCom = $exampleCom
    }
    
    $txtOutput += "File: " + $file.Name + "
"
    $txtOutput += "Title: " + $title + "
"
    $txtOutput += "Canonical: " + $canonical + "
"
    $txtOutput += "H1 Count: " + $h1Count + "

"
}

$results | ConvertTo-Json | Set-Content -Path "seo-audit-before-stage2.json" -Encoding UTF8
$txtOutput | Set-Content -Path "seo-audit-before-stage2.txt" -Encoding UTF8
Write-Host "Audit generated."
