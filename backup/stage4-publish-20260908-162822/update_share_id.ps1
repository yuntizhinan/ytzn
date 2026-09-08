$base_dir = "."
$apple_id_file = Join-Path $base_dir "apple-id.html"
$share_id_file = Join-Path $base_dir "share-id.html"

$content = [System.IO.File]::ReadAllText($apple_id_file, [System.Text.Encoding]::UTF8)

# Match all the spans with break-all
$regex = [regex]'(?is)break-all;">(.*?)</span>'
$matches = $regex.Matches($content)

$values = @()
foreach ($m in $matches) {
    $values += $m.Groups[1].Value.Trim()
}

$accounts = @()
for ($i = 0; $i -lt $values.Count - 1; $i+=2) {
    $email = $values[$i]
    $pass = $values[$i+1]
    if ($email -like "*@*") {
        $accounts += "{ id: `"$email`", pass: `"$pass`" }"
    }
}

if ($accounts.Count -eq 0) {
    Write-Host "No accounts found in apple-id.html"
    exit 1
}

$js_array = "const accounts = [
        " + ($accounts -join ",`n        ") + "
      ];"

$share_content = [System.IO.File]::ReadAllText($share_id_file, [System.Text.Encoding]::UTF8)

# Replace JS array
$jsRegex = [regex]'(?s)const accounts = \[.*?\];'
$share_content = $jsRegex.Replace($share_content, $js_array)

[System.IO.File]::WriteAllText($share_id_file, $share_content, [System.Text.Encoding]::UTF8)

# Update date in both files
$current_date = (Get-Date).ToString("yyyy年MM月dd日")
$dateRegex = [regex]'(?is)📅 文章每日更新日期：\d{4}年\d{2}月\d{2}日'
$share_content = $dateRegex.Replace($share_content, "📅 文章每日更新日期：$current_date")
$content = $dateRegex.Replace($content, "📅 文章每日更新日期：$current_date")

[System.IO.File]::WriteAllText($share_id_file, $share_content, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($apple_id_file, $content, [System.Text.Encoding]::UTF8)

Write-Host "share-id.html updated successfully with $($accounts.Count) accounts!"
