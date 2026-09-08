$articles = Get-Content 'full_articles_parsed.json' -Raw -Encoding UTF8 | ConvertFrom-Json

$html = Get-Content 'index.html' -Raw -Encoding UTF8
$topMatch = [regex]::Match($html, '(?s)(.*?<div class="left-column">)')
$topPart = $topMatch.Groups[1].Value
$bottomMatch = [regex]::Match($html, '(?s)(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">.*)')
$bottomPart = $bottomMatch.Groups[1].Value

$dirs = @('reviews', 'tutorials', 'ai', 'posts')
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null }
}

foreach ($a in $articles) {
    $title = $a.title + " - 云梯指南"
    $canonical = "https://nodehub168.com" + $a.newPath
    
    $customTop = $topPart -replace '(?s)<title>.*?</title>', "<title>$title</title>"
    $customTop = $customTop -replace '(?s)<link rel="canonical" href=".*?">', "<link rel=`"canonical`" href=`"$canonical`">"
    
    $ogTags = @"
<meta property="og:title" content="$($a.title)" />
<meta property="og:type" content="article" />
<meta property="og:url" content="$canonical" />
<meta property="og:site_name" content="云梯指南" />
<meta name="robots" content="index, follow">
"@
    $customTop = $customTop -replace '</head>', "$ogTags`n</head>"

    $relatedArticlesHtml = "<div class='related-articles'><h3>相关阅读</h3><ul>"
    $relatedCount = 0
    foreach ($ra in $articles) {
        if ($ra.slug -ne $a.slug -and $ra.category -eq $a.category) {
            $relatedArticlesHtml += "<li><a href='$($ra.newPath)'>$($ra.title)</a></li>"
            $relatedCount++
        }
        if ($relatedCount -ge 5) { break }
    }
    $relatedArticlesHtml += "</ul></div>"

    $articleHtml = @"
<article class="post-article" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
  <div class="breadcrumb" style="margin-bottom: 16px; font-size: 0.9rem; color: var(--text-muted);">
    <a href="/">首页</a> &gt; <span>$($a.category)</span> &gt; <span style="color: var(--accent-cyan); font-weight: 500;">$($a.title)</span>
  </div>
  <h1 id="article-title-main" style="font-size: 2.5rem; line-height: 1.3; margin-bottom: 24px; color: var(--text-main);">
    $($a.title)
  </h1>
  <div class="article-meta" style="display: flex; flex-wrap: wrap; gap: 1rem 1.5rem; margin-bottom: 24px; color: var(--text-muted); font-size: 0.9rem;">
    <span>作者: $($a.author)</span>
    <span>发布于: $($a.date)</span>
  </div>
  $($a.content)
  $relatedArticlesHtml
</article>
"@

    $finalHtml = $customTop + "`n" + $articleHtml + "`n</div><!-- End Left Column -->`n" + $bottomPart
    Set-Content -Path ".$($a.newPath)" -Value $finalHtml -Encoding UTF8
    Write-Host "Generated $($a.newPath)"
}

Write-Host "Done generating articles."
