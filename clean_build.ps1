$baseDir = "c:\Users\PC\Desktop\落地页\nodehub168.com"
$template = [System.IO.File]::ReadAllText("$baseDir\post-detail.html")
$drafts = Get-ChildItem -Path "$baseDir\content\drafts\stage5" -Filter "*.json" | ForEach-Object {
    $jsonContent = [System.IO.File]::ReadAllText($_.FullName)
    # Using python-like JSON conversion via .NET
    ConvertFrom-Json $jsonContent
}

foreach ($d in $drafts) {
    $title = $d.title + " - 云梯指南"
    $canonical = "https://nodehub168.com" + $d.newPath
    $desc = "本文由云梯指南编辑部为您带来详细解读。"
    if ($d.content -match '(?si)摘要：.*?</strong>(.*?)<') {
        $desc = $matches[1].Trim()
    }
    
    $html = $template
    $html = $html -replace '(?s)<title>.*?</title>', ('<title>' + $title + '</title>')
    $html = $html -replace '(?s)<link rel="canonical" href=".*?">', ('<link rel="canonical" href="' + $canonical + '">')
    $html = $html -replace '(?s)<meta name="description" content=".*?">', ('<meta name="description" content="' + $desc + '">')
    
    $html = $html -replace '(?s)<h1 id="article-title-main".*?</h1>', ('<h1 id="article-title-main" style="font-size: 2.5rem; line-height: 1.3;">' + $d.title + '</h1>')
    $html = $html -replace '(?s)<section class="article-body" id="article-body-content">.*?</section>', ('<section class="article-body" id="article-body-content">' + "`n" + $d.content + "`n" + '</section>')
    
    # Also fix relative links in this specific file since we used post-detail.html as template!
    $targets = @("index.html", "reviews.html", "tutorials.html", "apple-id.html", "ranking.html", "knowledge.html", "latest-articles.html", "apple-id-guide.html", "post-detail.html", "share-id.html", "index.css")
    foreach ($t in $targets) {
        $html = $html.Replace('href="' + $t + '"', 'href="/' + $t + '"')
        $html = $html.Replace('href="' + $t + '?', 'href="/' + $t + '?')
        $html = $html.Replace('href="' + $t + '#', 'href="/' + $t + '#')
    }
    $html = $html.Replace('src="assets/logo.png"', 'src="/assets/logo.png"')
    $html = $html.Replace('src="main.js"', 'src="/main.js"')

    $outPath = $baseDir + $d.newPath.Replace('/', '\')
    [System.IO.File]::WriteAllText($outPath, $html)
    Write-Host "Generated $outPath"
}
Write-Host "Done"
