import json
import os
import re

with open('full_articles_parsed.json', 'r', encoding='utf-8') as f:
    all_articles = json.load(f)

with open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

top_match = re.search(r'(?s)(.*?<div class="left-column">)', html)
top_part = top_match.group(1) if top_match else ''
bottom_match = re.search(r'(?s)(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">.*)', html)
bottom_part = bottom_match.group(1) if bottom_match else ''

for a in all_articles:
    title = a.get('title', '') + ' - 云梯指南'
    canonical = 'https://nodehub168.com' + a.get('newPath', '')
    desc = a.get('title', '') + '，由云梯指南编辑部为您带来详细解读。'
    
    content = a.get('content', '')
    desc_match = re.search(r'摘要：.*?</strong>(.*?)</p>', content)
    if desc_match:
        desc = desc_match.group(1).strip()
        
    custom_top = re.sub(r'(?s)<title>.*?</title>', f'<title>{title}</title>', top_part)
    custom_top = re.sub(r'(?s)<link rel="canonical" href=".*?">', f'<link rel="canonical" href="{canonical}">', custom_top)
    
    category = a.get('category', '')
    cat_url = "https://nodehub168.com/"
    if "Clash" in category or "教程" in category: cat_url = "https://nodehub168.com/tutorials/"
    elif "网络知识" in category: cat_url = "https://nodehub168.com/knowledge/"
    elif "AI" in category: cat_url = "https://nodehub168.com/ai/"
    elif "机场" in category: cat_url = "https://nodehub168.com/reviews/"
    elif "问题解决" in category: cat_url = "https://nodehub168.com/help/"

    schema_article = {
        "@context": "https://schema.org",
        "@type": "Article",
        "headline": a.get('title', ''),
        "description": desc,
        "datePublished": f"{a.get('date', '')}T08:00:00+08:00",
        "dateModified": f"{a.get('date', '')}T08:00:00+08:00",
        "author": {
            "@type": "Person",
            "name": "云梯指南编辑部"
        }
    }
    
    schema_breadcrumb = {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            { "@type": "ListItem", "position": 1, "name": "首页", "item": "https://nodehub168.com/" },
            { "@type": "ListItem", "position": 2, "name": category, "item": cat_url },
            { "@type": "ListItem", "position": 3, "name": a.get('title', ''), "item": canonical }
        ]
    }
    
    og_tags = f"""
<meta name="description" content="{desc}">
<meta property="og:title" content="{a.get('title', '')}" />
<meta property="og:description" content="{desc}" />
<meta property="og:type" content="article" />
<meta property="og:url" content="{canonical}" />
<meta property="og:site_name" content="云梯指南" />
<meta name="robots" content="index, follow">
<script type="application/ld+json">
{json.dumps(schema_article, ensure_ascii=False)}
</script>
<script type="application/ld+json">
{json.dumps(schema_breadcrumb, ensure_ascii=False)}
</script>
"""
    custom_top = custom_top.replace('</head>', f'{og_tags}\n</head>')

    related_count = 0
    related_html = "<div class='related-articles'><h3>相关阅读</h3><ul>"
    for ra in all_articles:
        if ra.get('slug') != a.get('slug') and ra.get('category') == category:
            related_html += f"<li><a href='{ra.get('newPath')}'>{ra.get('title')}</a></li>"
            related_count += 1
        if related_count >= 5:
            break
    related_html += "</ul></div>"

    content_str = content.replace('<img ', '<img loading="lazy" ')
    
    article_html = f"""
<article class="post-article" style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
  <div class="breadcrumb" style="margin-bottom: 16px; font-size: 0.9rem; color: var(--text-muted);">
    <a href="/">首页</a> &gt; <a href="{cat_url}">{category}</a> &gt; <span style="color: var(--accent-cyan); font-weight: 500;">{a.get('title', '')}</span>
  </div>
  <h1 id="article-title-main" style="font-size: 2.5rem; line-height: 1.3; margin-bottom: 24px; color: var(--text-main);">
    {a.get('title', '')}
  </h1>
  <div class="article-meta" style="display: flex; flex-wrap: wrap; gap: 1rem 1.5rem; margin-bottom: 24px; color: var(--text-muted); font-size: 0.9rem;">
    <span>作者: {a.get('author', '')}</span>
    <span>更新于: {a.get('date', '')}</span>
  </div>
  {content_str}
  {related_html}
</article>
"""

    final_html = custom_top + "\n" + article_html + "\n</div><!-- End Left Column -->\n" + bottom_part
    
    path = "." + a.get('newPath', '')
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(final_html)
    print(f"Re-Published Schema: {path}")

print("Python publish complete.")
