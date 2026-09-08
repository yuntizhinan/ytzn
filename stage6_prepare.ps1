$articles = Get-Content full_articles_parsed.json -Raw -Encoding UTF8 | ConvertFrom-Json
$drafts = Get-ChildItem -Path content/drafts/stage5 -Filter *.json | ForEach-Object {
    Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
}
foreach ($d in $drafts) {
    $exists = $false
    foreach ($a in $articles) {
        if ($a.slug -eq $d.slug) { $exists = $true; break }
    }
    if (-not $exists) { $articles += $d }
}
$articles | ConvertTo-Json -Depth 5 -Compress | Out-File -FilePath full_articles_parsed.json -Encoding UTF8

$publishedFile = 'content/published.json'
$published = @()
if (Test-Path $publishedFile) {
    $published = Get-Content $publishedFile -Raw -Encoding UTF8 | ConvertFrom-Json
}
foreach ($d in $drafts) {
    $exists = $false
    foreach ($p in $published) {
        if ($p.slug -eq $d.slug) { $exists = $true; break }
    }
    if (-not $exists) {
        $primaryKeyword = $d.title.Split("：")[0]
        $published += [PSCustomObject]@{
            title = $d.title
            slug = $d.slug
            category = $d.category
            url = "https://nodehub168.com" + $d.newPath
            path = $d.newPath
            primary_keyword = $primaryKeyword
            publish_date = $d.date
            status = "published"
        }
    }
}
$published | ConvertTo-Json -Depth 5 -Compress | Out-File -FilePath $publishedFile -Encoding UTF8
