import re
import json

fetched_file = r"C:\Users\PC\.gemini\antigravity-ide\brain\8b324571-b4d1-443b-a1af-f399c24c2d7b\.system_generated\steps\21\content.md"
with open(fetched_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Extract accounts
accounts = []
# The HTML structure in fetched file has:
# <p class="mb-1 text-xs font-medium tracking-wide text-slate-400">APPLE ID</p> ... <code data-reveal="email@example.com" ...
# <p class="mb-1 text-xs font-medium tracking-wide text-slate-400">密码</p> ... <code data-reveal="password123" ...
pattern = r'<code data-reveal="([^"]+)"'
matches = re.findall(pattern, content)
for i in range(0, len(matches), 2):
    if i+1 < len(matches):
        accounts.append({"id": matches[i], "pass": matches[i+1]})

print(f"Extracted {len(accounts)} accounts.")

# Extract dates
# e.g., 实时聚合 · 2026-08-26 更新 or <p class="text-2xl font-bold tracking-tight text-slate-900">08-26</p>
date_match = re.search(r'2026-(\d{2}-\d{2}) 更新', content)
if date_match:
    short_date = date_match.group(1)
    full_date = f"2026年{short_date.split('-')[0]}月{short_date.split('-')[1]}日"
else:
    short_date = "08-26"
    full_date = "2026年08月26日"

print(f"Extracted Date: {full_date} ({short_date})")

# 1. Update share-id.html
share_id_path = r"c:\Users\PC\Desktop\落地页\nodehub168.com\share-id.html"
with open(share_id_path, 'r', encoding='utf-8') as f:
    share_content = f.read()

# Replace accounts array
accounts_json = "const accounts = [\n        " + ",\n        ".join([f'{{ id: "{acc["id"]}", pass: "{acc["pass"]}" }}' for acc in accounts]) + "\n      ];"
share_content = re.sub(r'const accounts = \[.*?\];', accounts_json, share_content, flags=re.DOTALL)

# Replace dates and counts
share_content = re.sub(r'2026年\d{2}月\d{2}日', full_date, share_content)
share_content = re.sub(r'<p style="font-size: 2\.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var\(--font-title\);">\d+</p>\s*<p style="font-size: 0\.95rem; color: var\(--text-muted\); text-transform: uppercase; letter-spacing: 1px;">可用账号</p>', f'<p style="font-size: 2.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var(--font-title);">{len(accounts)}</p>\n        <p style="font-size: 0.95rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;">可用账号</p>', share_content)
share_content = re.sub(r'<p style="font-size: 2\.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var\(--font-title\);">\d{2}-\d{2}</p>\s*<p style="font-size: 0\.95rem; color: var\(--text-muted\); text-transform: uppercase; letter-spacing: 1px;">今日更新</p>', f'<p style="font-size: 2.5rem; font-weight: bold; color: #fff; margin-bottom: 5px; font-family: var(--font-title);">{short_date}</p>\n        <p style="font-size: 0.95rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;">今日更新</p>', share_content)

with open(share_id_path, 'w', encoding='utf-8') as f:
    f.write(share_content)
print("Updated share-id.html")

# 2. Update apple-id.html
apple_id_path = r"c:\Users\PC\Desktop\落地页\nodehub168.com\apple-id.html"
with open(apple_id_path, 'r', encoding='utf-8') as f:
    apple_content = f.read()

# Replace dates
apple_content = re.sub(r'2026年\d{2}月\d{2}日', full_date, apple_content)

# Replace the grid of accounts
# We can find the grid div and replace its content
grid_start_idx = apple_content.find('<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">')
if grid_start_idx != -1:
    grid_start_idx += len('<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">')
    # find the closing div of the grid. There are many inner divs.
    # A simple regex won't work well for nested HTML, let's use string manipulation or a regex up to the next section.
    grid_end_idx = apple_content.find('</div>\n    </article>', grid_start_idx)
    
    if grid_end_idx != -1:
        new_grid_html = ""
        for acc in accounts:
            new_grid_html += f'''
        <div style="padding: 20px; border: 1px solid var(--border-color); border-radius: 8px; background: rgba(0,0,0,0.2); transition: transform 0.3s, box-shadow 0.3s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='var(--glow-shadow)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
            <h4 style="margin: 0; color: var(--text-primary); font-size: 1.1rem;">免费共享账号</h4>
            <span style="font-size: 0.8rem; background: rgba(46, 204, 113, 0.1); color: var(--accent-green); padding: 2px 8px; border-radius: 12px; border: 1px solid rgba(46, 204, 113, 0.2);">可用</span>
          </div>
          <p style="margin-bottom: 12px; font-size: 0.95rem;">
            <strong style="color: var(--text-muted); font-size: 0.85rem; display: block; margin-bottom: 4px;">APPLE ID</strong> 
            <span style="color: var(--text-secondary); font-family: monospace; display: block; background: rgba(255,255,255,0.03); padding: 8px; border-radius: 6px; border: 1px solid var(--border-color); word-break: break-all;">{acc['id']}</span>
          </p>
          <p style="font-size: 0.95rem; margin: 0;">
            <strong style="color: var(--text-muted); font-size: 0.85rem; display: block; margin-bottom: 4px;">密码</strong> 
            <span style="color: var(--text-secondary); font-family: monospace; display: block; background: rgba(255,255,255,0.03); padding: 8px; border-radius: 6px; border: 1px solid var(--border-color); word-break: break-all;">{acc['pass']}</span>
          </p>
        </div>'''
        new_grid_html += "\n      "
        apple_content = apple_content[:grid_start_idx] + new_grid_html + apple_content[grid_end_idx:]
        
        with open(apple_id_path, 'w', encoding='utf-8') as f:
            f.write(apple_content)
        print("Updated apple-id.html")
    else:
        print("Could not find end of grid in apple-id.html")
else:
    print("Could not find grid in apple-id.html")


# 3. Update protocol-selection-2026.html
protocol_path = r"c:\Users\PC\Desktop\落地页\nodehub168.com\protocol-selection-2026.html"
with open(protocol_path, 'r', encoding='utf-8') as f:
    protocol_content = f.read()

protocol_content = re.sub(r'实时更新） ⚡</h3>', f'今日免费美区 Apple ID 共享（2026-{short_date} 实时更新） ⚡</h3>', protocol_content)
protocol_content = re.sub(r'今日免费美区 Apple ID 共享（2026-\d{2}-\d{2} 实时更新） ⚡</h3>', f'今日免费美区 Apple ID 共享（2026-{short_date} 实时更新） ⚡</h3>', protocol_content)
protocol_content = re.sub(r'查看完整 \d+ 个实时可用账号密码', f'查看完整 {len(accounts)} 个实时可用账号密码', protocol_content)

# Update the sample account
if accounts:
    sample_acc = accounts[0]
    protocol_content = re.sub(r'样例可用账号 1：<code>.*?</code> &nbsp;&nbsp;\|&nbsp;&nbsp; 密码：<code>.*?</code>', f'样例可用账号 1：<code>{sample_acc["id"]}</code> &nbsp;&nbsp;|&nbsp;&nbsp; 密码：<code>{sample_acc["pass"]}</code>', protocol_content)

with open(protocol_path, 'w', encoding='utf-8') as f:
    f.write(protocol_content)
print("Updated protocol-selection-2026.html")
