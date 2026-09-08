$files = Get-ChildItem -Path . -Filter *.html -Recurse -Exclude backup, .agents, .git, templates, scratch
$xml = '<?xml version="1.0" encoding="UTF-8"?>' + "
"
$xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + "
"

foreach ($f in $files) {
    if ($f.FullName -match "\\backup\\") { continue }
    
    $relPath = $f.FullName.Replace("c:\Users\PC\Desktop\落地页\nodehub168.com\", "").Replace('\', '/')
    $url = "https://nodehub168.com/$relPath"
    if ($relPath -eq "index.html") { $url = "https://nodehub168.com/" }
    
    $content = Get-Content $f.FullName -Raw -Encoding UTF8
    if ($content -match 'noindex') { continue }
    if ($content -match 'http-equiv="refresh"') { continue }
    
    $xml += "  <url>
    <loc>$url</loc>
  </url>
"
}
$xml += '</urlset>'

Set-Content -Path 'sitemap.xml' -Value $xml -Encoding UTF8
Write-Host "Generated sitemap.xml"
