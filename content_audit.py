import os
import glob
import re
import json

drafts = glob.glob('content/drafts/*.json')
errors = []

for draft in drafts:
    with open(draft, 'r', encoding='utf-8') as f:
        data = json.load(f)
        content = data.get('content', '')
        
        # Check word count
        if len(content) < 500:
            errors.append(f"{draft}: Word count less than 500 ({len(content)})")
            
        # Check H2 count
        h2_count = len(re.findall(r'<h2>', content, re.IGNORECASE))
        if h2_count < 2:
            errors.append(f"{draft}: H2 count less than 2 ({h2_count})")
            
        # Check internal links
        links = re.findall(r'<a\s+href=', content, re.IGNORECASE)
        if len(links) < 1:
            errors.append(f"{draft}: No internal links found")
            
        # Check abstract
        if '摘要' not in content:
            errors.append(f"{draft}: No abstract/summary found")
            
        # Check update time
        if '最后更新' not in content:
            errors.append(f"{draft}: No update time found")

if errors:
    print('CONTENT AUDIT FAILED:')
    for err in errors:
        print(err)
else:
    print('CONTENT AUDIT PASSED')
