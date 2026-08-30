import os
import re
import glob

base = r'c:\Users\PC\Desktop\落地页\nodehub168.com'
files = glob.glob(os.path.join(base, '**', '*.html'), recursive=True)

for fpath in sorted(files):
    with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    title_m = re.search(r'<title>(.*?)</title>', content, re.IGNORECASE | re.DOTALL)
    desc_m = re.search(r'<meta\s+name=["\']description["\']\s+content=["\'](.*?)["\']', content, re.IGNORECASE | re.DOTALL)
    title = title_m.group(1).strip() if title_m else '(none)'
    desc = desc_m.group(1).strip() if desc_m else '(none)'
    relpath = os.path.relpath(fpath, base)
    print(f'FILE: {relpath}')
    print(f'  TITLE: {title}')
    print(f'  DESC({len(desc)}): {desc[:150]}')
    print()
