import re

with open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

top_match = re.search(r'([\s\S]*?<div class="left-column">)', html)
top_part = top_match.group(1)

bottom_match = re.search(r'(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">[\s\S]*)', html)
bottom_part = bottom_match.group(1)

articles = [
  {
    "date": "2026-08-17",
    "badge": "AI 实用指南",
    "badge_class": "badge-primary",
    "title": "2026 最新Claude AI 完全攻略:注册、桌面应用与玩法全解",
    "link": "post-detail.html?id=claude-ai-jiaocheng-2026",
    "summary": "Anthropic Claude AI 2026 全景教程：模型家族选型（Opus 4.8 / Sonnet 5 / Haiku 4.5 / Fable 5）、100万 Token 上下文窗口、桌面版 MCP 本地连接器、终端 Agent 编程工具 Claude Code，以及中国大陆用户访问线路与干净 IP 避风控指南。"
  },
  {
    "date": "2026-08-16",
    "badge": "协议技术",
    "badge_class": "badge-primary",
    "title": "2026年机场节点协议怎么选？Shadowsocks vs VLESS Reality vs Hysteria 2 vs TUIC 深度对比与科学选型指南",
    "link": "protocol-selection-2026.html",
    "summary": "深入剖析 2026 GFW 最新 DPI 深度包检测与 AI 特征指纹识别演进，科学对比 Shadowsocks 2022、VLESS Reality、Hysteria 2 与 TUIC v5 四大主流协议底层原理、抗封锁能力与三大运营商选型匹配。"
  },
  {
    "date": "2026-08-16",
    "badge": "系统教程",
    "badge_class": "badge-primary",
    "title": "华为鸿蒙怎么装 Google Play?2026 HarmonyOS 谷歌商店安装教程(含纯血鸿蒙)",
    "link": "post-detail.html?id=hongmeng-google-play-2026",
    "summary": "华为鸿蒙安装 Google Play 完全教程：深入解析缺乏 GMS 授权与纯血鸿蒙底层架构，详解华为应用市场官方 GSpace / GBox / 出境易环境容器免 Root 安装配置，含图文指引、消息推送保活与关键排错。"
  },
  {
    "date": "2026-08-15",
    "badge": "教程指南",
    "badge_class": "badge-primary",
    "title": "安卓手机安装 Google Play！2026 谷歌三件套安装保姆级教程(全品牌)",
    "link": "post-detail.html?id=android-google-play-2026",
    "summary": "全面测试 2026 年最新小米、红米、OPPO、vivo、荣耀、一加、真我等品牌系统，总结先查系统自带开关、后免 Root 手动安全安装的完全避坑指引。"
  },
  {
    "date": "2026-08-15",
    "badge": "教程指南",
    "badge_class": "badge-primary",
    "title": "Telegram 怎么注册?2026 国内 TG 注册完整教程(+86 收不到验证码解决方法)",
    "link": "post-detail.html?id=telegram-register-2026",
    "summary": "针对 2026 年最新 Telegram 官方风控机制深度实测，总结出 +86 手机号 100% 成功接收验证码的 4 大破局方案，并提供 iOS / Android / PC 保姆级注册图文指引与账号防封设置。"
  },
  {
    "date": "2026-08-17",
    "badge": "实用资源",
    "badge_class": "badge-primary",
    "title": "2026最新免费美区Apple ID共享账号 | Shadowrocket/小火箭下载 | iOS美区账号每日更新",
    "link": "share-id.html",
    "summary": "每日为您更新最新可用的免费美区 Apple ID 共享账号（今日已更新 30 个可用账号池），无缝下载 Shadowrocket 等各种美区专属应用，避免账号被锁，享受完整的 iOS 生态体验。"
  },
  {
    "date": "2026-08-14",
    "badge": "进阶教程",
    "badge_class": "badge-primary",
    "title": "从零开始注册美区 Apple ID 进阶指南：保姆级注册教程 (2026 最新)",
    "link": "post-detail.html?id=us-apple-id-register-2026",
    "summary": "不用信用卡、无需国外手机号！2026 年最新手把手教你零门槛注册属于自己的纯净美区 Apple ID，解决免税区地址填写、账单地址生成与独立充值购买小火箭教程。"
  },
  {
    "date": "2026-08-12",
    "badge": "排查指南",
    "badge_class": "badge-primary",
    "title": "机场突然连不上？10个原因排查和解决方法",
    "link": "reviews/connection-issues.html",
    "summary": "你有没有遇到过这种情况：昨天还好好用的翻墙机场，今天突然就“罢工”连不上了？本文为你详细梳理2026年最常见的10个连不上原因，并提供针对性的排查和解决方法。"
  },
  {
    "date": "2026-08-11",
    "badge": "高性价比",
    "badge_class": "badge-orange",
    "title": "2026 XXYUN机场评测：9.99元100G老牌BGP专线机场推荐",
    "link": "reviews/xxyun.html",
    "summary": "XXYUN机场怎么样？本文实测XXYUN机场速度、稳定性与流媒体解锁能力，月付仅9.99元享100G流量、全BGP中转+三网优化，老牌运营两年稳定，支持Netflix/Disney+/ChatGPT，附9折优惠券。"
  },
  {
    "date": "2026-08-10",
    "badge": "高性价比",
    "badge_class": "badge-orange",
    "title": "flybit机场评测：15元128G高性价比｜解锁ChatGPT",
    "link": "reviews/flybit.html",
    "summary": "Flybit机场（飞云）以15元128G的超高性价比横空出世，成为2026年机场圈的一匹黑马。本文深度评测其在晚高峰的网络表现、流媒体解锁能力，以及对ChatGPT等原生AI平台的完美支持……"
  },
  {
    "date": "2026-08-08",
    "badge": "IEPL 专线",
    "badge_class": "badge-secondary",
    "title": "速界机场2026 晚高峰稳定性测速测评",
    "link": "post-detail.html?id=speedworld-2026",
    "summary": "作为在2026年受到关注的订阅制节点服务，速界机场主要宣传IEPL国际专线与多端客户端兼容。本次评测从线路质量、套餐资费、节点可用性以及流媒体AI解锁等多个维度进行了客观测评，并深度剖析其防跑路风险建议……"
  },
  {
    "date": "2026-08-05",
    "badge": "直连 / 中转",
    "badge_class": "badge-primary",
    "title": "极连云机场深度测评：全IPLC专线与不限设备的高性价比出海解析",
    "link": "reviews/jilianyun.html",
    "summary": "作为2026年翻墙工具有力新星，极连云采用多线BGP中转。本次评测在晚高峰极限负载期间，针对其网速丢包率、全场景流媒体及前沿AI解锁进行了实操测试，提供真实可靠的对比选购反馈……"
  },
  {
    "date": "2026-08-02",
    "badge": "大带宽 BGP",
    "badge_class": "badge-orange",
    "title": "边缘机场深度测评：企业级专线与多入口中转分析",
    "link": "post-detail.html?id=edge",
    "summary": "从线路质量、套餐价格、节点覆盖、客户端配置、流媒体与AI工具解锁等维度对边缘机场进行深度测评，并提供最新注册优惠与官网链接。"
  },
  {
    "date": "2026-08-02",
    "badge": "BGP 中转",
    "badge_class": "badge-green",
    "title": "快狸机场深度评测",
    "link": "post-detail.html?id=kuaili",
    "summary": "快狸机场是一款性能优秀的平价大带宽中转优化机场，全线搭载原生 Vless 协议，提供极致的数据吞吐上限，支持多设备并发与流媒体/AI工具解锁。"
  },
  {
    "date": "2026-08-01",
    "badge": "新手入门",
    "badge_class": "badge-secondary",
    "title": "2026年稳定高速机场推荐指南",
    "link": "post-detail.html?id=recommend-guide",
    "summary": "新手购买机场前必须知道的避坑常识，包括专线与中转的区别。"
  },
  {
    "date": "2026-07-28",
    "badge": "选型指南",
    "badge_class": "badge-primary",
    "title": "机场怎么选择？教你三步挑出好节点",
    "link": "post-detail.html?id=how-to-choose",
    "summary": "通过本地网络测试、目标用途（看视频还是打游戏）来选择最适合自己的机场。"
  },
  {
    "date": "2026-07-25",
    "badge": "客户端教程",
    "badge_class": "badge-orange",
    "title": "Clash 全平台配置与订阅导入教程",
    "link": "post-detail.html?id=clash-tutorial",
    "summary": "支持 Clash Verge、Clash for Windows、Clash Meta 各分支配置教程。"
  },
  {
    "date": "2026-07-20",
    "badge": "PC专题",
    "badge_class": "badge-green",
    "title": "Windows客户端最佳实践与下载导航",
    "link": "post-detail.html?id=win-client",
    "summary": "盘点 Windows 平台上最好用的代理客户端，从老牌内核到最新内核。"
  }
]

middle_part = '''
      <section class="section">
        <div class="container">
          <div class="section-header">
            <h2>最新文章发布</h2>
            <p>这里收录了本站最新的所有文章与评测，按发布时间从上至下排列。</p>
          </div>
          <div class="reviews-container">
'''

for a in articles:
    middle_part += f'''
            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge {a['badge_class']}">{a['badge']}</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: {a['date']}</span>
                </div>
                <h3 class="review-title"><a href="{a['link']}">{a['title']}</a></h3>
                <p class="review-summary">{a['summary']}</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="{a['link']}" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>
'''

middle_part += '''
          </div>
        </div>
      </section>
    </div> <!-- End Left Column -->
'''

new_html = top_part + middle_part + bottom_part
new_html = new_html.replace('<title>2026年最新机场推荐与网络代理工具指南 - 稳定高速科学上网服务全评测</title>', '<title>最新文章发布 - 2026 机场推荐与网络工具指南</title>')

with open('latest-articles.html', 'w', encoding='utf-8') as f:
    f.write(new_html)

print('build.py completed successfully!')
