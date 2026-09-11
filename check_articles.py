import json
import codecs
from collections import Counter

try:
    with codecs.open('articles.json', 'r', 'utf-8') as f:
        data = json.load(f)
except Exception:
    with codecs.open('articles.json', 'r', 'gbk', errors='ignore') as f:
        data = json.load(f)

links = [a.get('link') for a in data.get('articles', [])]
counts = Counter(links)
print(f"Total articles: {len(links)}")

check_links = [
    '/help/dns-resolution-failed.html',
    '/help/chatgpt-network-error.html',
    '/help/clash-verge-timeout.html'
]
for l in check_links:
    print(f"Link {l} count: {counts.get(l, 0)}")

dups = {k: v for k, v in counts.items() if v > 1}
if dups:
    print("Duplicates found:", dups)
else:
    print("No duplicates found.")
