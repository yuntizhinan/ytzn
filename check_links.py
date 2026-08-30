import re
import os
import urllib.parse

base_dir = r"c:\Users\PC\Desktop\落地页\nodehub168.com"
files_to_check = ['latest-articles.html', 'index.html']

for filename in files_to_check:
    filepath = os.path.join(base_dir, filename)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    print(f"\nChecking links in {filename}...")
    
    # Simple regex to find hrefs in review-title
    links = re.findall(r'<h3 class="review-title"><a href="([^"]+)">([^<]+)</a></h3>', content)
    
    for href, title in links:
        # Check if the file exists
        parsed = urllib.parse.urlparse(href)
        local_path = os.path.join(base_dir, parsed.path.replace('/', '\\'))
        exists = os.path.exists(local_path)
        
        status = "OK" if exists else "MISSING"
        print(f"[{status}] {href} - {title}")
