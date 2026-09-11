$ErrorActionPreference = "Stop"

function FixArticle {
    param(
        [string]$HtmlFile,
        [string]$JsonFile,
        [string]$Title
    )
    
    $jsonData = Get-Content $JsonFile -Encoding UTF8 -Raw | ConvertFrom-Json
    $content = $jsonData.content
    $content = $content -replace '(?s)<h1.*?>.*?</h1>\s*', ''
    
    $author = "云梯指南编辑部"
    if ($jsonData.author) { $author = $jsonData.author }
    
    $date = "2026-09-08"
    if ($jsonData.date) { $date = $jsonData.date }
    
    $html = Get-Content "tutorials/clash-verge-guide.html" -Encoding UTF8 -Raw
    
    $html = $html -replace '(?s)<title>.*?</title>', ("<title>" + $Title + " - 云梯指南</title>")
    $html = $html -replace '(?s)(<h1 id="article-title-main".*?>).*?(</h1>)', ("`$1`n    " + $Title + "`n  `$2")
    $html = $html -replace '(?s)(<span style="color: var\(--accent-cyan\); font-weight: 500;">).*?(</span>)', ("`$1" + $Title + "`$2")
    $html = $html -replace '(?s)(<span>作者: ).*?(</span>)', ("`$1" + $author + "`$2")
    $html = $html -replace '(?s)(<span>更新于: ).*?(</span>)', ("`$1" + $date + "`$2")
    $html = $html -replace '(?s)(<meta property="og:title" content=").*?(">)', ("`$1" + $Title + " - 云梯指南`$2")
    
    $metaEndIdx = $html.IndexOf("</div>", $html.IndexOf('<div class="article-meta"'))
    $relatedStartIdx = $html.IndexOf("<div class='related-articles'>")
    
    if ($metaEndIdx -gt 0 -and $relatedStartIdx -gt $metaEndIdx) {
        $metaEndIdx += 6
        $html = $html.Substring(0, $metaEndIdx) + "`n" + $content + "`n  " + $html.Substring($relatedStartIdx)
    }
    
    # Save as UTF-8 without BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding($False)
    [System.IO.File]::WriteAllText($HtmlFile, $html, $utf8NoBom)
    Write-Output "Fixed $HtmlFile"
}

FixArticle "tutorials/clash-verge-config.html" "content/drafts/stage5/clash-verge-config.json" "Clash Verge 配置教程：系统代理、规则与故障排除"
FixArticle "tutorials/clash-verge-import-config.html" "content/drafts/stage5/clash-verge-import-config.json" "Clash Verge 导入配置教程：如何添加和使用代理配置"
FixArticle "help/clash-verge-node-failed.html" "content/drafts/stage5/clash-verge-node-failed.json" "Clash Verge 节点连接失败怎么办？常见原因与排查方案"
