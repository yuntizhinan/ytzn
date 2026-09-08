import json
import os
import re

def create_keyword_map():
    with open('full_articles_parsed.json', 'r', encoding='utf-8') as f:
        articles = json.load(f)
    
    keyword_map = []
    
    # Process existing articles
    for a in articles:
        # Determine main intent based on title
        title = a['title']
        keyword = title.replace(' - 云梯指南', '').replace('教程', '').replace('指南', '').strip()
        kw_entry = {
            "keyword": keyword,
            "intent": "informational",
            "primary_url": a['newPath'],
            "category": a['category'],
            "priority": "medium",
            "status": "published",
            "secondary_keywords": [],
            "related_urls": []
        }
        # simple heuristic for intent
        if "机场" in title or "测评" in title or "云" in title:
            kw_entry["intent"] = "commercial"
            kw_entry["priority"] = "high"
        elif "下载" in title or "配置" in title or "教程" in title:
            kw_entry["intent"] = "navigational"
            kw_entry["priority"] = "high"
            
        keyword_map.append(kw_entry)
    
    # Add the new 10 keywords from Stage 5 plan
    stage5_keywords = [
        {"keyword": "Clash Verge 配置", "intent": "informational", "primary_url": "/tutorials/clash-verge-config.html", "category": "Clash教程", "priority": "high", "status": "planned", "secondary_keywords": ["Clash Verge 配置教程"]},
        {"keyword": "Clash Verge 导入配置", "intent": "informational", "primary_url": "/tutorials/clash-verge-import-config.html", "category": "Clash教程", "priority": "high", "status": "planned", "secondary_keywords": ["Clash Verge 导入订阅"]},
        {"keyword": "Clash Verge 节点失败", "intent": "informational", "primary_url": "/help/clash-verge-node-failed.html", "category": "问题解决", "priority": "high", "status": "planned", "secondary_keywords": ["Clash Verge 无法连接"]},
        {"keyword": "Clash Verge timeout", "intent": "informational", "primary_url": "/help/clash-verge-timeout.html", "category": "问题解决", "priority": "high", "status": "planned", "secondary_keywords": ["Clash timeout", "代理 timeout"]},
        {"keyword": "代理连接超时", "intent": "informational", "primary_url": "/help/proxy-timeout.html", "category": "问题解决", "priority": "high", "status": "planned", "secondary_keywords": ["节点连接超时", "代理 timeout"]},
        {"keyword": "机场节点失败", "intent": "informational", "primary_url": "/help/airport-node-failed.html", "category": "问题解决", "priority": "high", "status": "planned", "secondary_keywords": ["机场节点不能用", "节点全部失败"]},
        {"keyword": "DNS解析失败", "intent": "informational", "primary_url": "/knowledge/dns-resolution-failed.html", "category": "网络知识", "priority": "medium", "status": "planned", "secondary_keywords": ["DNS无法解析", "Windows DNS"]},
        {"keyword": "DNS污染", "intent": "informational", "primary_url": "/knowledge/dns-pollution.html", "category": "网络知识", "priority": "medium", "status": "planned", "secondary_keywords": ["DNS污染检测", "网站打不开 DNS"]},
        {"keyword": "ChatGPT无法访问", "intent": "informational", "primary_url": "/ai/chatgpt-cannot-access.html", "category": "AI工具教程", "priority": "high", "status": "planned", "secondary_keywords": ["ChatGPT打不开", "ChatGPT连接失败"]},
        {"keyword": "Gemini无法访问", "intent": "informational", "primary_url": "/ai/gemini-cannot-access.html", "category": "AI工具教程", "priority": "high", "status": "planned", "secondary_keywords": ["Gemini打不开", "Gemini连接失败"]},
    ]
    
    keyword_map.extend(stage5_keywords)
    
    os.makedirs('content', exist_ok=True)
    with open('content/keyword-map.json', 'w', encoding='utf-8') as f:
        json.dump(keyword_map, f, ensure_ascii=False, indent=2)

create_keyword_map()
print("Created content/keyword-map.json")
