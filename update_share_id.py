import urllib.request
import re
import os
import datetime

url = "https://www.jichangcha.com/share-id/"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req) as response:
        html = response.read().decode('utf-8')
except Exception as e:
    print("Error fetching URL:", e)
    exit(1)

# Extract accounts
# Look for something like: <div class="..."> <span>账号:</span> xxx </div> <span>密码:</span> yyy
# Let's see the structure from before.
# In the previous session, I extracted them successfully. Let's just grab the emails and passwords.
matches = re.findall(r'([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+).*?密码.*?([a-zA-Z0-9]{8,15})', html, re.DOTALL | re.IGNORECASE)

# The matches might be messy, let's refine it. 
# Another common pattern:
# We know the ID is an email, and the password is an alphanumeric string.
accounts = []
for m in re.finditer(r'([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)', html):
    email = m.group(1)
    # find the next password nearby
    sub = html[m.end():m.end()+100]
    pass_match = re.search(r'([a-zA-Z0-9]{8,15})', re.sub(r'[^a-zA-Z0-9]', ' ', sub).split('密码')[-1])
    if pass_match:
        # Avoid false positives like dates or standard words
        accounts.append({"id": email, "pass": pass_match.group(1).strip()})

# Deduplicate
unique_accounts = []
seen = set()
for a in accounts:
    if a['id'] not in seen:
        seen.add(a['id'])
        unique_accounts.append(a)

if not unique_accounts:
    print("No accounts found!")
    exit(1)

# Limit to 30
unique_accounts = unique_accounts[:30]

print(f"Found {len(unique_accounts)} accounts.")

# Read share-id.html
base_dir = r"c:\Users\PC\Desktop\落地页\nodehub168.com"
file_path = os.path.join(base_dir, "share-id.html")
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace title
content = re.sub(r'<title>.*?</title>', '<title>2026最新免费美区Apple ID共享账号 | Shadowrocket/小火箭下载 | iOS美区账号每日更新</title>', content)

# Replace accounts array
js_array_items = []
for acc in unique_accounts:
    js_array_items.append(f'{{ id: "{acc["id"]}", pass: "{acc["pass"]}" }}')

js_array_str = "const accounts = [\n        " + ",\n        ".join(js_array_items) + "\n      ];"

content = re.sub(r'const accounts = \[.*?\];', js_array_str, content, flags=re.DOTALL)

# Replace date
current_date = datetime.datetime.now().strftime("%Y年%m月%d日")
content = re.sub(r'📅 文章每日更新日期：\d{4}年\d{2}月\d{2}日', f'📅 文章每日更新日期：{current_date}', content)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("share-id.html updated successfully!")
