import json
import os
import datetime

def create_stage5_plan():
    plan = {
        "01": {
            "title": "Clash Verge 配置教程：从下载安装到代理规则设置",
            "primary_keyword": "Clash Verge 配置",
            "secondary_keywords": ["Clash Verge 配置教程"],
            "category": "Clash教程",
            "path": "/tutorials/clash-verge-config.html",
            "status": "draft",
            "file": "content/drafts/stage5/clash-verge-config.json"
        },
        "02": {
            "title": "Clash Verge 导入配置教程：如何添加和使用代理配置",
            "primary_keyword": "Clash Verge 导入配置",
            "secondary_keywords": ["Clash Verge 导入订阅"],
            "category": "Clash教程",
            "path": "/tutorials/clash-verge-import-config.html",
            "status": "draft",
            "file": "content/drafts/stage5/clash-verge-import-config.json"
        },
        "03": {
            "title": "Clash Verge 节点连接失败怎么办？常见原因与排查方法",
            "primary_keyword": "Clash Verge 节点失败",
            "secondary_keywords": ["Clash Verge 无法连接"],
            "category": "问题解决",
            "path": "/help/clash-verge-node-failed.html",
            "status": "draft",
            "file": "content/drafts/stage5/clash-verge-node-failed.json"
        },
        "04": {
            "title": "Clash Verge Timeout 怎么解决？连接超时排查指南",
            "primary_keyword": "Clash Verge timeout",
            "secondary_keywords": ["Clash timeout", "代理 timeout"],
            "category": "问题解决",
            "path": "/help/clash-verge-timeout.html",
            "status": "planned"
        },
        "05": {
            "title": "代理节点连接超时怎么办？从 DNS 到网络逐步排查",
            "primary_keyword": "代理连接超时",
            "secondary_keywords": ["节点连接超时", "代理 timeout"],
            "category": "问题解决",
            "path": "/help/proxy-timeout.html",
            "status": "planned"
        },
        "06": {
            "title": "机场节点全部失败怎么办？常见原因与排查步骤",
            "primary_keyword": "机场节点失败",
            "secondary_keywords": ["机场节点不能用", "节点全部失败"],
            "category": "问题解决",
            "path": "/help/airport-node-failed.html",
            "status": "planned"
        },
        "07": {
            "title": "DNS 解析失败怎么办？Windows 下的检查与修复方法",
            "primary_keyword": "DNS解析失败",
            "secondary_keywords": ["DNS无法解析", "Windows DNS"],
            "category": "网络知识",
            "path": "/knowledge/dns-resolution-failed.html",
            "status": "planned"
        },
        "08": {
            "title": "DNS 污染是什么？如何判断是不是 DNS 导致的网站打不开",
            "primary_keyword": "DNS污染",
            "secondary_keywords": ["DNS污染检测", "网站打不开 DNS"],
            "category": "网络知识",
            "path": "/knowledge/dns-pollution.html",
            "status": "planned"
        },
        "09": {
            "title": "ChatGPT 无法访问怎么办？常见网络与浏览器问题排查",
            "primary_keyword": "ChatGPT无法访问",
            "secondary_keywords": ["ChatGPT打不开", "ChatGPT连接失败"],
            "category": "AI工具教程",
            "path": "/ai/chatgpt-cannot-access.html",
            "status": "planned"
        },
        "10": {
            "title": "Gemini 无法访问怎么办？网络、DNS、浏览器问题排查",
            "primary_keyword": "Gemini无法访问",
            "secondary_keywords": ["Gemini打不开", "Gemini连接失败"],
            "category": "AI工具教程",
            "path": "/ai/gemini-cannot-access.html",
            "status": "planned"
        }
    }
    
    os.makedirs('content', exist_ok=True)
    with open('content/stage5-content-plan.json', 'w', encoding='utf-8') as f:
        json.dump(plan, f, ensure_ascii=False, indent=2)

def create_topic_clusters():
    clusters = {
        "Clash Verge": {
            "core": "Clash Verge 使用教程",
            "children": [
                "Clash Verge 下载",
                "Clash Verge 配置",
                "Clash Verge 导入配置",
                "Clash Verge 节点失败",
                "Clash Verge Timeout"
            ]
        },
        "DNS": {
            "core": "什么是 DNS",
            "children": [
                "DNS 解析失败",
                "DNS 污染",
                "DNS 配置"
            ]
        },
        "代理故障": {
            "core": "VPN 和代理区别",
            "children": [
                "代理连接超时",
                "节点失败",
                "机场节点不能用"
            ]
        },
        "AI": {
            "core": "ChatGPT 使用教程",
            "children": [
                "ChatGPT 无法访问",
                "ChatGPT 网络错误"
            ]
        }
    }
    with open('content/topic-clusters.json', 'w', encoding='utf-8') as f:
        json.dump(clusters, f, ensure_ascii=False, indent=2)

def create_drafts():
    os.makedirs('content/drafts/stage5', exist_ok=True)
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    
    draft1 = {
        "title": "Clash Verge 配置教程：从下载安装到代理规则设置",
        "slug": "clash-verge-config",
        "category": "Clash教程",
        "author": "云梯指南编辑部",
        "date": today,
        "newPath": "/tutorials/clash-verge-config.html",
        "content": """
<h2>H1</h2>
<p><strong>摘要：</strong>本文为您提供详细的 Clash Verge 配置教程。从软件界面的初步认识，到代理规则设置，带您一步步完成日常网络代理环境的配置，确保客户端顺畅运行。</p>
<h2>问题背景</h2>
<p>很多用户下载了 Clash Verge 却不知道如何配置其基础功能。基础配置是否合理，直接影响到后续节点连接与代理的稳定性。</p>
<h2>详细步骤</h2>
<ol>
<li>打开 Clash Verge 设置界面。</li>
<li>找到“系统代理” (System Proxy) 开关并开启。</li>
<li>(可选) 开启 TUN 模式，实现全局应用代理。需要 Administrator 或 Root 权限。</li>
<li>进入“配置” (Profiles) 界面进行订阅源管理。</li>
<li>在“代理” (Proxies) 页面选择需要的节点。</li>
</ol>
<h2>常见错误</h2>
<p>端口被占用：检查是否有其他代理软件在运行（如 v2rayN、Clash for Windows）。<br>
未开启系统代理：导致浏览器无法走代理流量。</p>
<h2>验证方法</h2>
<p>在浏览器打开被墙网站（如 Google），观察是否能正常加载。同时可以在 Clash Verge 的日志页 (Logs) 观察连接请求日志。</p>
<h2>FAQ</h2>
<h3>为什么开启系统代理依然无法上网？</h3>
<p>可能因为浏览器安装了诸如 SwitchyOmega 的插件，导致系统代理被覆盖。请检查浏览器扩展。</p>
<h2>总结</h2>
<p>正确配置 Clash Verge 的各项基础开关，是科学上网的第一步，能够显著提升日后的使用体验。</p>
"""
    }

    draft2 = {
        "title": "Clash Verge 导入配置教程：如何添加和使用代理配置",
        "slug": "clash-verge-import-config",
        "category": "Clash教程",
        "author": "云梯指南编辑部",
        "date": today,
        "newPath": "/tutorials/clash-verge-import-config.html",
        "content": """
<h2>H1</h2>
<p><strong>摘要：</strong>本文详细介绍如何在 Clash Verge 中导入订阅链接与本地配置。掌握添加和更新代理配置的方法，是保持机场节点可用性的核心操作。</p>
<h2>问题背景</h2>
<p>购买了机场服务后，商家通常会提供一串订阅地址（Subscription URL）。新手往往不知道如何将此链接加入到 Clash Verge 并使用。</p>
<h2>详细步骤</h2>
<ol>
<li>从您的机场或服务商后台，复制适用于 Clash 的订阅链接 (URL)。</li>
<li>打开 Clash Verge，点击左侧导航栏的“配置” (Profiles)。</li>
<li>在配置页面顶部，将链接粘贴到输入框中。</li>
<li>点击“导入” (Import) 按钮。</li>
<li>等待软件从远端服务器下载配置文件。如果成功，列表中会出现新的配置项。</li>
<li>右键或点击该配置项，选择“使用” (Use)。</li>
</ol>
<h2>常见错误</h2>
<p>导入失败：可能是网络不通，或订阅链接本身已被屏蔽。可以尝试暂时用浏览器代理打开更新，或者向服务商索要备用链接。<br>
配置为空：检查链接格式是否正确，某些机场需要专门提供 Clash 格式的链接而非 SSR 链接。</p>
<h2>验证方法</h2>
<p>导入成功后，前往“代理” (Proxies) 面板，应该能看到按照国家地区或策略组划分的节点列表。对节点进行“测速” (Delay test) 确认可用性。</p>
<h2>FAQ</h2>
<h3>如何自动更新订阅？</h3>
<p>在配置列表项上右键，选择“编辑” (Edit)，可以设置 Update Interval（例如 24 小时），这样软件会在后台自动拉取最新节点。</p>
<h2>总结</h2>
<p>灵活掌握订阅配置的导入和更新，可以应对节点变动和域名失效等突发情况。</p>
"""
    }

    draft3 = {
        "title": "Clash Verge 节点连接失败怎么办？常见原因与排查方法",
        "slug": "clash-verge-node-failed",
        "category": "问题解决",
        "author": "云梯指南编辑部",
        "date": today,
        "newPath": "/help/clash-verge-node-failed.html",
        "content": """
<h2>H1</h2>
<p><strong>摘要：</strong>遇到 Clash Verge 节点连接失败？本文整理了一套系统排查流程。从网络检查、系统时间同步，到协议兼容性，教您一步步找到并解决节点无法连接的问题。</p>
<h2>问题背景</h2>
<p>明明成功导入了节点，测速也正常，但浏览器就是无法打开目标网页，日志显示节点连接失败 (Connection Failed)。这是新手最常遇到的挫败感来源。</p>
<h2>解决方法</h2>
<ol>
<li><strong>确认本地网络是否正常：</strong>首先关闭 Clash Verge 的系统代理，尝试打开本地网络（如百度），如果也打不开，说明是本地网络故障。</li>
<li><strong>检查系统时间：</strong>Clash Verge 中常用的 VMess、VLESS 协议对时间要求极其严格。请务必将电脑或手机的系统时间与互联网时间同步（误差不能超过 1 分钟）。</li>
<li><strong>检查节点状态：</strong>进入“代理”面板，点击小闪电图标进行测速。如果全部飘红 (Timeout)，则可能是节点配置本身已失效或机场服务端宕机。</li>
<li><strong>检查系统代理是否被劫持：</strong>浏览器里是否开启了类似 SwitchyOmega 的插件？如果有，请检查其设置或暂时禁用。</li>
<li><strong>查看内核日志：</strong>进入“日志” (Logs) 面板，查看报错信息。如果出现 `read: connection reset by peer`，往往代表节点被墙或协议被阻断。</li>
<li><strong>更换其他节点：</strong>很多时候只是单一节点被封锁或负载过高，尝试切换到其他国家节点测试。</li>
</ol>
<h2>常见错误</h2>
<p>未同步时间是导致 VMess 协议全部失效的最常见原因。很多人在排查了半天网络后才发现是时间误差导致。<br>
另外，如果使用的是 Clash Meta 内核，但导入了纯旧版 Clash 不支持的协议配置，也会导致连接静默失败。</p>
<h2>验证方法</h2>
<p>排查完成后，重启 Clash Verge 并重新开启系统代理。访问 Google 测试网络连通性。如果依然不行，可以尝试开启 TUN 模式进一步确认是否为应用层路由问题。</p>
<h2>FAQ</h2>
<h3>为什么手机连同一个 WIFI 能用，电脑却节点失败？</h3>
<p>大概率是电脑的系统代理设置卡住了（Windows 常见 Bug），或电脑安装了其他冲突的软件（如杀毒软件、防火墙拦截）。</p>
<h2>总结</h2>
<p>遇到节点连接失败不要慌，遵循“本地网络 -> 系统时间 -> 代理插件 -> 节点可用性”的顺序逐步排查，通常能解决 90% 的连接问题。</p>
"""
    }

    with open('content/drafts/stage5/clash-verge-config.json', 'w', encoding='utf-8') as f:
        json.dump(draft1, f, ensure_ascii=False, indent=2)
    with open('content/drafts/stage5/clash-verge-import-config.json', 'w', encoding='utf-8') as f:
        json.dump(draft2, f, ensure_ascii=False, indent=2)
    with open('content/drafts/stage5/clash-verge-node-failed.json', 'w', encoding='utf-8') as f:
        json.dump(draft3, f, ensure_ascii=False, indent=2)

create_stage5_plan()
print("Created content/stage5-content-plan.json")
create_topic_clusters()
print("Created content/topic-clusters.json")
create_drafts()
print("Created 3 drafts in content/drafts/stage5/")
