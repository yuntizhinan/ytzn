$allArticles = Get-Content 'full_articles_parsed.json' -Raw -Encoding UTF8 | ConvertFrom-Json

$html = Get-Content 'index.html' -Raw -Encoding UTF8
$topMatch = [regex]::Match($html, '(?s)(.*?<div class="left-column">)')
$topPart = $topMatch.Groups[1].Value
$bottomMatch = [regex]::Match($html, '(?s)(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">.*)')
$bottomPart = $bottomMatch.Groups[1].Value

foreach ($a in $allArticles) {
    $title = $a.title + " - 浜戞鎸囧崡"
    $canonical = "https://nodehub168.com" + $a.newPath
    $desc = $a.title + "锛岀敱浜戞鎸囧崡缂栬緫閮ㄤ负鎮ㄥ甫鏉ヨ缁嗚В璇汇€?
    if ($a.content -match '鎽樿锛?*?</strong>(.*?)</p>') {
        $desc = $matches[1].Trim()
    }
    
    $customTop = $topPart -replace '(?s)<title>.*?</title>', ("<title>" + $title + "</title>")
    $customTop = $customTop -replace '(?s)<link rel="canonical" href=".*?">', ("<link rel=`"canonical`" href=`"" + $canonical + "`">")
    
    $catUrl = "https://nodehub168.com/"
    if ($a.category -match "Clash") { $catUrl = "https://nodehub168.com/tutorials/" }
    elseif ($a.category -match "缃戠粶鐭ヨ瘑") { $catUrl = "https://nodehub168.com/knowledge/" }
    elseif ($a.category -match "AI") { $catUrl = "https://nodehub168.com/ai/" }
    elseif ($a.category -match "鏈哄満") { $catUrl = "https://nodehub168.com/reviews/" }
    elseif ($a.category -match "鏁欑▼") { $catUrl = "https://nodehub168.com/tutorials/" }
    elseif ($a.category -match "闂瑙ｅ喅") { $catUrl = "https://nodehub168.com/help/" }

    $schemaArticleObj = @{
        "@context" = "https://schema.org"
        "@type" = "Article"
        "headline" = $a.title
        "description" = $desc
        "datePublished" = ($a.date + "T08:00:00+08:00")
        "dateModified" = ($a.date + "T08:00:00+08:00")
        "author" = @{
            "@type" = "Organization"
            "name" = "浜戞鎸囧崡缂栬緫閮?
        }
    }
    $schemaArticleStr = $schemaArticleObj | ConvertTo-Json -Depth 10 -Compress
    
    $schemaBreadcrumbObj = @{
        "@context" = "https://schema.org"
        "@type" = "BreadcrumbList"
        "itemListElement" = @(
            @{ "@type" = "ListItem"; "position" = 1; "name" = "棣栭〉"; "item" = "https://nodehub168.com/" },
            @{ "@type" = "ListItem"; "position" = 2; "name" = $a.category; "item" = $catUrl },
            @{ "@type" = "ListItem"; "position" = 3; "name" = $a.title; "item" = $canonical }
        )
    }
    $schemaBreadcrumbStr = $schemaBreadcrumbObj | ConvertTo-Json -Depth 10 -Compress

    $ogTags = ""
    $ogTags += "<meta name=`"description`" content=`"" + $desc + "`">`n"
    $ogTags += "<meta property=`"og:title`" content=`"" + $a.title + "`" />`n"
    $ogTags += "<meta property=`"og:description`" content=`"" + $desc + "`" />`n"
    $ogTags += "<meta property=`"og:type`" content=`"article`" />`n"
    $ogTags += "<meta property=`"og:url`" content=`"" + $canonical + "`" />`n"
    $ogTags += "<meta property=`"og:site_name`" content=`"浜戞鎸囧崡`" />`n"
    $ogTags += "<meta name=`"robots`" content=`"index, follow`">`n"
    $ogTags += "<script type=`"application/ld+json`">`n" + $schemaArticleStr + "`n</script>`n"
    $ogTags += "<script type=`"application/ld+json`">`n" + $schemaBreadcrumbStr + "`n</script>"

    $customTop = $customTop -replace '</head>', ($ogTags + "`n</head>")

    $relatedArticlesHtml = "<div class='related-articles'><h3>鐩稿叧闃呰</h3><ul>"
    $relatedCount = 0
    foreach ($ra in $allArticles) {
        if ($ra.slug -ne $a.slug -and $ra.category -eq $a.category) {
            $relatedArticlesHtml += "<li><a href='" + $ra.newPath + "'>" + $ra.title + "</a></li>"
            $relatedCount++
        }
        if ($relatedCount -ge 5) { break }
    }
    $relatedArticlesHtml += "</ul></div>"

    $contentStr = $a.content -replace '<img\b', '<img loading="lazy"'
    
    $articleHtml = "<article class=`"post-article`" style=`"background: white; padding: 24px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);`">`n"
    $articleHtml += "  <div class=`"breadcrumb`" style=`"margin-bottom: 16px; font-size: 0.9rem; color: var(--text-muted);`">`n"
    $articleHtml += "    <a href=`"/`">棣栭〉</a> &gt; <a href=`"" + $catUrl + "`">" + $a.category + "</a> &gt; <span style=`"color: var(--accent-cyan); font-weight: 500;`">" + $a.title + "</span>`n"
    $articleHtml += "  </div>`n"
    $articleHtml += "  <h1 id=`"article-title-main`" style=`"font-size: 2.5rem; line-height: 1.3; margin-bottom: 24px; color: var(--text-main);`">`n"
    $articleHtml += "    " + $a.title + "`n"
    $articleHtml += "  </h1>`n"
    $articleHtml += "  <div class=`"article-meta`" style=`"display: flex; flex-wrap: wrap; gap: 1rem 1.5rem; margin-bottom: 24px; color: var(--text-muted); font-size: 0.9rem;`">`n"
    $articleHtml += "    <span>浣滆€? " + $a.author + "</span>`n"
    $articleHtml += "    <span>鏇存柊浜? " + $a.date + "</span>`n"
    $articleHtml += "  </div>`n"
    $articleHtml += "  " + $contentStr + "`n"
    $articleHtml += "  " + $relatedArticlesHtml + "`n"
    $articleHtml += "</article>`n"

    $finalHtml = $customTop + "`n" + $articleHtml + "`n</div><!-- End Left Column -->`n" + $bottomPart
    
    Set-Content -Path ("." + $a.newPath) -Value $finalHtml -Encoding UTF8
    Write-Host "Re-Published Schema: $($a.newPath)"
}
