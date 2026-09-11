$ErrorActionPreference = "Stop"
$targets = Get-Content "fix_targets.json" -Raw | ConvertFrom-Json

$template = [System.IO.File]::ReadAllText("tutorials/clash-verge-guide.html", [System.Text.Encoding]::UTF8)

foreach ($t in $targets) {
    $jsonData = Get-Content $t.json -Raw | ConvertFrom-Json
    $content = $jsonData.content
    
    # Remove h1 from content
    $content = $content -replace '(?s)<h1.*?>.*?</h1>\s*', ''
    
    # fallback values for author and date, extracting from json if present
    # Cloud guide editor / 2026-09-08
    $author = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("5LqR5qKv5oyH5Y2X57yW6L+R6YOo"))
    if ($jsonData.author) {
        $author = $jsonData.author
    }
    
    $date = "2026-09-08"
    if ($jsonData.date) {
        $date = $jsonData.date
    }
    
    $html = $template
    
    $guideSuffix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("IC0g5LqR5qKv5oyH5Y2X"))
    
    # Replace title tags
    $html = $html -replace '(?s)<title>.*?</title>', ("<title>" + $t.title + $guideSuffix + "</title>")
    
    # Replace h1
    $html = $html -replace '(?s)(<h1 id="article-title-main".*?>).*?(</h1>)', ("`$1`n    " + $t.title + "`n  `$2")
    
    # Replace breadcrumb
    $html = $html -replace '(?s)(<span style="color: var\(--accent-cyan\); font-weight: 500;">).*?(</span>)', ("`$1" + $t.title + "`$2")
    
    # Replace author and date
    $authorPrefix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("PHNwYW4+5L2c6ICFOi "))
    $html = $html -replace '(?s)(<span>\u4f5c\u8005: ).*?(</span>)', ($authorPrefix + $author + "</span>")
    
    $updatePrefix = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("PHNwYW4+5pu05paw5LqOOi "))
    $html = $html -replace '(?s)(<span>\u66f4\u65b0\u4e8e: ).*?(</span>)', ($updatePrefix + $date + "</span>")
    
    # Replace og:title
    $html = $html -replace '(?s)(<meta property="og:title" content=").*?(">)', ("`$1" + $t.title + $guideSuffix + "`$2")
    
    # Replace body
    $metaEndIdx = $html.IndexOf("</div>", $html.IndexOf('<div class="article-meta"'))
    $relatedStartIdx = $html.IndexOf("<div class='related-articles'>")
    
    if ($metaEndIdx -gt 0 -and $relatedStartIdx -gt $metaEndIdx) {
        $metaEndIdx += 6
        $html = $html.Substring(0, $metaEndIdx) + "`n" + $content + "`n  " + $html.Substring($relatedStartIdx)
    }
    
    [System.IO.File]::WriteAllText($t.html, $html, [System.Text.Encoding]::UTF8)
    Write-Output "Fixed $($t.html)"
}
