import re
with open(r'C:\Users\PC\.gemini\antigravity-ide\brain\d737509d-a0d7-4bd0-923b-22df9110291f\.system_generated\steps\6\content.md', 'r', encoding='utf-8') as f:
    text = f.read()

# basic regex to extract all headings and paragraphs
matches = re.findall(r'<h[1-6][^>]*>(.*?)</h[1-6]>|<p[^>]*>(.*?)</p>|<li[^>]*>(.*?)</li>', text, re.IGNORECASE | re.DOTALL)
extracted = []
for m in matches:
    t = m[0] or m[1] or m[2]
    t = re.sub(r'<[^>]+>', '', t).strip()
    # remove html entities
    t = t.replace('&nbsp;', ' ').replace('&hellip;', '...').replace('&amp;', '&').replace('&#8211;', '-')
    if t:
        extracted.append(t)

with open('extracted.txt', 'w', encoding='utf-8') as f:
    f.write('\n'.join(extracted))
