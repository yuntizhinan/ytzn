$filepath = ".\reviews.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$content = [System.IO.File]::ReadAllText($filepath, $utf8NoBom)

$kuaili_pattern = '(?s)\n*\s*<!-- Card 4 -->\s*<div class="review-item" style="width: 100%;">.*?<h3 class="review-title"><a href="post-detail\.html\?id=kuaili">快狸机场深度评测</a></h3>.*?</div>\n'
$edge_pattern = '(?s)(        <!-- Card 3 -->\s*<div class="review-item" style="width: 100%;">.*?<h3 class="review-title"><a href="post-detail\.html\?id=edge">边缘节点深度测评：企业级专线与多入口中转分析</a></h3>.*?</div>\n)'

if ($content -match $kuaili_pattern) {
    $kuaili_block = $matches[0]
    $content = $content -replace $kuaili_pattern, ''
    
    if ($content -match $edge_pattern) {
        $edge_block = $matches[1]
        
        $replacement = $edge_block + "`n        <!-- Card 4 -->`n" + $kuaili_block.Trim() + "`n"
        $content = $content.Replace($edge_block, $replacement)
        
        [System.IO.File]::WriteAllText($filepath, $content, $utf8NoBom)
        Write-Host "Successfully moved Kuaili card."
    } else {
        Write-Host "Edge Node block not found"
    }
} else {
    Write-Host "Kuaili block not found"
}
