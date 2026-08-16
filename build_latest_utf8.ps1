$utf8 = [System.Text.Encoding]::UTF8

$indexPath = Join-Path $PWD "index.html"
$jsonPath = Join-Path $PWD "articles.json"
$outPath = Join-Path $PWD "latest-articles.html"

$indexHtml = [System.IO.File]::ReadAllText($indexPath, $utf8)
$jsonText = [System.IO.File]::ReadAllText($jsonPath, $utf8)

$data = $jsonText | ConvertFrom-Json
$articles = $data.articles
$btnText = $data.btn_text
$datePrefix = $data.date_prefix
$headerTitle = $data.header_title
$headerDesc = $data.header_desc

$topMatch = [regex]::Match($indexHtml, '(?s)(.*?<div class="left-column">)')
$topPart = $topMatch.Groups[1].Value

$bottomMatch = [regex]::Match($indexHtml, '(?s)(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">.*)')
$bottomPart = $bottomMatch.Groups[1].Value

$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine('      <section class="section">')
[void]$sb.AppendLine('        <div class="container">')
[void]$sb.AppendLine('          <div class="section-header">')
[void]$sb.AppendLine("            <h2>$headerTitle</h2>")
[void]$sb.AppendLine("            <p>$headerDesc</p>")
[void]$sb.AppendLine('          </div>')
[void]$sb.AppendLine('          <div class="reviews-container">')

foreach ($a in $articles) {
    $b_class = $a.badge_class
    $b_text = $a.badge
    $date = $a.date
    $link = $a.link
    $title = $a.title
    $summary = $a.summary

    [void]$sb.AppendLine('            <div class="review-item" style="width: 100%;">')
    [void]$sb.AppendLine('              <div class="review-info">')
    [void]$sb.AppendLine('                <div class="review-meta">')
    [void]$sb.AppendLine("                  <span class=""badge $b_class"">$b_text</span>")
    [void]$sb.AppendLine("                  <span style=""font-size: 0.85rem; color: var(--text-muted);"">${datePrefix}${date}</span>")
    [void]$sb.AppendLine('                </div>')
    [void]$sb.AppendLine("                <h3 class=""review-title""><a href=""$link"">$title</a></h3>")
    [void]$sb.AppendLine("                <p class=""review-summary"">$summary</p>")
    [void]$sb.AppendLine('              </div>')
    [void]$sb.AppendLine('              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">')
    [void]$sb.AppendLine("                <a href=""$link"" class=""btn btn-outline"" style=""padding: 0.6rem 1.2rem; font-size: 0.85rem;"">$btnText</a>")
    [void]$sb.AppendLine('              </div>')
    [void]$sb.AppendLine('            </div>')
}

[void]$sb.AppendLine('          </div>')
[void]$sb.AppendLine('        </div>')
[void]$sb.AppendLine('      </section>')
[void]$sb.AppendLine('    </div> <!-- End Left Column -->')

$middlePart = $sb.ToString()
$newHtml = $topPart + $middlePart + $bottomPart
$newHtml = $newHtml.Replace('<title>2026 机场推荐与网络工具指南 - 稳定高速的科学上网网络服务推荐</title>', "<title>${headerTitle} - 2026 机场推荐与网络工具指南</title>")

[System.IO.File]::WriteAllText($outPath, $newHtml, $utf8)
Write-Host "Successfully generated latest-articles.html without literal Chinese string parsing in PS script!"
