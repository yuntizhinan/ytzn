$content = Get-Content -Path 'C:\Users\PC\.gemini\antigravity-ide\brain\896f4612-0d71-4af1-801b-e4884a902adf\.system_generated\steps\70\content.md' -Raw -Encoding UTF8
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

Write-Output "Found $($accounts.Count) accounts"

# Update share-id.html
$shareHtml = Get-Content -Path 'share-id.html' -Raw -Encoding UTF8
$newAccountsStr = "const accounts = [" + "`n"
foreach ($acc in $accounts) {
    $newAccountsStr += "        { id: `"$($acc.id)`", pass: `"$($acc.pass)`" },`n"
}
$newAccountsStr = $newAccountsStr.Substring(0, $newAccountsStr.Length - 2) + "`n      ];"
$shareHtml = $shareHtml -replace '(?s)const accounts = \[.*?\];', $newAccountsStr
$shareHtml = $shareHtml -replace '2026年\d{2}月\d{2}日', '2026年08月29日'
$shareHtml = $shareHtml -replace '(?s)<p style="font-size: 2\.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var\(--font-title\);">\d+</p>\s*<p style="font-size: 0\.95rem; color: var\(--text-muted\); text-transform: uppercase; letter-spacing: 1px;">可用账号</p>', "<p style=`"font-size: 2.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var(--font-title);`">$($accounts.Count)</p>`n        <p style=`"font-size: 0.95rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;`">可用账号</p>"
$shareHtml = $shareHtml -replace '(?s)<p style="font-size: 2\.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var\(--font-title\);">\d{2}-\d{2}</p>\s*<p style="font-size: 0\.95rem; color: var\(--text-muted\); text-transform: uppercase; letter-spacing: 1px;">今日更新</p>', "<p style=`"font-size: 2.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var(--font-title);`">08-29</p>`n        <p style=`"font-size: 0.95rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;`">今日更新</p>"
Set-Content -Path 'share-id.html' -Value $shareHtml -Encoding UTF8

# Update apple-id.html
$appleHtml = Get-Content -Path 'apple-id.html' -Raw -Encoding UTF8
$appleHtml = $appleHtml -replace '2026年\d{2}月\d{2}日', '2026年08月29日'
$gridStartStr = '<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">'
$gridStartIdx = $appleHtml.IndexOf($gridStartStr)
if ($gridStartIdx -ge 0) {
    $gridStartIdx += $gridStartStr.Length
    # The end of the grid is before </article> but wait, there might be spacing.
    # Let's search for "</div>`r`n    </article>" or something.
    $gridEndIdx = $appleHtml.IndexOf('</div>', $gridStartIdx)
    # We should search for the exact matching end tag of the grid.
    # Actually, in my previous python script I used: '</div>\n    </article>'
    $gridEndIdx = $appleHtml.IndexOf('    </article>', $gridStartIdx)
    if ($gridEndIdx -ge 0) {
        # The grid closing div is right before the </article> indentation
        # Let's find the </div> just before it
        $gridEndIdx = $appleHtml.LastIndexOf('</div>', $gridEndIdx)
        $newGridHtml = "`n"
        foreach ($acc in $accounts) {
            $newGridHtml += @"
        <div style="padding: 20px; border: 1px solid var(--border-color); border-radius: 8px; background: rgba(0,0,0,0.2); transition: transform 0.3s, box-shadow 0.3s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='var(--glow-shadow)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
            <h4 style="margin: 0; color: var(--text-primary); font-size: 1.1rem;">免费共享账号</h4>
            <span style="font-size: 0.8rem; background: rgba(46, 204, 113, 0.1); color: var(--accent-green); padding: 2px 8px; border-radius: 12px; border: 1px solid rgba(46, 204, 113, 0.2);">可用</span>
          </div>
          <p style="margin-bottom: 12px; font-size: 0.95rem;">
            <strong style="color: var(--text-muted); font-size: 0.85rem; display: block; margin-bottom: 4px;">APPLE ID</strong> 
            <span style="color: var(--text-secondary); font-family: monospace; display: block; background: rgba(255,255,255,0.03); padding: 8px; border-radius: 6px; border: 1px solid var(--border-color); word-break: break-all;">$($acc.id)</span>
          </p>
          <p style="font-size: 0.95rem; margin: 0;">
            <strong style="color: var(--text-muted); font-size: 0.85rem; display: block; margin-bottom: 4px;">密码</strong> 
            <span style="color: var(--text-secondary); font-family: monospace; display: block; background: rgba(255,255,255,0.03); padding: 8px; border-radius: 6px; border: 1px solid var(--border-color); word-break: break-all;">$($acc.pass)</span>
          </p>
        </div>
"@ + "`n"
        }
        $appleHtml = $appleHtml.Substring(0, $gridStartIdx) + $newGridHtml + "      " + $appleHtml.Substring($gridEndIdx)
        Set-Content -Path 'apple-id.html' -Value $appleHtml -Encoding UTF8
    }
}

# Update protocol-selection-2026.html
$protoHtml = Get-Content -Path 'protocol-selection-2026.html' -Raw -Encoding UTF8
$protoHtml = $protoHtml -replace '今日免费美区 Apple ID 共享（2026-\d{2}-\d{2} 实时更新） ⚡</h3>', '今日免费美区 Apple ID 共享（2026-08-29 实时更新） ⚡</h3>'
$protoHtml = $protoHtml -replace '查看完整 \d+ 个实时可用账号密码', "查看完整 $($accounts.Count) 个实时可用账号密码"
$protoHtml = $protoHtml -replace '样例可用账号 1：<code>.*?</code> &nbsp;&nbsp;\|&nbsp;&nbsp; 密码：<code>.*?</code>', "样例可用账号 1：<code>$($accounts[0].id)</code> &nbsp;&nbsp;|&nbsp;&nbsp; 密码：<code>$($accounts[0].pass)</code>"
Set-Content -Path 'protocol-selection-2026.html' -Value $protoHtml -Encoding UTF8
