$template = Get-Content 'post-detail.html' -Raw -Encoding UTF8
$drafts = Get-ChildItem -Path content/drafts/stage5 -Filter *.json | ForEach-Object {
    Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
}

foreach ($d in $drafts) {
    $title = $d.title + " - 云梯指南"
    $canonical = "https://nodehub168.com" + $d.newPath
    $desc = "本文由云梯指南编辑部为您带来详细解读。"
    if ($d.content -match '(?si)摘要：.*?</strong>(.*?)</p>') {
        $desc = $matches[1].Trim()
    }
    
    $html = $template
    $html = $html -replace '(?s)<title>.*?</title>', "<title>$title</title>"
    $html = $html -replace '(?s)<link rel="canonical" href=".*?">', "<link rel=`"canonical`" href=`"$canonical`">"
    $html = $html -replace '(?s)<meta name="description" content=".*?">', "<meta name=`"description`" content=`"$desc`">"
    
    $og = "<meta property=`"og:title`" content=`"$title`">`n" +
          "<meta property=`"og:description`" content=`"$desc`">`n" +
          "<meta property=`"og:type`" content=`"article`">`n" +
          "<meta property=`"og:url`" content=`"$canonical`">`n" +
          "<meta property=`"og:site_name`" content=`"云梯指南`">"
          
    $html = $html -replace '(?s)</head>', ("`n" + $og + "`n</head>")
    
    $catUrl = "https://nodehub168.com/"
    if ($d.category -match "Clash") { $catUrl = "https://nodehub168.com/tutorials.html" }
    elseif ($d.category -match "知识") { $catUrl = "https://nodehub168.com/knowledge.html" }
    elseif ($d.category -match "问题解决") { $catUrl = "https://nodehub168.com/knowledge.html" }

    $schemaObj = @{
        "@context" = "https://schema.org"
        "@type" = "Article"
        "headline" = $d.title
        "description" = $desc
        "author" = @{
            "@type" = "Organization"
            "name" = "云梯指南编辑部"
        }
        "datePublished" = $d.date + "T08:00:00+08:00"
        "dateModified" = $d.date + "T08:00:00+08:00"
        "mainEntityOfPage" = @{
            "@type" = "WebPage"
            "@id" = $canonical
        }
    }
    
    $breadcrumbObj = @{
        "@context" = "https://schema.org"
        "@type" = "BreadcrumbList"
        "itemListElement" = @(
            @{ "@type" = "ListItem"; "position" = 1; "name" = "首页"; "item" = "https://nodehub168.com/" },
            @{ "@type" = "ListItem"; "position" = 2; "name" = $d.category; "item" = $catUrl },
            @{ "@type" = "ListItem"; "position" = 3; "name" = $d.title; "item" = $canonical }
        )
    }
    
    $schemaJson = $schemaObj | ConvertTo-Json -Depth 5 -Compress
    $breadcrumbJson = $breadcrumbObj | ConvertTo-Json -Depth 5 -Compress
    $schemaHtml = "<script type=`"application/ld+json`">`n" + $schemaJson + "`n</script>`n<script type=`"application/ld+json`">`n" + $breadcrumbJson + "`n</script>"
    
    $html = $html -replace '(?s)</head>', ("`n" + $schemaHtml + "`n</head>")
    
    $html = $html -replace '(?s)<section class="article-body" id="article-body-content">.*?</section>', "<section class=`"article-body`" id=`"article-body-content`">`n$($d.content)`n</section>"    
    
    $catUrlShort = $catUrl.Replace("https://nodehub168.com","")
    $crumbHtml = "<nav class=`"breadcrumb`"><a href=`"/`">首页</a> > <a href=`"$catUrlShort`">$($d.category)</a> > <span>$($d.title)</span></nav>"
    $html = $html -replace '(?s)<nav class="breadcrumb">.*?</nav>', $crumbHtml
    
    $outPath = "c:\Users\PC\Desktop\落地页\nodehub168.com" + $d.newPath.Replace('/', '\')
    $dir = Split-Path $outPath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $html | Out-File -FilePath $outPath -Encoding UTF8
    Write-Host "Generated $outPath"
}
