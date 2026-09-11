$drafts = @('content/drafts/stage5/clash-verge-config.json', 'content/drafts/stage5/clash-verge-import-config.json', 'content/drafts/stage5/clash-verge-node-failed.json')
$html = [IO.File]::ReadAllText('index.html')
$top_part = ''
$bottom_part = ''
if ($html -match '(?s)(.*?<div class="left-column">)') { $top_part = $matches[1] }
if ($html -match '(?s)(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">.*)') { $bottom_part = $matches[1] }

foreach ($draft in $drafts) {
    $draftPath = Resolve-Path $draft
    $json = Get-Content -Raw -Path $draftPath | ConvertFrom-Json
    $title = $json.title + ' - 云梯指南'
    $canonical = 'https://nodehub168.com' + $json.newPath
    $desc = $json.title + '，由云梯指南编辑部为您带来详细解读。'
    $content = $json.content
    if ($content -match '摘要：.*?</strong>(.*?)</p>') { $desc = $matches[1].Trim() }
    
    $custom_top = $top_part -replace '(?s)<title>.*?</title>', ("<title>" + $title + "</title>")
    $custom_top = $custom_top -replace '(?s)<link rel="canonical" href=".*?">', ('<link rel="canonical" href="' + $canonical + '">')
    
    $category = $json.category
    $cat_url = 'https://nodehub168.com/'
    if ($category -match 'Clash' -or $category -match '教程') { $cat_url = 'https://nodehub168.com/tutorials/' }
    elseif ($category -match '网络知识') { $cat_url = 'https://nodehub168.com/knowledge/' }
    elseif ($category -match 'AI') { $cat_url = 'https://nodehub168.com/ai/' }
    elseif ($category -match '机场') { $cat_url = 'https://nodehub168.com/reviews/' }
    elseif ($category -match '问题解决') { $cat_url = 'https://nodehub168.com/help/' }
    
    $og_tags = '<meta name="description" content="' + $desc + '">' + "`n" + '<meta property="og:title" content="' + $json.title + '" />' + "`n" + '<meta property="og:description" content="' + $desc + '" />' + "`n" + '<meta property="og:type" content="article" />' + "`n" + '<meta property="og:url" content="' + $canonical + '" />' + "`n" + '<meta property="og:site_name" content="云梯指南" />' + "`n" + '<meta name="robots" content="index, follow">'
    
    $custom_top = $custom_top.Replace('</head>', $og_tags + "`n</head>")
    $content_str = $content.Replace('<img ', '<img loading="lazy" ')
    
    $article_html = '<article class="post-article" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">' + "`n" + '<div class="breadcrumb" style="margin-bottom: 16px; font-size: 0.9rem; color: var(--text-muted);">' + "`n" + '<a href="/">首页</a> &gt; <a href="' + $cat_url + '">' + $category + '</a> &gt; <span style="color: var(--accent-cyan); font-weight: 500;">' + $json.title + '</span>' + "`n" + '</div>' + "`n" + '<h1 id="article-title-main" style="font-size: 2.5rem; line-height: 1.3; margin-bottom: 24px; color: var(--text-main);">' + "`n" + $json.title + "`n" + '</h1>' + "`n" + '<div class="article-meta" style="display: flex; flex-wrap: wrap; gap: 1rem 1.5rem; margin-bottom: 24px; color: var(--text-muted); font-size: 0.9rem;">' + "`n" + '<span>作者: ' + $json.author + '</span>' + "`n" + '<span>更新于: ' + $json.date + '</span>' + "`n" + '</div>' + "`n" + $content_str + "`n" + '</article>'
    
    $final_html = $custom_top + "`n" + $article_html + "`n</div><!-- End Left Column -->`n" + $bottom_part
    
    $path = '.' + $json.newPath
    [IO.File]::WriteAllText($path, $final_html)
    Write-Host "Fixed $path"
}
