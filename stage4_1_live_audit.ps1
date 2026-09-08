$urls = @(
    "https://nodehub168.com/tutorials/clash-verge-guide",
    "https://nodehub168.com/tutorials/clash-verge-download",
    "https://nodehub168.com/knowledge/what-is-dns",
    "https://nodehub168.com/knowledge/vpn-vs-proxy",
    "https://nodehub168.com/ai/chatgpt-guide"
)

$results = @()

foreach ($url in $urls) {
    Write-Host "Fetching $url ..."
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
        $status = $response.StatusCode
        $finalUrl = $response.BaseResponse.ResponseUri.AbsoluteUri
        $html = $response.Content
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        if ($null -eq $status) { $status = "Error" }
        $finalUrl = if ($_.Exception.Response) { $_.Exception.Response.ResponseUri.AbsoluteUri } else { "" }
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
        InitialURL = $url
        FinalURL = $finalUrl
        Status = $status
        Title = $title
        TitleLength = $title.Length
        DescLength = $desc.Length
        Desc = $desc
        Canonical = $canonical
        H1Count = $h1Count
        H1 = $h1Content
        Robots = $robots
        OGCount = $ogCount
        ArticleSchema = $hasArticleSchema
        BreadcrumbSchema = $hasBreadcrumbSchema
        OrgAuthor = $hasOrgAuthor
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
