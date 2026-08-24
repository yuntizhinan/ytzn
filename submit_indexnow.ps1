
# IndexNow 批量提交脚本
# 将网站所有页面提交到 IndexNow API (Bing/Yandex/IndexNow)
# 使用方法: 在网站部署后运行此脚本

$key = "b3fa631b41824faf80150280746ebd2f"
$host = "nodehub168.com"
$keyLocation = "https://nodehub168.com/$key.txt"

$urls = @(
    "https://nodehub168.com/",
    "https://nodehub168.com/index.html",
    "https://nodehub168.com/ranking.html",
    "https://nodehub168.com/reviews.html",
    "https://nodehub168.com/tutorials.html",
    "https://nodehub168.com/knowledge.html",
    "https://nodehub168.com/tags.html",
    "https://nodehub168.com/latest-articles.html",
    "https://nodehub168.com/share-id.html",
    "https://nodehub168.com/apple-id-guide.html",
    "https://nodehub168.com/post-detail.html",
    "https://nodehub168.com/protocol-selection-2026.html",
    "https://nodehub168.com/reviews/connection-issues.html",
    "https://nodehub168.com/reviews/feiniaoyun.html",
    "https://nodehub168.com/reviews/flybit.html",
    "https://nodehub168.com/reviews/jilianyun.html",
    "https://nodehub168.com/reviews/xsus.html",
    "https://nodehub168.com/reviews/xxyun.html",
    "https://nodehub168.com/reviews/yiyunti.html"
)

$body = @{
    host        = $host
    key         = $key
    keyLocation = $keyLocation
    urlList     = $urls
} | ConvertTo-Json -Depth 3

Write-Output "正在提交 $($urls.Count) 个 URL 到 IndexNow API..."

$response = Invoke-RestMethod `
    -Uri "https://api.indexnow.org/IndexNow" `
    -Method POST `
    -ContentType "application/json; charset=utf-8" `
    -Body $body

Write-Output "提交完成！响应状态: $($response.StatusCode)"
Write-Output ""
Write-Output "提交的 URL 列表:"
$urls | ForEach-Object { Write-Output "  - $_" }
Write-Output ""
Write-Output "注意：IndexNow 会自动将 URL 分发到以下搜索引擎:"
Write-Output "  - Microsoft Bing"
Write-Output "  - Yandex"
Write-Output "  - Seznam.cz"
Write-Output "  - Naver (韩国)"
