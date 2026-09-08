import json
import os
import glob
import subprocess

def publish_articles():
    # 1. Update full_articles_parsed.json
    with open('full_articles_parsed.json', 'r', encoding='utf-8') as f:
        articles = json.load(f)
        
    drafts = []
    draft_files = glob.glob('content/drafts/stage5/*.json')
    for df in draft_files:
        with open(df, 'r', encoding='utf-8') as f:
            d = json.load(f)
            # Ensure it is not already in articles
            if not any(a.get('slug') == d.get('slug') for a in articles):
                articles.append(d)
                drafts.append(d)
                
    with open('full_articles_parsed.json', 'w', encoding='utf-8') as f:
        json.dump(articles, f, ensure_ascii=False, indent=2)
        
    print(f"Added {len(drafts)} drafts to full_articles_parsed.json")

    # 2. Add them to published.json
    published_file = 'content/published.json'
    published = []
    if os.path.exists(published_file):
        with open(published_file, 'r', encoding='utf-8') as f:
            published = json.load(f)
            
    for d in drafts:
        pub_entry = {
            "title": d['title'],
            "slug": d['slug'],
            "category": d['category'],
            "url": "https://nodehub168.com" + d['newPath'],
            "path": d['newPath'],
            "primary_keyword": d.get('primary_keyword', d['title'].split('：')[0]),
            "publish_date": d['date'],
            "status": "published"
        }
        if not any(p.get('slug') == d['slug'] for p in published):
            published.append(pub_entry)
            
    with open(published_file, 'w', encoding='utf-8') as f:
        json.dump(published, f, ensure_ascii=False, indent=2)

    # 3. Update Hubs
    # Update tutorials.html for Clash configs
    try:
        with open('tutorials.html', 'r', encoding='utf-8') as f:
            t_html = f.read()
        
        # Inject the new clash tutorials if not present
        if 'clash-verge-config.html' not in t_html:
            marker = '<div class="tutorial-grid"'
            new_cards = '''
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 配置教程</h4>
        <p>系统代理、TUN模式与进阶路由规则设置</p>
        <a href="/tutorials/clash-verge-config.html" class="tutorial-link">查看教程</a>
      </div>
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 导入配置</h4>
        <p>如何添加订阅链接及使用代理配置文件</p>
        <a href="/tutorials/clash-verge-import-config.html" class="tutorial-link">查看教程</a>
      </div>'''
            t_html = t_html.replace(marker, marker + '>' + new_cards, 1)
            with open('tutorials.html', 'w', encoding='utf-8') as f:
                f.write(t_html)
            print("Updated tutorials.html")
    except Exception as e:
        print(f"Error updating tutorials.html: {e}")

    # Update help.html (Assuming it exists, if not index.html)
    # The instruction says "问题解决 Hub", wait, there is no help.html, there is knowledge.html.
    # Let's inject to knowledge.html for "节点连接失败排查".
    try:
        if os.path.exists('help.html'):
            target = 'help.html'
        else:
            target = 'knowledge.html'
            
        with open(target, 'r', encoding='utf-8') as f:
            h_html = f.read()
            
        if 'clash-verge-node-failed.html' not in h_html:
            marker = '<div class="knowledge-grid"'
            if marker not in h_html:
                marker = '<div class="knowledge-grid" style="margin-bottom: 3.5rem;">'
                
            if marker in h_html:
                new_card = '''
        <div class="knowledge-card">
          <h4><a href="/help/clash-verge-node-failed.html" style="color:inherit;text-decoration:none;">Clash 节点失败排查</a></h4>
          <p>Timeout与连接被重置的常见原因分析</p>
        </div>'''
                h_html = h_html.replace(marker, marker + '>' + new_card, 1)
                with open(target, 'w', encoding='utf-8') as f:
                    f.write(h_html)
                print(f"Updated {target}")
    except Exception as e:
        print(f"Error updating {target}: {e}")

if __name__ == "__main__":
    publish_articles()
