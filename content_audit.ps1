$existing = Get-Content full_articles_parsed.json -Raw -Encoding UTF8 | ConvertFrom-Json
$drafts = Get-ChildItem -Path content/drafts/stage5 -Filter *.json | ForEach-Object {
    Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
}

$results = @()

foreach ($d in $drafts) {
    $title = $d.title
    $content = $d.content
    
    $h1Count = ([regex]::Matches($content, '(?si)<h1.*?>')).Count
    
    $desc = "Missing"
    if ($content -match '(?si)ժҪ.*?</strong>(.*?)</p>') {
        $desc = $matches[1].Trim()
    }
    
    $text = $content -replace '<[^>]+>', ''
    $wordCount = $text.Length
    
    $hasFaq = $text.Contains("FAQ") -or $text.Contains("")
    $hasFake = $text.Contains("example.com") -or $text.Contains("ڼ")
    
    $conflicts = @()
    foreach ($e in $existing) {
        $eTitle = $e.title
        if ($title -match "Clash Verge" -and $eTitle -match "Clash Verge") {
            if ($title -match "" -and $eTitle -match "") {
                $conflicts += "Overlap with existing: $eTitle"
            }
            if ($title -match "ڵ" -and $eTitle -match "ڵ") {
                $conflicts += "Overlap with existing: $eTitle"
            }
            if ($eTitle -match "ʹý̳" -and ($title -match "ʹ" -or $title -match "̳")) {
                $conflicts += "Potential intent overlap with $eTitle"
            }
        }
    }
    
    $results += [PSCustomObject]@{
        Title = $title
        H1Count = $h1Count
        Desc = $desc
        WordCount = $wordCount
        HasFAQ = $hasFaq
        HasFakeData = $hasFake
        Conflicts = ($conflicts -join ", ")
    }
}

$results | ConvertTo-Json -Depth 5 -Compress | Out-File content/audit-results.json -Encoding UTF8
$results | Format-List
