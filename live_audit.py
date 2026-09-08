import urllib.request
import urllib.error
import re
import json

urls = [
    "https://nodehub168.com/tutorials/clash-verge-guide.html",
    "https://nodehub168.com/tutorials/clash-verge-download.html",
    "https://nodehub168.com/knowledge/what-is-dns.html",
    "https://nodehub168.com/knowledge/vpn-vs-proxy.html",
    "https://nodehub168.com/ai/chatgpt-guide.html"
]

class RedirectHandler(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        print(f"Redirected ({code}) to {newurl}")
        return super().redirect_request(req, fp, code, msg, headers, newurl)

opener = urllib.request.build_opener(RedirectHandler())
urllib.request.install_opener(opener)

results = []

for u in urls:
    print(f"\n--- Fetching {u} ---")
    status = "Unknown"
    html = ""
    final_url = u
    try:
        req = urllib.request.Request(u, headers={'User-Agent': 'Mozilla/5.0 AuditBot'})
        with urllib.request.urlopen(req) as response:
            status = response.status
            final_url = response.url
            html = response.read().decode('utf-8')
    except urllib.error.HTTPError as e:
        status = e.code
        final_url = e.url
        try:
            html = e.read().decode('utf-8')
        except:
            pass
    except Exception as e:
        status = str(e)

    title_match = re.search(r'(?si)<title>(.*?)</title>', html)
    title = title_match.group(1).strip() if title_match else ""

    desc_match = re.search(r'(?si)<meta name="description" content="(.*?)">', html)
    desc = desc_match.group(1).strip() if desc_match else ""

    canon_match = re.search(r'(?si)<link rel="canonical" href="(.*?)">', html)
    canon = canon_match.group(1).strip() if canon_match else ""

    h1_match = re.search(r'(?si)<h1.*?>(.*?)</h1>', html)
    h1 = h1_match.group(1).strip() if h1_match else ""
    h1_count = len(re.findall(r'(?si)<h1.*?>', html))

    schema_article = '"@type": "Article"' in html or '"@type":"Article"' in html
    schema_bread = '"@type": "BreadcrumbList"' in html or '"@type":"BreadcrumbList"' in html
    schema_org = '"@type": "Organization"' in html or '"@type":"Organization"' in html

    og_tags = len(re.findall(r'property="og:', html))
    robots_match = re.search(r'(?si)<meta name="robots" content="(.*?)">', html)
    robots = robots_match.group(1).strip() if robots_match else ""

    print(f"Status: {status}")
    print(f"Final URL: {final_url}")
    print(f"Title: {title}")
    print(f"H1: {h1}")
    print(f"Canonical: {canon}")
    print(f"Schema Org Author: {schema_org}")
