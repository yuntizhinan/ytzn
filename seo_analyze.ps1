# SEO Full Analysis Script - READ ONLY
# Run from nodehub168.com directory
Set-Location $PSScriptRoot

# Load CSV produced by seo_audit_scan.ps1
$data = Import-Csv ".\seo_raw_data.csv" -Encoding UTF8

# === ANALYSIS ===

# 1. Find duplicate titles
$titleGroups = $data | Where-Object { $_.title -ne "" -and $_.title -ne "FILE_NOT_FOUND" } | 
    Group-Object -Property title | Where-Object { $_.Count -gt 1 }

# 2. Find duplicate descriptions
$descGroups = $data | Where-Object { $_.desc -ne "" } |
    Group-Object -Property desc | Where-Object { $_.Count -gt 1 }

# 3. Find short descriptions (< 70 chars)
$shortDesc = $data | Where-Object { [int]$_.desc_len -lt 70 -and $_.desc -ne "" }

# 4. Missing descriptions
$missingDesc = $data | Where-Object { $_.desc -eq "" }

# 5. Short titles (< 30 chars)
$shortTitle = $data | Where-Object { [int]$_.title_len -lt 30 -and $_.title -ne "" -and $_.title -ne "FILE_NOT_FOUND" }

# 6. Long titles (> 60 chars)
$longTitle = $data | Where-Object { [int]$_.title_len -gt 60 -and $_.title -ne "FILE_NOT_FOUND" }

# === OUTPUT ===
$out = @()
$out += "# SEO Audit - Duplicate/Short Title & Description Analysis"
$out += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$out += ""

$out += "## A. Duplicate Titles ($($titleGroups.Count) groups)"
foreach ($g in $titleGroups) {
    $out += ""
    $out += "**Title:** $($g.Name)"
    $out += "**Length:** $($g.Name.Length)"
    foreach ($u in $g.Group) {
        $out += "  - $($u.url)"
    }
}

$out += ""
$out += "## B. Duplicate Descriptions ($($descGroups.Count) groups)"
foreach ($g in $descGroups) {
    $out += ""
    $out += "**Desc:** $($g.Name)"
    $out += "**Length:** $($g.Name.Length)"
    foreach ($u in $g.Group) {
        $out += "  - $($u.url)"
    }
}

$out += ""
$out += "## C. Short Descriptions (< 70 chars) - $($shortDesc.Count) pages"
foreach ($r in $shortDesc) {
    $out += "- URL: $($r.url) | len=$($r.desc_len) | desc: $($r.desc)"
}

$out += ""
$out += "## D. Missing Descriptions - $($missingDesc.Count) pages"
foreach ($r in $missingDesc) {
    $out += "- URL: $($r.url)"
}

$out += ""
$out += "## E. Short Titles (< 30 chars) - $($shortTitle.Count) pages"
foreach ($r in $shortTitle) {
    $out += "- URL: $($r.url) | len=$($r.title_len) | title: $($r.title)"
}

$out += ""
$out += "## F. Long Titles (> 60 chars) - $($longTitle.Count) pages"
foreach ($r in $longTitle) {
    $out += "- URL: $($r.url) | len=$($r.title_len) | title: $($r.title)"
}

$out += ""
$out += "## G. Full Data Table"
$out += "| URL | title_len | desc_len | canonical | robots | h1_count | og_title_set | og_desc_set |"
$out += "|-----|-----------|----------|-----------|--------|----------|-------------|------------|"
foreach ($r in $data) {
    $has_og_t = if ($r.og_title -ne "") { "yes" } else { "NO" }
    $has_og_d = if ($r.og_desc -ne "") { "yes" } else { "NO" }
    $canon_ok = if ($r.canonical -ne "") { "yes" } else { "NO" }
    $rob = if ($r.robots -ne "") { $r.robots } else { "(none)" }
    $out += "| $($r.url) | $($r.title_len) | $($r.desc_len) | $canon_ok | $rob | $($r.h1_count) | $has_og_t | $has_og_d |"
}

$out | Out-File -FilePath ".\seo_analysis_raw.md" -Encoding UTF8
Write-Host "Analysis complete. Output: seo_analysis_raw.md"
Write-Host "Duplicate title groups: $($titleGroups.Count)"
Write-Host "Duplicate desc groups: $($descGroups.Count)"
Write-Host "Short desc (<70): $($shortDesc.Count)"
Write-Host "Missing desc: $($missingDesc.Count)"
Write-Host "Short titles (<30): $($shortTitle.Count)"
Write-Host "Long titles (>60): $($longTitle.Count)"
