$bytes = [System.IO.File]::ReadAllBytes('.\post-detail.html')
$utf8 = New-Object System.Text.UTF8Encoding($false)
$content = $utf8.GetString($bytes)
$idx = $content.IndexOf('claude-ai-jiaocheng-2026')
if ($idx -ge 0) { Write-Host 'Title (UTF8):' $content.Substring($idx + 35, 20) }
$idx2 = $content.IndexOf('<title>')
if ($idx2 -ge 0) { Write-Host 'Page Title (UTF8):' $content.Substring($idx2 + 7, 20) }

$gbk = [System.Text.Encoding]::GetEncoding("GBK")
$contentGbk = $gbk.GetString($bytes)
$idxGbk = $contentGbk.IndexOf('claude-ai-jiaocheng-2026')
if ($idxGbk -ge 0) { Write-Host 'Title (GBK):' $contentGbk.Substring($idxGbk + 35, 20) }
$idx2Gbk = $contentGbk.IndexOf('<title>')
if ($idx2Gbk -ge 0) { Write-Host 'Page Title (GBK):' $contentGbk.Substring($idx2Gbk + 7, 20) }
