$indexHtml = Get-Content 'index.html' -Raw -Encoding UTF8

$footerStart = $indexHtml.IndexOf('<footer class="footer">')
$footerEnd = $indexHtml.IndexOf('</footer>', $footerStart) + 9
$footerHtml = ""
if ($footerStart -ge 0) {
    $footerHtml = "`n" + $indexHtml.Substring($footerStart, $footerEnd - $footerStart)
}

$html = Get-Content 'apple-id.html' -Raw -Encoding UTF8
$prefix = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>外区 Apple ID 共享 | 免费美区账号每日更新</title>
  <link rel="canonical" href="https://nodehub168.com/apple-id.html">
  <link rel="stylesheet" href="index.css">
  <script src="main.js" defer></script>
</head>
<body>
"@

$suffix = $footerHtml + @"
</body>
</html>
"@

$html = $prefix + "`n" + $html + "`n" + $suffix
[System.IO.File]::WriteAllText('apple-id.html', $html, [System.Text.Encoding]::UTF8)
Write-Output "apple-id.html wrapped successfully with head and footer."
