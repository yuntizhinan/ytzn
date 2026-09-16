# SEO Audit Scan - READ ONLY - uses relative paths
Set-Location $PSScriptRoot

$HTML_FILES = @(
    @{rel="index.html"; url="/"},
    @{rel="apple-id.html"; url="/apple-id.html"},
    @{rel="apple-id-guide.html"; url="/apple-id-guide.html"},
    @{rel="knowledge.html"; url="/knowledge.html"},
    @{rel="latest-articles.html"; url="/latest-articles.html"},
    @{rel="post-detail.html"; url="/post-detail.html"},
    @{rel="protocol-selection-2026.html"; url="/protocol-selection-2026.html"},
    @{rel="ranking.html"; url="/ranking.html"},
    @{rel="reviews.html"; url="/reviews.html"},
    @{rel="share-id.html"; url="/share-id.html"},
    @{rel="tags.html"; url="/tags.html"},
    @{rel="tutorials.html"; url="/tutorials.html"},
    @{rel="temp.html"; url="/temp.html"},
    @{rel="reviews\claude-ai-jiaocheng-2026.html"; url="/reviews/claude-ai-jiaocheng-2026.html"},
    @{rel="reviews\connection-issues.html"; url="/reviews/connection-issues.html"},
    @{rel="reviews\edge.html"; url="/reviews/edge.html"},
    @{rel="reviews\feiniaoyun.html"; url="/reviews/feiniaoyun.html"},
    @{rel="reviews\flybit.html"; url="/reviews/flybit.html"},
    @{rel="reviews\how-to-choose.html"; url="/reviews/how-to-choose.html"},
    @{rel="reviews\jilianyun-2026.html"; url="/reviews/jilianyun-2026.html"},
    @{rel="reviews\jilianyun.html"; url="/reviews/jilianyun.html"},
    @{rel="reviews\kuaili.html"; url="/reviews/kuaili.html"},
    @{rel="reviews\speedworld-2026.html"; url="/reviews/speedworld-2026.html"},
    @{rel="reviews\xsus.html"; url="/reviews/xsus.html"},
    @{rel="reviews\xxyun.html"; url="/reviews/xxyun.html"},
    @{rel="reviews\yiyunti.html"; url="/reviews/yiyunti.html"},
    @{rel="tutorials\cfa-android.html"; url="/tutorials/cfa-android.html"},
    @{rel="tutorials\cfw-win.html"; url="/tutorials/cfw-win.html"},
    @{rel="tutorials\clash-tutorial.html"; url="/tutorials/clash-tutorial.html"},
    @{rel="tutorials\clash-verge-config.html"; url="/tutorials/clash-verge-config.html"},
    @{rel="tutorials\clash-verge-download.html"; url="/tutorials/clash-verge-download.html"},
    @{rel="tutorials\clash-verge-guide.html"; url="/tutorials/clash-verge-guide.html"},
    @{rel="tutorials\clash-verge-import-config.html"; url="/tutorials/clash-verge-import-config.html"},
    @{rel="tutorials\clash-verge-mac.html"; url="/tutorials/clash-verge-mac.html"},
    @{rel="tutorials\clash-verge-win.html"; url="/tutorials/clash-verge-win.html"},
    @{rel="tutorials\clashx-mac.html"; url="/tutorials/clashx-mac.html"},
    @{rel="tutorials\loon-mac.html"; url="/tutorials/loon-mac.html"},
    @{rel="tutorials\singbox-android.html"; url="/tutorials/singbox-android.html"},
    @{rel="tutorials\singbox-win.html"; url="/tutorials/singbox-win.html"},
    @{rel="tutorials\v2rayng-android.html"; url="/tutorials/v2rayng-android.html"},
    @{rel="help\airport-timeout.html"; url="/help/airport-timeout.html"},
    @{rel="help\chatgpt-1020.html"; url="/help/chatgpt-1020.html"},
    @{rel="help\chatgpt-network-error.html"; url="/help/chatgpt-network-error.html"},
    @{rel="help\clash-verge-failed.html"; url="/help/clash-verge-failed.html"},
    @{rel="help\clash-verge-node-failed.html"; url="/help/clash-verge-node-failed.html"},
    @{rel="help\clash-verge-timeout.html"; url="/help/clash-verge-timeout.html"},
    @{rel="help\dns-resolution-failed.html"; url="/help/dns-resolution-failed.html"},
    @{rel="airports\cheap-recommend.html"; url="/airports/cheap-recommend.html"},
    @{rel="airports\what-is-bgp.html"; url="/airports/what-is-bgp.html"},
    @{rel="ai\chatgpt-guide.html"; url="/ai/chatgpt-guide.html"},
    @{rel="knowledge\vpn-vs-proxy.html"; url="/knowledge/vpn-vs-proxy.html"},
    @{rel="knowledge\what-is-dns.html"; url="/knowledge/what-is-dns.html"},
    @{rel="posts\protocol-selection-2026.html"; url="/posts/protocol-selection-2026.html"},
    @{rel="posts\recommend-guide.html"; url="/posts/recommend-guide.html"},
    @{rel="posts\v2ray-tls-reality-protocol.html"; url="/posts/v2ray-tls-reality-protocol.html"},
    @{rel="guides\sing-box-windows.html"; url="/guides/sing-box-windows.html"}
)

$results = @()

foreach ($item in $HTML_FILES) {
    $fpath = ".\$($item.rel)"
    if (-not (Test-Path $fpath)) {
        Write-Host "SKIP (not found): $($item.url)"
        continue
    }

    $html = [System.IO.File]::ReadAllText((Resolve-Path $fpath), [System.Text.Encoding]::UTF8)

    # Title
    $title = ""
    if ($html -match "(?is)<title[^>]*>(.*?)</title>") { $title = $Matches[1].Trim() }

    # Meta description
    $desc = ""
    if ($html -match '(?is)<meta\s+name="description"\s+content="([^"]*)"') { $desc = $Matches[1].Trim() }
    if ($desc -eq "" -and $html -match '(?is)<meta\s+content="([^"]*)"\s+name="description"') { $desc = $Matches[1].Trim() }
    if ($desc -eq "" -and $html -match "(?is)<meta\s+name='description'\s+content='([^']*)'") { $desc = $Matches[1].Trim() }
    if ($desc -eq "" -and $html -match "(?is)<meta\s+content='([^']*)'\s+name='description'") { $desc = $Matches[1].Trim() }
    # Looser match
    if ($desc -eq "" -and $html -match '(?is)<meta[^>]+name="description"[^>]+content="([^"]+)"') { $desc = $Matches[1].Trim() }
    if ($desc -eq "" -and $html -match '(?is)<meta[^>]+content="([^"]+)"[^>]+name="description"') { $desc = $Matches[1].Trim() }

    # Canonical
    $canonical = ""
    if ($html -match '(?is)<link[^>]+rel="canonical"[^>]+href="([^"]+)"') { $canonical = $Matches[1].Trim() }
    if ($canonical -eq "" -and $html -match '(?is)<link[^>]+href="([^"]+)"[^>]+rel="canonical"') { $canonical = $Matches[1].Trim() }

    # Robots
    $robots = ""
    if ($html -match '(?is)<meta[^>]+name="robots"[^>]+content="([^"]+)"') { $robots = $Matches[1].Trim() }
    if ($robots -eq "" -and $html -match '(?is)<meta[^>]+content="([^"]+)"[^>]+name="robots"') { $robots = $Matches[1].Trim() }

    # H1
    $h1_matches = [regex]::Matches($html, "(?is)<h1[^>]*>(.*?)</h1>")
    $h1_list = @()
    foreach ($m in $h1_matches) {
        $h1_raw = $m.Groups[1].Value
        $h1_clean = [regex]::Replace($h1_raw, "<[^>]+>", "").Trim()
        if ($h1_clean -ne "") { $h1_list += $h1_clean }
    }

    # OG title
    $og_title = ""
    if ($html -match '(?is)<meta[^>]+property="og:title"[^>]+content="([^"]+)"') { $og_title = $Matches[1].Trim() }
    if ($og_title -eq "" -and $html -match '(?is)<meta[^>]+content="([^"]+)"[^>]+property="og:title"') { $og_title = $Matches[1].Trim() }

    # OG description
    $og_desc = ""
    if ($html -match '(?is)<meta[^>]+property="og:description"[^>]+content="([^"]+)"') { $og_desc = $Matches[1].Trim() }
    if ($og_desc -eq "" -and $html -match '(?is)<meta[^>]+content="([^"]+)"[^>]+property="og:description"') { $og_desc = $Matches[1].Trim() }

    $results += [PSCustomObject]@{
        url       = $item.url
        file      = $item.rel
        title     = $title
        title_len = $title.Length
        desc      = $desc
        desc_len  = $desc.Length
        canonical = $canonical
        robots    = $robots
        h1_count  = $h1_list.Count
        h1        = ($h1_list -join " | ")
        og_title  = $og_title
        og_desc   = $og_desc
    }
    Write-Host "OK: $($item.url) | title_len=$($title.Length) desc_len=$($desc.Length)"
}

# Export to CSV
$results | Export-Csv -Path ".\seo_raw_data.csv" -NoTypeInformation -Encoding UTF8

Write-Host "`nTotal files scanned: $($results.Count)"
Write-Host "Output: seo_raw_data.csv"
