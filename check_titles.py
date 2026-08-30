import urllib.parse, os, re

base_dir = r"c:\Users\PC\Desktop\落地页\nodehub168.com"
with open(os.path.join(base_dir, "latest-articles.html"), "r", encoding="utf-8") as f:
    content = f.read()

links = re.findall(r'<h3 class=\"review-title\"><a href=\"([^\"]+)\">([^<]+)</a></h3>', content)
for href, title in links:
    parsed = urllib.parse.urlparse(href)
    local_path = os.path.join(base_dir, parsed.path.replace('/', '\\'))
    
    if os.path.exists(local_path):
        with open(local_path, "r", encoding="utf-8") as lf:
            lc = lf.read()
            # Find title
            m = re.search(r'<title>([^<]+)</title>', lc)
            if m:
                print(f"[OK] {href} -> {m.group(1).strip()}")
            else:
                print(f"[NO TITLE] {href}")
    else:
        print(f"[MISSING] {href}")
