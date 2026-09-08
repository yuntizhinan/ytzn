import re

filepath = r"c:\Users\PC\Desktop\落地页\nodehub168.com\reviews.html"
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# The card blocks are separated by `\n\n` or `\n        <!-- `
# Let's use regex to find the blocks.

# 1. Extract Kuaili block
kuaili_pattern = re.compile(r'\n*        <!-- Card 4 -->\n        <div class="review-item" style="width: 100%;">\n.*?<h3 class="review-title"><a href="post-detail\.html\?id=kuaili">快狸机场深度评测</a></h3>.*?        </div>\n', re.DOTALL)

match = kuaili_pattern.search(content)
if not match:
    print("Kuaili block not found")
else:
    kuaili_block = match.group(0)
    # Remove it from original
    content = content.replace(kuaili_block, '')
    
    # 2. Find Edge Node block to insert after
    edge_pattern = re.compile(r'(        <!-- Card 3 -->\n        <div class="review-item" style="width: 100%;">\n.*?<h3 class="review-title"><a href="post-detail\.html\?id=edge">边缘节点深度测评：企业级专线与多入口中转分析</a></h3>.*?        </div>\n)', re.DOTALL)
    
    match2 = edge_pattern.search(content)
    if not match2:
        print("Edge Node block not found")
    else:
        edge_block = match2.group(1)
        # Replace edge_block with edge_block + kuaili_block
        # but add an extra newline for neatness
        content = content.replace(edge_block, edge_block + "\n" + kuaili_block.strip("\n") + "\n")
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Successfully moved Kuaili card.")
