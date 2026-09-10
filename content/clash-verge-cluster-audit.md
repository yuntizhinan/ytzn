# Clash Verge Cluster Audit

## 1. 现有页面与负责搜索意图

当前有关 Clash Verge 的主要页面：

*   `/tutorials/clash-verge-guide.html` (可能作为 Hub)：Clash Verge 使用教程
*   `/tutorials/clash-verge-download.html`：Clash Verge 下载安装教程
*   `/tutorials/clash-verge-config.html`：Clash Verge 配置教程
*   `/tutorials/clash-verge-import-config.html`：Clash Verge 导入配置教程
*   `/help/clash-verge-node-failed.html`：Clash Verge 节点连接失败怎么办
*   `/tutorials/clash-verge-mac.html`：Clash Verge Mac 版教程
*   `/tutorials/clash-verge-win.html`：Clash Verge Win 版教程

## 2. 关键词内耗分析

目前 `clash-verge-config.html`（配置）和 `clash-verge-import-config.html`（导入配置）在搜索意图上高度重合，用户搜索“Clash Verge 配置”和“导入配置”往往是为了解决同一个订阅节点添加问题。可能会产生内耗。
另外，各平台的专属教程 (`-mac`, `-win`) 和全局的使用教程 (`-guide`) 在“新手如何使用”这个宽泛关键词上也存在一定重叠。

## 3. Hub 页面识别

目前应当以 `/tutorials/clash-verge-guide.html` 作为总的 Hub 页面。
但从现在的架构来看，大部分长尾文章的 Canonical 标签错误指向了 `clash-verge-guide.html`，并且在这些页面之间缺乏明确的层级和面包屑内链回溯到这个特定的 Hub（现在的面包屑回到了“Clash教程”总目录）。

## 4. 缺少内链的页面

*   针对“下载”和“导入配置”，目前仅在相关阅读中相互孤立链接。在各平台专属版本（Win / Mac）之间也缺乏横向引导内链。
*   需要全局增加返回 Hub 页面的富文本内链。

## 5. 可以互相传递权重的页面

*   `/help/clash-verge-node-failed.html` 应该在所有配置/导入配置教程的结尾或 FAQ 处作为内部链接引出。
*   `/tutorials/clash-verge-download.html` 可以作为所有教程的前置步骤链入。

## 6. 是否需要新增内容

目前不需要盲目新增。更需要整合和清晰化已有页面的结构。待真实数据回流后再考虑针对特定长尾词新建页面。
