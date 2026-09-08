$drafts = Get-ChildItem -Path 'content/drafts' -Filter '*.json'
$errors = @()

foreach ($draft in $drafts) {
    $data = Get-Content $draft.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $content = $data.content
    
    if ($content.Length -lt 500) { $errors += "$($draft.Name): Word count < 500" }
    
    $h2Count = ([regex]::Matches($content, '(?i)<h2>')).Count
    if ($h2Count -lt 2) { $errors += "$($draft.Name): H2 count < 2" }
    
    $linkCount = ([regex]::Matches($content, '(?i)<a\s+href=')).Count
    if ($linkCount -lt 1) { $errors += "$($draft.Name): No links found" }
    
    if ($content -notmatch '摘要') { $errors += "$($draft.Name): No abstract found" }
    if ($content -notmatch '最后更新') { $errors += "$($draft.Name): No update time found" }
}

if ($errors.Count -gt 0) {
    Write-Host "CONTENT AUDIT FAILED:"
    $errors | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "CONTENT AUDIT PASSED"
}
