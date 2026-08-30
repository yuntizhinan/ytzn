import re
import os
import sys
import datetime

# The file containing the fetched HTML
fetched_file = r"C:\Users\PC\.gemini\antigravity-ide\brain\128b666e-f7e3-4688-9ea1-7a00bac318ff\.system_generated\steps\84\content.md"

with open(fetched_file, "r", encoding="utf-8") as f:
    html = f.read()

# Extract accounts based on data-reveal attribute
# Example: <code data-reveal="quodonnell@gmail.com" ...
# Then password: <code data-reveal="Dd10096da" ...
matches = re.findall(r'<code data-reveal="([^"]+@[^"]+)".*?密码.*?<code data-reveal="([^"]+)"', html, re.DOTALL)

accounts = []
seen = set()
for email, password in matches:
    if email not in seen:
        seen.add(email)
        accounts.append({"id": email, "pass": password})

if not accounts:
    print("No accounts found with the new regex. Trying alternative...")
    # Alternative: finding all data-reveal attributes
    reveals = re.findall(r'data-reveal="([^"]+)"', html)
    for i in range(0, len(reveals)-1):
        if '@' in reveals[i] and '@' not in reveals[i+1]:
            email = reveals[i]
            password = reveals[i+1]
            if email not in seen:
                seen.add(email)
                accounts.append({"id": email, "pass": password})

if not accounts:
    print("Still no accounts found!")
    sys.exit(1)

accounts = accounts[:30]
print(f"Found {len(accounts)} accounts.")

# Read share-id.html
base_dir = r"c:\Users\PC\Desktop\落地页\nodehub168.com"
file_path = os.path.join(base_dir, "share-id.html")
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace title
content = re.sub(r'<title>.*?</title>', '<title>2026最新免费美区Apple ID共享账号 | Shadowrocket/小火箭下载 | iOS美区账号每日更新</title>', content)

# Replace accounts array
js_array_items = []
for acc in accounts:
    js_array_items.append(f'{{ id: "{acc["id"]}", pass: "{acc["pass"]}" }}')

js_array_str = "const accounts = [\n        " + ",\n        ".join(js_array_items) + "\n      ];"

content = re.sub(r'const accounts = \[.*?\];', js_array_str, content, flags=re.DOTALL)

# Replace date
current_date = datetime.datetime.now().strftime("%Y年%m月%d日")
content = re.sub(r'📅 文章每日更新日期：\d{4}年\d{2}月\d{2}日', f'📅 文章每日更新日期：{current_date}', content)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("share-id.html updated successfully!")
