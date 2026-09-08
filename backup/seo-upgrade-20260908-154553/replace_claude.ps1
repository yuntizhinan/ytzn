$html_path = "post-detail.html"
$html_content = [System.IO.File]::ReadAllText($html_path, [System.Text.Encoding]::UTF8)

$replacement_path = "claude_replacement.txt"
$replacement_content = [System.IO.File]::ReadAllText($replacement_path, [System.Text.Encoding]::UTF8)

# Find the block from 'claude-ai-jiaocheng-2026': { up to just before 'protocol-selection-2026': {
$regex = [regex]'(?s)''claude-ai-jiaocheng-2026'': \{.*?\},(?=\s*''protocol-selection-2026'': \{)'
$html_content = $regex.Replace($html_content, $replacement_content + ",")

[System.IO.File]::WriteAllText($html_path, $html_content, [System.Text.Encoding]::UTF8)
Write-Host "Replaced successfully."
