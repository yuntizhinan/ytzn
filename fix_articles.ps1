$ErrorActionPreference = "Stop"
$targets = @(
    @{
        html = "tutorials/clash-verge-config.html"
        json = "content/drafts/stage5/clash-verge-config.json"
        title = "Clash Verge 配置教程：系统代理、规则与故障排除"
    },
    @{
        html = "tutorials/clash-verge-import-config.html"
        json = "content/drafts/stage5/clash-verge-import-config.json"
        title = "Clash Verge 导入配置教程：如何添加和使用代理配置"
    },
    @{
        html = "help/clash-verge-node-failed.html"
        json = "content/drafts/stage5/clash-verge-node-failed.json"
        title = "Clash Verge 节点连接失败怎么办？常见原因与排查方案"
    }
)

$template = [System.IO.File]::ReadAllText("tutorials/clash-verge-guide.html", [System.Text.Encoding]::UTF8)

foreach ($t in $targets) {
    $jsonData = Get-Content $t.json -Raw | ConvertFrom-Json
    $content = $jsonData.content
    
    # Remove h1 from content
    $content = $content -replace '(?s)<h1.*?>.*?</h1>\s*', ''
    
    $author = "云梯指南编辑部"
    if ($jsonData.author) {
        $author = $jsonData.author
    }
    
    $date = "2026-09-08"
    if ($jsonData.date) {
        $date = $jsonData.date
    }
    
    $html = $template
    
    # Replace title tags
    $html = $html -replace '(?s)<title>.*?</title>', ("<title>" + $t.title + " - 云梯指南</title>")
    
    # Replace h1
    $html = $html -replace '(?s)(<h1 id="article-title-main".*?>).*?(</h1>)', ("`$1`n    " + $t.title + "`n  `$2")
    
    # Replace breadcrumb
    $html = $html -replace '(?s)(<span style="color: var\(--accent-cyan\); font-weight: 500;">).*?(</span>)', ("`$1" + $t.title + "`$2")
    
    # Replace author and date
    $html = $html -replace '(?s)(<span>作者: ).*?(</span>)', ("`$1" + $author + "`$2")
    $html = $html -replace '(?s)(<span>更新于: ).*?(</span>)', ("`$1" + $date + "`$2")
    
    # Replace og:title
    $html = $html -replace '(?s)(<meta property="og:title" content=").*?(">)', ("`$1" + $t.title + " - 云梯指南`$2")
    
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
