import urllib.request
import re
import os
import datetime
import sys

url = "https://www.jichangcha.com/share-id/"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req) as response:
        html = response.read().decode('utf-8')
except Exception as e:
    print("Error fetching URL:", e)
    sys.exit(1)

# Extract accounts based on data-reveal attribute
matches = re.findall(r'<code[^>]*data-reveal="([^"]+@[^"]+)"[^>]*>.*?密码.*?<code[^>]*data-reveal="([^"]+)"', html, re.DOTALL)

unique_accounts = []
seen = set()

for email, password in matches:
    if email not in seen:
        seen.add(email)
        unique_accounts.append({"id": email, "pass": password})

if not unique_accounts:
    print("No accounts found with primary regex. Trying fallback...")
    reveals = re.findall(r'data-reveal="([^"]+)"', html)
    for i in range(len(reveals) - 1):
        if '@' in reveals[i] and '@' not in reveals[i+1]:
            email = reveals[i]
            password = reveals[i+1]
            if email not in seen:
                seen.add(email)
                unique_accounts.append({"id": email, "pass": password})

if not unique_accounts:
    print("No accounts found!")
    sys.exit(1)

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

# Update date in apple-id.html as well
apple_id_path = os.path.join(base_dir, "apple-id.html")
with open(apple_id_path, "r", encoding="utf-8") as f:
    apple_content = f.read()

apple_content = re.sub(r'📅 文章每日更新日期：\d{4}年\d{2}月\d{2}日', f'📅 文章每日更新日期：{current_date}', apple_content)

with open(apple_id_path, "w", encoding="utf-8") as f:
    f.write(apple_content)

# Update date in articles.json
import json
articles_json_path = os.path.join(base_dir, "articles.json")
try:
    with open(articles_json_path, "r", encoding="utf-8") as f:
        articles_data = json.load(f)
    
    current_date_iso = datetime.datetime.now().strftime("%Y-%m-%d")
    for item in articles_data.get("articles", []):
        if item.get("link") == "share-id.html":
            item["date"] = current_date_iso
            break
            
    with open(articles_json_path, "w", encoding="utf-8") as f:
        json.dump(articles_data, f, ensure_ascii=False, indent=2)
except Exception as e:
    print(f"Failed to update articles.json: {e}")

print("share-id.html, apple-id.html, and articles.json dates updated successfully!")
