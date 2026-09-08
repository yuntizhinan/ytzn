$indexHtml = Get-Content 'index.html' -Raw -Encoding UTF8

$headerStartStr = '  <!-- FIXED NAVIGATION HEADER -->'
$headerStartIdx = $indexHtml.IndexOf($headerStartStr)
$headerEndStr = '</header>'
$headerEndIdx = $indexHtml.IndexOf($headerEndStr, $headerStartIdx) + $headerEndStr.Length
$fullHeader = $indexHtml.Substring($headerStartIdx, $headerEndIdx - $headerStartIdx)

# Fix share-id.html
$shareHtml = Get-Content 'share-id.html' -Raw -Encoding UTF8
$shareHeaderStart = $shareHtml.IndexOf($headerStartStr)
if ($shareHeaderStart -ge 0) {
    $shareHeaderEnd = $shareHtml.IndexOf($headerEndStr, $shareHeaderStart) + $headerEndStr.Length
    $shareHtml = $shareHtml.Substring(0, $shareHeaderStart) + $fullHeader + $shareHtml.Substring($shareHeaderEnd)
    [System.IO.File]::WriteAllText('share-id.html', $shareHtml, [System.Text.Encoding]::UTF8)
    Write-Output "share-id.html header replaced."
} else {
    Write-Output "Could not find header in share-id.html"
}

# Fix apple-id.html
$appleHtml = Get-Content 'apple-id.html' -Raw -Encoding UTF8
if ($appleHtml.IndexOf($headerStartStr) -lt 0) {
    $mainStart = $appleHtml.IndexOf('<main')
    if ($mainStart -ge 0) {
        $appleHtml = $appleHtml.Substring(0, $mainStart) + $fullHeader + "`n" + $appleHtml.Substring($mainStart)
        [System.IO.File]::WriteAllText('apple-id.html', $appleHtml, [System.Text.Encoding]::UTF8)
        Write-Output "apple-id.html header added."
    } else {
        Write-Output "Could not find <main in apple-id.html"
    }
} else {
    Write-Output "apple-id.html already has the header."
}
