$urls = @(
    "https://nodehub168.com/tutorials/clash-verge-guide.html",
    "https://nodehub168.com/tutorials/clash-verge-download.html",
    "https://nodehub168.com/knowledge/what-is-dns.html",
    "https://nodehub168.com/knowledge/vpn-vs-proxy.html",
    "https://nodehub168.com/ai/chatgpt-guide.html"
)

$results = @()
$titles = @()
$descriptions = @()

foreach ($url in $urls) {
    Write-Host "Fetching $url ..."
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -MaximumRedirection 0 -ErrorAction Stop
        $status = $response.StatusCode
        $html = $response.Content
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        if ($null -eq $status) { $status = "Error" }
        $html = ""
        Write-Host "Error fetching $url"
    }

    $title = ""
    $titleCount = 0
    if ($html -match '(?s)<title>(.*?)</title>') { 
        $title = $matches[1].Trim() 
        $titleCount = ([regex]::Matches($html, '(?s)<title>')).Count
    }
    
    $desc = ""
    $descCount = 0
    if ($html -match '(?s)<meta name="description" content="(.*?)">') {
        $desc = $matches[1].Trim()
        $descCount = ([regex]::Matches($html, '(?s)<meta name="description"')).Count
    }

    $canonical = ""
    if ($html -match '(?s)<link rel="canonical" href="(.*?)">') {
        $canonical = $matches[1].Trim()
    }

    $h1s = [regex]::Matches($html, '(?s)<h1.*?>(.*?)</h1>')
    $h1Count = $h1s.Count
    $h1Content = if ($h1Count -gt 0) { $h1s[0].Groups[1].Value.Trim() } else { "" }

    $robots = ""
    if ($html -match '(?s)<meta name="robots" content="(.*?)">') { $robots = $matches[1].Trim() }

    $ogCount = ([regex]::Matches($html, 'property="og:')).Count

    $hasArticleSchema = $html -match '"@type":\s*"Article"'
    $hasBreadcrumbSchema = $html -match '"@type":\s*"BreadcrumbList"'
    
    $hasOrgAuthor = $html -match '"@type":\s*"Organization"'
    
    $doubleLazy = $html -match 'loading="lazy".*?loading="lazy"'

    $localPaths = $html -match 'C:\\|D:\\|/home/|/Users/'

    $headCount = ([regex]::Matches($html, '<head>')).Count
    $bodyCount = ([regex]::Matches($html, '<body>')).Count

    $res = [PSCustomObject]@{
        URL = $url
        Status = $status
        Title = $title
        TitleLength = $title.Length
        TitleCount = $titleCount
        Desc = $desc
        DescLength = $desc.Length
        DescCount = $descCount
        Canonical = $canonical
        H1Count = $h1Count
        H1 = $h1Content
        Robots = $robots
        OGCount = $ogCount
        ArticleSchema = $hasArticleSchema
        BreadcrumbSchema = $hasBreadcrumbSchema
        DoubleLazy = $doubleLazy
        LocalPaths = $localPaths
        HeadCount = $headCount
        BodyCount = $bodyCount
    }
    $results += $res
}

Write-Host "
--- FINAL RESULTS ---"
$results | Format-List
