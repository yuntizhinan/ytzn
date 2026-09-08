$files = Get-ChildItem -Filter *.html -Recurse
$data = @()
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw -Encoding UTF8
    $title = if ($content -match '(?i)<title>(.*?)</title>') { $matches[1].Trim() } else { '' }
    $desc = if ($content -match '(?i)<meta name="description" content="(.*?)">') { $matches[1].Trim() } else { '' }
    $data += [PSCustomObject]@{ File=$f.Name; Title=$title; Description=$desc }
}

Write-Output "--- Duplicate Titles ---"
$data | Group-Object Title | Where-Object { $_.Count -gt 1 -and $_.Name -ne '' } | Format-List Count, Name, Group
Write-Output "--- Duplicate Descriptions ---"
$data | Group-Object Description | Where-Object { $_.Count -gt 1 -and $_.Name -ne '' } | Format-List Count, Name, Group
Write-Output "--- Short/Empty Descriptions ( < 50 chars ) ---"
$data | Where-Object { $_.Description.Length -lt 50 } | Format-Table File, Description
