$base_dir = "."
$latest_path = Join-Path $base_dir "latest-articles.html"
$latest_content = [System.IO.File]::ReadAllText($latest_path, [System.Text.Encoding]::UTF8)
$post_path = Join-Path $base_dir "post-detail.html"
$post_content = [System.IO.File]::ReadAllText($post_path, [System.Text.Encoding]::UTF8)

$regex = [regex]'<h3 class="review-title"><a href="([^"]+)">([^<]+)</a></h3>'
$matches = $regex.Matches($latest_content)

foreach ($m in $matches) {
    $href = $m.Groups[1].Value
    $expected_title = $m.Groups[2].Value.Trim()
    
    if ($href.StartsWith("post-detail.html?id=")) {
        $id = $href.Split("=")[1]
        # regex for JS object
        $js_regex = [regex]("articles\['" + $id + "'\]\s*=\s*\{[^}]*?title:\s*'([^']+)'")
        $js_match = $js_regex.Match($post_content)
        
        if ($js_match.Success) {
            $actual_title = $js_match.Groups[1].Value
            if ($actual_title -eq $expected_title) {
                Write-Host "[OK] $href"
            } else {
                Write-Host "[MISMATCH] $href`n  Expected: $expected_title`n  Actual:   $actual_title"
            }
        } else {
            Write-Host "[NOT FOUND IN POST-DETAIL] $href"
        }
    } else {
        $pathPart = $href -split "\?" | Select-Object -First 1
        $localPath = Join-Path $base_dir ($pathPart -replace "/", "\")
        
        if (Test-Path $localPath) {
            $fileContent = [System.IO.File]::ReadAllText($localPath, [System.Text.Encoding]::UTF8)
            $titleRegex = [regex]'<title>([^<]+)</title>'
            $titleMatch = $titleRegex.Match($fileContent)
            
            if ($titleMatch.Success) {
                $actual_title = $titleMatch.Groups[1].Value.Trim()
                if ($actual_title.Contains($expected_title)) {
                    Write-Host "[OK] $href"
                } else {
                    Write-Host "[MISMATCH] $href`n  Expected: $expected_title`n  Actual:   $actual_title"
                }
            } else {
                Write-Host "[NO TITLE TAG] $href"
            }
        } else {
            Write-Host "[MISSING] $href"
        }
    }
}
