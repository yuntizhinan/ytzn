# Stage 5 URL Normalization & 308 Redirect Diagnosis

## 背景
在 Stage 4.1 的线上验收中，我们观察到所有带有 `.html` 后缀的页面请求均返回了 `308 Permanent Redirect`。
Cloudflare Pages （或类似托管平台）默认开启了 **Clean URLs** 特性。这会导致所有对于 `/path/file.html` 的访问被重定向至 `/path/file`。

## 当前诊断路径演示

以其中一篇新发布文章为例：

- **旧 URL (实际请求路径)**: `https://nodehub168.com/tutorials/clash-verge-guide.html`
- **跳转 (HTTP Status)**: `308 Permanent Redirect`
- **最终 URL (Clean URL)**: `https://nodehub168.com/tutorials/clash-verge-guide`
- **当前代码中 Canonical 指向**: `https://nodehub168.com/tutorials/clash-verge-guide.html`
- **当前 Sitemap 提交的 URL**: `https://nodehub168.com/tutorials/clash-verge-guide.html`

## 理想关系 vs 实际关系

### 理想状态
```text
旧 URL (/abc.html)
   ↓
301/308 重定向
   ↓
正式 URL (/abc)
   ↓
Canonical = 正式 URL (/abc)
   ↓
Sitemap = 正式 URL (/abc)
```

### 实际状态 (当前架构)
```text
旧 URL (/abc.html)
   ↓
308 重定向
   ↓
正式 URL (/abc)
   ↓
Canonical = 旧 URL (/abc.html)  ❌ (不一致)
   ↓
Sitemap = 旧 URL (/abc.html)    ❌ (不一致)
```

## SEO 影响评估

1. **资源损耗与信号冲抵**: 虽然各大搜索引擎（如 Google、Bing）能够成功追踪并解析 308 重定向，但 `<link rel="canonical">` 和 Sitemap 一致性是搜索引擎确立权威版本的关键。目前 Sitemap 和 Canonical 均指向了会发生 308 跳转的源地址，这属于**“重定向循环链条中的自指矛盾”**，会让搜索引擎困惑。
2. **权重稀释**: 长此以往，由于内链（Homepage、Hub 页）仍在使用带 `.html` 的链接，爬虫在网站内部每次抓取都会触发 308 跳转，增加了 Crawl Budget (抓取预算) 的损耗。

## 下一步建议 (第五阶段暂不执行)
在未来阶段（Stage 6或之后），建议执行一次全站级 URL 迁移：
1. 更新底层建站脚本，生成所有路径时不带 `.html` 扩展名。
2. 批量将全站内的所有 `<a href>` 内链中的 `.html` 移除。
3. 更新 `sitemap.xml`，仅输出去后缀的最终 Clean URLs。
4. 在注入 Canonical 标签时，统一移除 `.html`。
5. （本阶段严格遵循禁止大规模修改技术架构及迁移 URL 的指令，仅作记录与诊断。当前 308 跳转仍能保证基本收录与呈现，属于次高优级别的技术债。）
