$base_dir = "c:\Users\PC\Desktop\落地页\nodehub168.com"
$files = @("latest-articles.html", "index.html")

foreach ($file in $files) {
    Write-Host "`nChecking links in $file..."
    $content = [System.IO.File]::ReadAllText(Join-Path $base_dir $file, [System.Text.Encoding]::UTF8)
    
    # regex match for href
    $regex = [regex]'<h3 class="review-title"><a href="([^"]+)">([^<]+)</a></h3>'
    $matches = $regex.Matches($content)
    
    foreach ($m in $matches) {
        $href = $m.Groups[1].Value
        $title = $m.Groups[2].Value
        
        $pathPart = $href -split "\?" | Select-Object -First 1
        $localPath = Join-Path $base_dir ($pathPart -replace "/", "\")
        
        if (Test-Path $localPath) {
            Write-Host "[OK] $href - $title"
        } else {
            Write-Host "[MISSING] $href - $title"
        }
    }
}
