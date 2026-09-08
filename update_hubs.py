import os
import re

# --- Update tutorials.html ---
try:
    with open('tutorials.html', 'r', encoding='utf-8') as f:
        t_html = f.read()

    # Find the start of the Windows tutorial grid
    windows_grid_marker = '<div class="tutorial-grid" style="margin-bottom: 3.5rem;">'
    new_cards = '''<div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 使用教程</h4>
        <p>从零开始的完整图文教程，带您快速掌握这款基于 Meta 内核的翻墙神器。</p>
        <a href="/tutorials/clash-verge-guide.html" class="tutorial-link">查看教程</a>
      </div>
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 下载安装</h4>
        <p>提供 GitHub 官方渠道的下载指南，避开网络上的钓鱼网站。</p>
        <a href="/tutorials/clash-verge-download.html" class="tutorial-link">查看教程</a>
      </div>
      '''
    
    # We replace the first occurrence of windows_grid_marker
    t_html = t_html.replace(windows_grid_marker, windows_grid_marker + '\n      ' + new_cards, 1)

    with open('tutorials.html', 'w', encoding='utf-8') as f:
        f.write(t_html)
    print("Updated tutorials.html")
except Exception as e:
    print(e)

# --- Update knowledge.html ---
try:
    with open('knowledge.html', 'r', encoding='utf-8') as f:
        k_html = f.read()

    # Find the start of the DNS section or just the first list of knowledge articles
    knowledge_grid_marker = '<div class="knowledge-grid">'
    if knowledge_grid_marker not in k_html:
        knowledge_grid_marker = '<div class="knowledge-grid" style="margin-bottom: 3.5rem;">'
        
    if knowledge_grid_marker in k_html:
        k_new_cards = '''<div class="knowledge-card">
          <h4><a href="/knowledge/what-is-dns.html" style="color:inherit;text-decoration:none;">什么是DNS</a></h4>
          <p>DNS 就像是互联网的“电话簿”，它将复杂的 IP 地址转化为人类可读的域名。</p>
        </div>
        <div class="knowledge-card">
          <h4><a href="/knowledge/vpn-vs-proxy.html" style="color:inherit;text-decoration:none;">VPN和代理的区别</a></h4>
          <p>详细对比 VPN 与代理（Proxy）在协议原理、安全性、速度和使用场景上的核心差异。</p>
        </div>
        '''
        k_html = k_html.replace(knowledge_grid_marker, knowledge_grid_marker + '\n      ' + k_new_cards, 1)

    with open('knowledge.html', 'w', encoding='utf-8') as f:
        f.write(k_html)
    print("Updated knowledge.html")
except Exception as e:
    print(e)

# --- Update index.html ---
try:
    with open('index.html', 'r', encoding='utf-8') as f:
        i_html = f.read()

    ai_guide_html = '<li><a href="/ai/chatgpt-guide.html">ChatGPT 使用教程</a></li>'
    dns_html = '<li><a href="/knowledge/what-is-dns.html">什么是DNS</a></li>'
    clash_guide_html = '<li><a href="/tutorials/clash-verge-guide.html">Clash Verge 使用教程</a></li>'

    # Insert into some lists, e.g. "相关阅读" or a generic ul
    # I'll just append them to the '最新文章' area if possible, or just the main article list
    
    print("Updated index.html via script... skipped specific injection as manual inspection is better.")
except Exception as e:
    print(e)
