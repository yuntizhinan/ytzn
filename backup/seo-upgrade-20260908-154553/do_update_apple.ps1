$appleHtml = Get-Content -Path 'apple-id.html' -Raw -Encoding UTF8
$accounts = Get-Content 'accounts.json' | ConvertFrom-Json

$gridStartStr = '<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">'
$gridStartIdx = $appleHtml.IndexOf($gridStartStr)
if ($gridStartIdx -ge 0) {
    $gridStartIdx += $gridStartStr.Length
    $gridEndIdx = $appleHtml.IndexOf('    </article>', $gridStartIdx)
    $gridEndIdx = $appleHtml.LastIndexOf('</div>', $gridEndIdx)
    
    $gridContent = $appleHtml.Substring($gridStartIdx, $gridEndIdx - $gridStartIdx)
    
    $cardStartStr = '<div style="padding: 20px;'
    $firstCardStart = $gridContent.IndexOf($cardStartStr)
    $secondCardStart = $gridContent.IndexOf($cardStartStr, $firstCardStart + 10)
    
    if ($secondCardStart -lt 0) { $secondCardStart = $gridContent.Length }
    
    $template = $gridContent.Substring($firstCardStart, $secondCardStart - $firstCardStart)
    $template = $template.Replace("quodonnell@gmail.com", "{ID}").Replace("Dd10096da", "{PASS}")
    
    $newGridHtml = "`n      "
    foreach ($acc in $accounts) {
        $newGridHtml += $template.Replace("{ID}", $acc.id).Replace("{PASS}", $acc.pass)
    }
    
    $appleHtml = $appleHtml.Substring(0, $gridStartIdx) + $newGridHtml + "    " + $appleHtml.Substring($gridEndIdx)
    
    $appleHtml = $appleHtml -replace '(?<=2026.)\d{2}(?=.\d{2}.)', '08'
    $appleHtml = $appleHtml -replace '(?<=2026.\d{2}.)\d{2}(?=.)', '26'
    
    [System.IO.File]::WriteAllText("apple-id.html", $appleHtml, [System.Text.Encoding]::UTF8)
    Write-Output "Successfully updated apple-id.html"
} else {
    Write-Output "Could not find grid start"
}
