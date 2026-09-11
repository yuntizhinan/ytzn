$newItems = @"
    {
      "date": "2026-09-08",
      "badge": "系统教程",
      "badge_class": "badge-primary",
      "title": "Clash Verge 配置教程：系统代理、规则与故障排除",
      "link": "/tutorials/clash-verge-config.html",
      "summary": "本文为您提供详细的 Clash Verge 配置教程。重点讲解系统代理、TUN 模式以及规则、Proxies、Rules 和 DNS 的设置与排查常见不通问题。"
    },
    {
      "date": "2026-09-08",
      "badge": "系统教程",
      "badge_class": "badge-primary",
      "title": "Clash Verge 导入配置教程：如何添加和使用代理配置",
      "link": "/tutorials/clash-verge-import-config.html",
      "summary": "本文详细介绍如何在 Clash Verge 中导入订阅链接与本地配置文件。灵活掌握添加、使用和更新代理配置的方法，是保持节点可用性的核心步骤，也是解决部分节点连接错误的基础。"
    },
    {
      "date": "2026-09-08",
      "badge": "故障排查",
      "badge_class": "badge-secondary",
      "title": "Clash Verge 节点连接失败怎么办？常见原因与排查方案",
      "link": "/help/clash-verge-node-failed.html",
      "summary": "本文为你提供系统性的 Clash Verge 节点失败（Timeout）排查指南。从基础检查、系统冲突到日志排查，一步步教你定位并解决节点连不上的瓶颈。"
    },
"@

$content = [IO.File]::ReadAllText(".\articles.json", [System.Text.Encoding]::UTF8)
$content = $content -replace '"articles": \[', "`"articles`": [`n$newItems"
$content = $content -replace '"link": "post-detail\.html\?id=recommend-guide"', '"link": "/posts/recommend-guide.html"'
$content = $content -replace '"link": "protocol-selection-2026\.html"', '"link": "/posts/protocol-selection-2026.html"'

[IO.File]::WriteAllText(".\articles.json", $content, [System.Text.Encoding]::UTF8)

$content2 = [IO.File]::ReadAllText(".\full_articles_parsed.json", [System.Text.Encoding]::UTF8)
$content2 = $content2 -replace '"articles": \[', "`"articles`": [`n$newItems"
$content2 = $content2 -replace '"link": "post-detail\.html\?id=recommend-guide"', '"link": "/posts/recommend-guide.html"'
$content2 = $content2 -replace '"link": "protocol-selection-2026\.html"', '"link": "/posts/protocol-selection-2026.html"'

[IO.File]::WriteAllText(".\full_articles_parsed.json", $content2, [System.Text.Encoding]::UTF8)
