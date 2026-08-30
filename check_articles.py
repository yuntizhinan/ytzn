import os, re

base_dir = r"c:\Users\PC\Desktop\落地页\nodehub168.com"
with open(os.path.join(base_dir, "latest-articles.html"), "r", encoding="utf-8") as f:
    content = f.read()

# Also read post-detail.html
with open(os.path.join(base_dir, "post-detail.html"), "r", encoding="utf-8") as f:
    post_detail = f.read()

links = re.findall(r'<h3 class=\"review-title\"><a href=\"([^\"]+)\">([^<]+)</a></h3>', content)

for href, expected_title in links:
    actual_title = ""
    status = "MISSING"
    
    if href.startswith("post-detail.html?id="):
        article_id = href.split("=")[1]
        # Find title in articles['id'] = { title: '...', ... }
        match = re.search(r"articles\['" + article_id + r"'\]\s*=\s*\{.*?title:\s*'(.*?)'", post_detail, re.DOTALL)
        if not match:
            match = re.search(r'articles\["' + article_id + r'"\]\s*=\s*\{.*?title:\s*"(.*?)"', post_detail, re.DOTALL)
            
        if match:
            actual_title = match.group(1).strip()
            status = "OK" if actual_title == expected_title.strip() else "MISMATCH"
        else:
            status = "NOT FOUND IN POST-DETAIL"
            
    else:
        local_path = os.path.join(base_dir, href.replace('/', '\\'))
        if os.path.exists(local_path):
            with open(local_path, "r", encoding="utf-8") as lf:
                lc = lf.read()
                m = re.search(r'<title>([^<]+)</title>', lc)
                if m:
                    actual_title = m.group(1).strip()
                    # Just check if expected_title is IN actual_title because actual title might have " - 云梯指南" appended.
                    status = "OK" if expected_title.strip() in actual_title else "MISMATCH"
                else:
                    status = "NO TITLE TAG"
        else:
            status = "FILE MISSING"
            
    print(f"[{status}] {href}\n  Expected: {expected_title}\n  Actual: {actual_title}\n")
