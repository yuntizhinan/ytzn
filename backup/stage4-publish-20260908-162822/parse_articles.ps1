$html = Get-Content 'post-detail.html' -Raw -Encoding UTF8
$start = $html.IndexOf('const articles = {') + 'const articles = {'.Length
$end = $html.LastIndexOf('};')
$jsStr = $html.Substring($start, $end - $start)

$articles = @()
$urlMap = @{}

# Split by the article key pattern, which seems to be         'slug': {
$blocks = $jsStr -split "
\s+'([^']+)': \{"
for ($i = 1; $i -lt $blocks.Length; $i += 2) {
    $slug = $blocks[$i]
    $blockContent = $blocks[$i+1]
    
    # Extract fields using regex
    $title = if ($blockContent -match "title:\s*'([^']*)'") { $matches[1] } else { '' }
    $category = if ($blockContent -match "category:\s*'([^']*)'") { $matches[1] } else { '' }
    $date = if ($blockContent -match "date:\s*'([^']*)'") { $matches[1] } else { '' }
    
    # Extract content using regex matching backticks. In PowerShell double backtick escapes a backtick.
    $content = if ($blockContent -match '(?s)content:\s*`(.*?)`\s*(?:,|})') { $matches[1] } else { '' }
    
    $newPath = ""
    if ($category -match "评测|推荐|指南") { $newPath = "/reviews/$slug.html" }
    elseif ($category -match "教程|配置") { $newPath = "/tutorials/$slug.html" }
    elseif ($category -match "AI|ChatGPT|Claude") { $newPath = "/ai/$slug.html" }
    else { $newPath = "/posts/$slug.html" }
    
    $urlMap["post-detail.html?id=$slug"] = $newPath
    
    $articles += [PSCustomObject]@{
        slug = $slug
        title = $title
        category = $category
        date = $date
        content = $content
        newPath = $newPath
    }
}
$urlMap | ConvertTo-Json | Set-Content 'url-migration-map.json' -Encoding UTF8
$articles | ConvertTo-Json -Depth 10 | Set-Content 'full_articles_parsed.json' -Encoding UTF8
Write-Host "Parsed $($articles.Count) articles."
