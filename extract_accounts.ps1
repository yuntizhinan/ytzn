$content = Get-Content -Path 'C:\Users\PC\.gemini\antigravity-ide\brain\7efafa26-bb9c-4ab3-87c7-9a98831994c4\.system_generated\steps\5\content.md' -Raw -Encoding UTF8
$pattern = 'data-reveal="([^"]+)"'
$matches = [regex]::Matches($content, $pattern)

$accounts = @()
for ($i = 0; $i -lt $matches.Count; $i += 2) {
    if ($i + 1 -lt $matches.Count) {
        $id = $matches[$i].Groups[1].Value
        $pass = $matches[$i+1].Groups[1].Value
        $accounts += @{ id = $id; pass = $pass }
    }
}

$accounts | ConvertTo-Json > accounts.json
