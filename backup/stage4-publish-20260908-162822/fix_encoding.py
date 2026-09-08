import re

with open("post-detail.html", "r", encoding="utf-8") as f:
    text = f.read()

# Extract the block for claude-ai-jiaocheng-2026
pattern = re.compile(r"('claude-ai-jiaocheng-2026': \{.*?\},)", re.DOTALL)
match = pattern.search(text)
if not match:
    print("Not found")
    exit(1)

garbled = match.group(1)

# Try to fix the encoding
def fix_encoding(s):
    try:
        # It was originally UTF-8, read as GBK, then saved as UTF-8.
        # So the bytes of GBK were encoded to UTF-8.
        # We need to encode to GBK (to get the bytes), then decode as UTF-8.
        # Since some characters might not perfectly map back due to lossy GBK conversion, 
        # we might need to use errors='ignore' or 'replace'.
        return s.encode('gbk', errors='ignore').decode('utf-8', errors='ignore')
    except Exception as e:
        print("Error:", e)
        return s

fixed = fix_encoding(garbled)

# Let's print a sample to see if it worked
print(fixed[:200])

