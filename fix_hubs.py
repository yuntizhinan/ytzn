import os
import re

try:
    with open('tutorials.html', 'r', encoding='utf-8') as f:
        t_html = f.read()

    new_cards_windows = '''
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 使用教程</h4>
        <p>从零开始的完整图文教程，带您快速掌握这款基于 Meta 内核的翻墙神器。</p>
        <a href="tutorials/clash-verge-guide.html" class="tutorial-link">查看教程</a>
      </div>
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 下载安装</h4>
        <p>提供 GitHub 官方渠道的下载指南，避开网络上的钓鱼网站。</p>
        <a href="tutorials/clash-verge-download.html" class="tutorial-link">查看教程</a>
      </div>
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 配置教程</h4>
        <p>系统代理、TUN模式与进阶路由规则设置</p>
        <a href="tutorials/clash-verge-config.html" class="tutorial-link">查看教程</a>
      </div>
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 导入配置</h4>
        <p>如何添加订阅链接及使用代理配置文件</p>
        <a href="tutorials/clash-verge-import-config.html" class="tutorial-link">查看教程</a>
      </div>
    '''
    
    new_cards_macos = '''
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 使用教程</h4>
        <p>从零开始的完整图文教程，带您快速掌握这款基于 Meta 内核的翻墙神器。</p>
        <a href="tutorials/clash-verge-guide.html" class="tutorial-link">查看教程</a>
      </div>
      <div class="tutorial-card">
        <div class="tutorial-icon">verge</div>
        <h4>Clash Verge 下载安装</h4>
        <p>提供 GitHub 官方渠道的下载指南，避开网络上的钓鱼网站。</p>
        <a href="tutorials/clash-verge-download.html" class="tutorial-link">查看教程</a>
      </div>
    '''

    # Insert into Windows Section
    win_marker = '<!-- Windows Segment -->\n    <h2 style="font-size: 1.8rem; margin-bottom: 1.5rem; border-left: 4px solid #00f2fe; padding-left: 0.75rem;">Windows 平台</h2>\n    <div class="tutorial-grid" style="margin-bottom: 3.5rem;">'
    if win_marker in t_html:
        t_html = t_html.replace(win_marker, win_marker + new_cards_windows)

    # Insert into macOS Section
    mac_marker = '<!-- macOS Segment -->\n    <h2 style="font-size: 1.8rem; margin-bottom: 1.5rem; border-left: 4px solid #b176ff; padding-left: 0.75rem;">macOS 平台</h2>\n    <div class="tutorial-grid" style="margin-bottom: 3.5rem;">'
    if mac_marker in t_html:
        t_html = t_html.replace(mac_marker, mac_marker + new_cards_macos)

    with open('tutorials.html', 'w', encoding='utf-8') as f:
        f.write(t_html)
    print("Updated tutorials.html")

except Exception as e:
    print(e)


try:
    with open('knowledge.html', 'r', encoding='utf-8') as f:
        k_html = f.read()

    new_k_cards = '''
        <div class="knowledge-card">
          <h4><a href="knowledge/what-is-dns.html" style="color:inherit;text-decoration:none;">什么是 DNS</a></h4>
          <p>DNS 是互联网的“电话簿”，将网址转换为 IP 地址</p>
        </div>
        <div class="knowledge-card">
          <h4><a href="knowledge/vpn-vs-proxy.html" style="color:inherit;text-decoration:none;">VPN和代理的区别</a></h4>
          <p>详细对比 VPN 与 Proxy 在协议原理、安全性、速度和使用场景上的差异。</p>
        </div>
        <div class="knowledge-card">
          <h4><a href="help/clash-verge-node-failed.html" style="color:inherit;text-decoration:none;">Clash 节点连接失败排查</a></h4>
          <p>Timeout与连接被重置的常见原因分析</p>
        </div>
    '''

    k_marker = '<div class="knowledge-grid">'
    if k_marker not in k_html:
        k_marker = '<div class="knowledge-grid" style="margin-bottom: 3.5rem;">'
        
    if k_marker in k_html:
        k_html = k_html.replace(k_marker, k_marker + new_k_cards, 1)

    with open('knowledge.html', 'w', encoding='utf-8') as f:
        f.write(k_html)
    print("Updated knowledge.html")

except Exception as e:
    print(e)
