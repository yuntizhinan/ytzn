import os
import glob
import re
import json

import sys
sys.stdout = open('python_log.txt', 'w', encoding='utf-8')
sys.stderr = sys.stdout

base_dir = r"c:\Users\PC\Desktop\落地页\nodehub168.com"

# 1. Rebuild the 3 stage 6 articles
template_path = os.path.join(base_dir, 'post-detail.html')
with open(template_path, 'r', encoding='utf-8') as f:
    template_html = f.read()

drafts_dir = os.path.join(base_dir, 'content', 'drafts', 'stage5')
draft_files = glob.glob(os.path.join(drafts_dir, '*.json'))

for df in draft_files:
    with open(df, 'r', encoding='utf-8') as f:
        d = json.load(f)
    
    title = d['title'] + " - 云梯指南"
    canonical = "https://nodehub168.com" + d['newPath']
    
    # Extract description from content
    desc = "本文由云梯指南编辑部为您带来详细解读。"
    m = re.search(r'摘要：.*?</strong>(.*?)</p>', d['content'], re.DOTALL)
    if m:
        desc = m.group(1).strip()
    
    html = template_html
    html = re.sub(r'<title>.*?</title>', f'<title>{title}</title>', html, flags=re.DOTALL)
    html = re.sub(r'<link rel="canonical" href=".*?">', f'<link rel="canonical" href="{canonical}">', html, flags=re.DOTALL)
    html = re.sub(r'<meta name="description" content=".*?">', f'<meta name="description" content="{desc}">', html, flags=re.DOTALL)
    
    # We will skip replacing OG tags and Schema if they are too complex, 
    # but the user already has them in post-detail.html so we should replace the specific fields if needed.
    # Actually, post-detail.html has <meta property="og:title" content="...">
    html = re.sub(r'<meta property="og:title" content=".*?">', f'<meta property="og:title" content="{title}">', html)
    html = re.sub(r'<meta property="og:description" content=".*?">', f'<meta property="og:description" content="{desc}">', html)
    html = re.sub(r'<meta property="og:url" content=".*?">', f'<meta property="og:url" content="{canonical}">', html)
    
    # Replace body content
    html = re.sub(r'<section class="article-body" id="article-body-content">.*?</section>',
                  f'<section class="article-body" id="article-body-content">\n{d["content"]}\n</section>', html, flags=re.DOTALL)
    
    # Replace title h1
    html = re.sub(r'<h1 id="article-title-main"[^>]*>.*?</h1>', f'<h1 id="article-title-main" style="font-size: 2.5rem; line-height: 1.3;">{d["title"]}</h1>', html)
    
    # Output file
    out_path = os.path.join(base_dir, d['newPath'].lstrip('/').replace('/', '\\'))
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print(f"Rebuilt {out_path}")

# 2. Fix all dead relative links in all HTML files
print("\nFixing relative links...")
html_files = glob.glob(os.path.join(base_dir, '**', '*.html'), recursive=True)

for filepath in html_files:
    if 'backup' in filepath:
        continue
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        continue
    
    # Find all a tags
    # Replace href="filename.html" with href="/filename.html" if it's pointing to the root
    # Actually, the easiest way to fix links from subdirectories (like tutorials/) to root (index.html) 
    # is to prepend '/' if it doesn't have it and doesn't point to a subdirectory.
    
    def replacer(match):
        full_a = match.group(0)
        href = match.group(1)
        
        # Skip absolute URLs, mailto, hashes, and root-relative
        if href.startswith('http') or href.startswith('mailto:') or href.startswith('#') or href.startswith('/'):
            return full_a
            
        # Check if the path exists relative to current file
        local_dir = os.path.dirname(filepath)
        path_part = href.split('?')[0].split('#')[0]
        
        target_path = os.path.join(local_dir, path_part.replace('/', '\\'))
        
        # If the file doesn't exist relative to the current file, but DOES exist in the root directory
        if not os.path.exists(target_path):
            root_target_path = os.path.join(base_dir, path_part.replace('/', '\\'))
            if os.path.exists(root_target_path):
                # Fix it by prepending '/'
                new_href = '/' + href
                return full_a.replace(f'href="{href}"', f'href="{new_href}"')
        
        return full_a

    new_content = re.sub(r'<a\s+[^>]*href="([^"]+)"', replacer, content)
    
    # Special fix for indexnow and logo in post-detail.html based templates
    # Replace src="assets/logo.png" with src="/assets/logo.png"
    new_content = re.sub(r'src="assets/logo\.png"', 'src="/assets/logo.png"', new_content)
    # Replace href="index.css" with href="/index.css"
    new_content = re.sub(r'href="index\.css"', 'href="/index.css"', new_content)
    # Replace src="main.js" with src="/main.js"
    new_content = re.sub(r'src="main\.js"', 'src="/main.js"', new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Fixed links in {os.path.basename(filepath)}")

print("Done.")
