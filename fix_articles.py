import json
import re
import os

targets = [
    {
        "html": "tutorials/clash-verge-config.html",
        "json": "content/drafts/stage5/clash-verge-config.json",
        "title": "Clash Verge 配置教程：系统代理、规则与故障排除"
    },
    {
        "html": "tutorials/clash-verge-import-config.html",
        "json": "content/drafts/stage5/clash-verge-import-config.json",
        "title": "Clash Verge 导入配置教程：如何添加和使用代理配置"
    },
    {
        "html": "help/clash-verge-node-failed.html",
        "json": "content/drafts/stage5/clash-verge-node-failed.json",
        "title": "Clash Verge 节点连接失败怎么办？常见原因与排查方案"
    }
]

with open("tutorials/clash-verge-guide.html", "r", encoding="utf-8") as f:
    template = f.read()

for t in targets:
    with open(t["json"], "r", encoding="utf-8") as f:
        data = json.load(f)

    content = data["content"]
    # Remove h1 from content
    content = re.sub(r"<h1.*?>.*?</h1>\n*", "", content, flags=re.DOTALL)

    author = data.get("author", "云梯指南编辑部")
    date = data.get("date", "2026-09-08")

    html = template
    html = re.sub(r"<title>.*?</title>", f"<title>{t['title']} - 云梯指南</title>", html, flags=re.DOTALL)
    html = re.sub(r'<h1 id="article-title-main"(.*?)>.*?</h1>', f'<h1 id="article-title-main"\\1>\n    {t["title"]}\n  </h1>', html, flags=re.DOTALL)
    
    html = re.sub(r'<span style="color: var\(--accent-cyan\); font-weight: 500;">.*?</span>', f'<span style="color: var(--accent-cyan); font-weight: 500;">{t["title"]}</span>', html)
    html = re.sub(r'<span>作者: .*?</span>', f'<span>作者: {author}</span>', html)
    html = re.sub(r'<span>更新于: .*?</span>', f'<span>更新于: {date}</span>', html)
    
    # Update og:title
    html = re.sub(r'<meta property="og:title" content=".*?">', f'<meta property="og:title" content="{t["title"]} - 云梯指南">', html)

    # Replace body
    # Find <div class="article-meta"...>...</div>
    meta_end = re.search(r'<div class="article-meta".*?>.*?</div>', html, flags=re.DOTALL)
    if meta_end:
        start_idx = meta_end.end()
        # Find <div class='related-articles'>
        related_start = re.search(r'<div class=\'related-articles\'>', html, flags=re.DOTALL)
        if related_start:
            end_idx = related_start.start()
            html = html[:start_idx] + "\n" + content + "\n  " + html[end_idx:]

    with open(t["html"], "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Fixed {t['html']}")
