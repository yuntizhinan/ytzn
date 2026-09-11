$baseDir = "c:\Users\PC\Desktop\落地页\nodehub168.com"
$files = Get-ChildItem -Path $baseDir -Recurse -Filter "*.html" | Where-Object { $_.FullName -notmatch "\\backup\\" }

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $newContent = $content
    
    # We will find all <a href="..."> inside the file and check if they are dead
    $matches = [regex]::Matches($content, '<a\s+[^>]*href="([^"]+)"')
    foreach ($match in $matches) {
        $fullA = $match.Groups[0].Value
        $href = $match.Groups[1].Value
        
        if ($href -match "^http" -or $href -match "^mailto:" -or $href -match "^#" -or $href -match "^/") { continue }
        
        $pathPart = $href.Split("?")[0].Split("#")[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
        
        $localPath = Join-Path $file.DirectoryName $pathPart
        
        if (-not (Test-Path $localPath)) {
            # Target does not exist relative to this file
            $rootPath = Join-Path $baseDir $pathPart
            if (Test-Path $rootPath) {
                # But it exists in the root! So we change href="xxx" to href="/xxx"
                $newHref = "/" + $href
                $newA = $fullA -replace ('href="' + [regex]::Escape($href) + '"'), ('href="' + $newHref + '"')
                $newContent = $newContent.Replace($fullA, $newA)
            }
        }
    }
    
    # Also replace known assets if they are in subdirectories and missing /
    # For example: src="assets/logo.png" -> src="/assets/logo.png"
    if ($file.DirectoryName -ne $baseDir) {
        $newContent = $newContent -replace 'src="assets/logo\.png"', 'src="/assets/logo.png"'
        $newContent = $newContent -replace 'href="index\.css"', 'href="/index.css"'
        $newContent = $newContent -replace 'src="main\.js"', 'src="/main.js"'
    }

    if ($newContent -cne $content) {
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        Write-Host "Fixed links in $($file.Name)"
    }
}
Write-Host "Done fixing relative links!"
