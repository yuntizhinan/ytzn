import os, re, json
from collections import defaultdict

BASE = r'c:\Users\PC\Desktop\落地页\nodehub168.com'

HTML_FILES = [
    ('index.html', '/'),
    ('apple-id.html', '/apple-id.html'),
    ('apple-id-guide.html', '/apple-id-guide.html'),
    ('knowledge.html', '/knowledge.html'),
    ('latest-articles.html', '/latest-articles.html'),
    ('post-detail.html', '/post-detail.html'),
    ('protocol-selection-2026.html', '/protocol-selection-2026.html'),
    ('ranking.html', '/ranking.html'),
    ('reviews.html', '/reviews.html'),
    ('share-id.html', '/share-id.html'),
    ('tags.html', '/tags.html'),
    ('tutorials.html', '/tutorials.html'),
    ('temp.html', '/temp.html'),
    ('reviews/claude-ai-jiaocheng-2026.html', '/reviews/claude-ai-jiaocheng-2026.html'),
    ('reviews/connection-issues.html', '/reviews/connection-issues.html'),
    ('reviews/edge.html', '/reviews/edge.html'),
    ('reviews/feiniaoyun.html', '/reviews/feiniaoyun.html'),
    ('reviews/flybit.html', '/reviews/flybit.html'),
    ('reviews/how-to-choose.html', '/reviews/how-to-choose.html'),
    ('reviews/jilianyun-2026.html', '/reviews/jilianyun-2026.html'),
    ('reviews/jilianyun.html', '/reviews/jilianyun.html'),
    ('reviews/kuaili.html', '/reviews/kuaili.html'),
    ('reviews/speedworld-2026.html', '/reviews/speedworld-2026.html'),
    ('reviews/xsus.html', '/reviews/xsus.html'),
    ('reviews/xxyun.html', '/reviews/xxyun.html'),
    ('reviews/yiyunti.html', '/reviews/yiyunti.html'),
    ('tutorials/cfa-android.html', '/tutorials/cfa-android.html'),
    ('tutorials/cfw-win.html', '/tutorials/cfw-win.html'),
    ('tutorials/clash-tutorial.html', '/tutorials/clash-tutorial.html'),
    ('tutorials/clash-verge-config.html', '/tutorials/clash-verge-config.html'),
    ('tutorials/clash-verge-download.html', '/tutorials/clash-verge-download.html'),
    ('tutorials/clash-verge-guide.html', '/tutorials/clash-verge-guide.html'),
    ('tutorials/clash-verge-import-config.html', '/tutorials/clash-verge-import-config.html'),
    ('tutorials/clash-verge-mac.html', '/tutorials/clash-verge-mac.html'),
    ('tutorials/clash-verge-win.html', '/tutorials/clash-verge-win.html'),
    ('tutorials/clashx-mac.html', '/tutorials/clashx-mac.html'),
    ('tutorials/loon-mac.html', '/tutorials/loon-mac.html'),
    ('tutorials/singbox-android.html', '/tutorials/singbox-android.html'),
    ('tutorials/singbox-win.html', '/tutorials/singbox-win.html'),
    ('tutorials/v2rayng-android.html', '/tutorials/v2rayng-android.html'),
    ('help/airport-timeout.html', '/help/airport-timeout.html'),
    ('help/chatgpt-1020.html', '/help/chatgpt-1020.html'),
    ('help/chatgpt-network-error.html', '/help/chatgpt-network-error.html'),
    ('help/clash-verge-failed.html', '/help/clash-verge-failed.html'),
    ('help/clash-verge-node-failed.html', '/help/clash-verge-node-failed.html'),
    ('help/clash-verge-timeout.html', '/help/clash-verge-timeout.html'),
    ('help/dns-resolution-failed.html', '/help/dns-resolution-failed.html'),
    ('airports/cheap-recommend.html', '/airports/cheap-recommend.html'),
    ('airports/what-is-bgp.html', '/airports/what-is-bgp.html'),
    ('ai/chatgpt-guide.html', '/ai/chatgpt-guide.html'),
    ('knowledge/vpn-vs-proxy.html', '/knowledge/vpn-vs-proxy.html'),
    ('knowledge/what-is-dns.html', '/knowledge/what-is-dns.html'),
    ('posts/protocol-selection-2026.html', '/posts/protocol-selection-2026.html'),
    ('posts/recommend-guide.html', '/posts/recommend-guide.html'),
    ('posts/v2ray-tls-reality-protocol.html', '/posts/v2ray-tls-reality-protocol.html'),
    ('guides/sing-box-windows.html', '/guides/sing-box-windows.html'),
]

def get_meta(html, name):
    # pattern1: name first
    p1 = re.search(r'<meta\s+name=["\']' + re.escape(name) + r'["\'][^>]*content=["\']([^"\']*)["\']', html, re.IGNORECASE)
    if p1:
        return p1.group(1).strip()
    # pattern2: content first
    p2 = re.search(r'<meta\s+content=["\']([^"\']*)["\'][^>]*name=["\']' + re.escape(name) + r'["\']', html, re.IGNORECASE)
    if p2:
        return p2.group(1).strip()
    return ''

def get_og(html, prop):
    p1 = re.search(r'<meta\s+property=["\']' + re.escape(prop) + r'["\'][^>]*content=["\']([^"\']*)["\']', html, re.IGNORECASE)
    if p1:
        return p1.group(1).strip()
    p2 = re.search(r'<meta\s+content=["\']([^"\']*)["\'][^>]*property=["\']' + re.escape(prop) + r'["\']', html, re.IGNORECASE)
    if p2:
        return p2.group(1).strip()
    return ''

def get_title(html):
    m = re.search(r'<title[^>]*>(.*?)</title>', html, re.IGNORECASE | re.DOTALL)
    return m.group(1).strip() if m else ''

def get_canonical(html):
    m = re.search(r'<link[^>]*rel=["\']canonical["\'][^>]*href=["\']([^"\']*)["\']', html, re.IGNORECASE)
    if m:
        return m.group(1).strip()
    m2 = re.search(r'<link[^>]*href=["\']([^"\']*)["\'][^>]*rel=["\']canonical["\']', html, re.IGNORECASE)
    return m2.group(1).strip() if m2 else ''

results = []
for relpath, url in HTML_FILES:
    fpath = os.path.join(BASE, relpath)
    if not os.path.exists(fpath):
        results.append({'url': url, 'file': relpath, 'error': 'FILE_NOT_FOUND'})
        continue
    with open(fpath, encoding='utf-8', errors='replace') as f:
        html = f.read()

    title = get_title(html)
    desc = get_meta(html, 'description')
    canonical = get_canonical(html)
    robots = get_meta(html, 'robots')
    h1_raw = re.findall(r'<h1[^>]*>(.*?)</h1>', html, re.IGNORECASE | re.DOTALL)
    h1_list = [re.sub(r'<[^>]+>', '', h).strip() for h in h1_raw]
    og_title = get_og(html, 'og:title')
    og_desc = get_og(html, 'og:description')

    results.append({
        'url': url,
        'file': relpath,
        'title': title,
        'title_len': len(title),
        'desc': desc,
        'desc_len': len(desc),
        'canonical': canonical,
        'robots': robots,
        'h1_count': len(h1_list),
        'h1': h1_list,
        'og_title': og_title,
        'og_desc': og_desc,
    })

with open('seo_raw_data.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"Scanned {len(results)} files.")
print("Output: seo_raw_data.json")
