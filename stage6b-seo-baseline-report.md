# 云梯指南 Stage 6B SEO 基线审计报告

## 1. 网站索引概况

由于当前环境没有 Google Search Console 或 Bing Webmaster Tools API 的直接访问权限，**真实搜索数据无法在本地系统直接读取**。必须由人工登录相应后台获取。根据现存页面，本站上线的主要页面约在 40 篇左右，待验证其真实被索引比例。目前无法确认真实收录页面数量。

## 2. Sitemap 状态

*   **Sitemap URL 数量**：34 个
*   **是否存在问题**：**严重警告**！Sitemap 生成的 URL 全都包含了本地绝对路径（如 `https://nodehub168.com/C:/Users/PC/Desktop/落地页/nodehub168.com/ai/chatgpt-guide.html`）。这些均是不存在的 404 URL。
*   **动作建议**：必须在下一阶段首要修正 Sitemap 生成脚本中的路径错误，并重新提交 Sitemap。本阶段遵守禁止修改原则，未执行替换。

## 3. robots 状态

*   **是否可访问**：`robots.txt` 存在且格式正确。
*   **拦截情况**：`Allow: /` 和 `Disallow: /backup/`，未发现误封文章目录或首页。
*   **Sitemap 指向**：正确指向 `https://nodehub168.com/sitemap.xml`。

## 4. Stage 6A 三篇文章状态

1.  `/tutorials/clash-verge-config.html`
2.  `/tutorials/clash-verge-import-config.html`
3.  `/help/clash-verge-node-failed.html`

*   **HTTP Status**：线上可访问 (200 OK 预期)
*   **Canonical**：**警告**。这三个页面的 `<link rel="canonical">` 依然继承了模板的设定，全都错误指向了 `https://nodehub168.com/tutorials/clash-verge-guide.html`。这会导致爬虫将这三个页面的权重折叠到 Guide 页，从而无法获得独立排名。
*   **Title/H1**：均已匹配并注入真实的特定长尾词。
*   **Description/Schema**：大部分信息准确，但 Schema 内部的数据也一定程度上继承了 Guide 页面的旧数据。
*   **内部链接**：内容包含有效的同类推荐内链，但整体上缺少指向总 Hub 的上层内链。
*   **Sitemap 收录**：受上述 Sitemap 本地路径 bug 的影响，目前这三篇均未被正确放进 Sitemap 提交列表。

## 5. Google Search Console 数据

**Google Search Console 数据当前不可直接读取。**
*需要人工查看：登录 GSC 后台 -> Performance 报表读取最近 3 / 7 / 14 / 28 天的 Clicks, Impressions, CTR, Average Position 等数据。*

## 6. Bing Webmaster 数据

**Bing Webmaster 数据当前不可直接读取。**
*需要人工查看：登录 BWT 后台 -> Search Performance 等图表读取。*

## 7. Top Queries

**当前不可直接读取。** 预期可能出现：机场推荐、Clash Verge 教程、节点连接失败等长尾词。

## 8. Top Pages

**当前不可直接读取。** 预计流量主要集中在首页及各类入门教程（如 Clash 教程全集）。

## 9. Clash Verge Cluster 分析

*   存在关键词内耗：`/tutorials/clash-verge-config.html` 与 `/tutorials/clash-verge-import-config.html` 内容与意图高度重叠。
*   Hub 页 `/tutorials/clash-verge-guide.html` 缺乏强有力的面包屑和正文内链引导。
*   详情见 `content/clash-verge-cluster-audit.md`。

## 10. 关键词机会

*详情见 `content/opportunity-keywords.json`。目前侧重于发现无专门页面覆盖的长尾痛点词（如 timeout 报错）。*

## 11. 页面优化机会

*   **立即优化**：待 GSC 数据补全后识别高曝光页面并优化 CTR。
*   **需要补强**：在排名落后的页面中添加富文本和相关推荐链接。
*   *详情见 `content/content-opportunity-report.md`*。

## 12. 当前最大 SEO 问题

1.  **Sitemap.xml 的本地绝对路径 Bug**：导致搜索引擎无法通过 Sitemap 找到真实页面。
2.  **长尾文章的 Canonical 标签错误指向 Hub 模板**：会导致搜索引擎误判页面为副本而不予单独收录。
3.  **Schema 继承残留**：文章中的 JSON-LD Schema 也残留了模板的 URL 和标题。

## 13. 下一阶段建议

*   优先修复 Sitemap 生成脚本中的路径错误，生成正确的全站 Sitemap，并重新向 GSC/BWT 提交。
*   修复 HTML 模板注入脚本，确保新生成的长尾文章拥有与之匹配的独立 `canonical` 标签、`og:url` 及 Schema 信息。
*   人工提取 GSC/Bing 数据，补全基线表格。
*   建立长效的内链增强机制，确保从内容页有明显通路回到 Hub 页面。
