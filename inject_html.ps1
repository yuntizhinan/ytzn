$indexHtml = Get-Content 'index.html' -Raw -Encoding UTF8

$indexHtmlInjection = @"
        <!-- Content Clash Verge Config -->
        <div class="content-card">
          <span class="badge badge-primary content-card-tag">系统教程</span>
          <h3><a href="/tutorials/clash-verge-config.html">Clash Verge 配置教程：系统代理、规则与故障排除</a></h3>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1rem;">本文为您提供详细的 Clash Verge 配置教程。重点讲解系统代理、TUN 模式以及规则、Proxies、Rules 和 DNS 的设置与排查常见不通问题。</p>
          <div class="content-card-footer">
            <span>2026-09-09</span>
            <a href="/tutorials/clash-verge-config.html" class="content-card-more">
              阅读全文
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </a>
          </div>
        </div>

        <!-- Content Clash Verge Import -->
        <div class="content-card">
          <span class="badge badge-primary content-card-tag">系统教程</span>
          <h3><a href="/tutorials/clash-verge-import-config.html">Clash Verge 导入配置教程：如何添加和使用代理配置</a></h3>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1rem;">本文详细介绍如何在 Clash Verge 中导入订阅链接与本地配置文件，以及解决部分节点连接错误的基础。</p>
          <div class="content-card-footer">
            <span>2026-09-09</span>
            <a href="/tutorials/clash-verge-import-config.html" class="content-card-more">
              阅读全文
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </a>
          </div>
        </div>

        <!-- Content Clash Verge Node Failed -->
        <div class="content-card">
          <span class="badge badge-secondary content-card-tag">故障排查</span>
          <h3><a href="/help/clash-verge-node-failed.html">Clash Verge 节点连接失败怎么办？常见原因与排查方案</a></h3>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1rem;">系统性的 Clash Verge 节点失败（Timeout）排查指南。从基础检查、系统冲突到日志排查。</p>
          <div class="content-card-footer">
            <span>2026-09-09</span>
            <a href="/help/clash-verge-node-failed.html" class="content-card-more">
              阅读全文
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </a>
          </div>
        </div>
"@

if ($indexHtml -notmatch "Clash Verge 配置教程：系统代理") {
    $indexHtml = $indexHtml -replace '(<div class="content-grid">\s*)', "`$1`n$indexHtmlInjection`n"
    Set-Content 'index.html' -Value $indexHtml -Encoding UTF8
    Write-Host "Injected into index.html"
}

$latestHtml = Get-Content 'latest-articles.html' -Raw -Encoding UTF8
$reviewsHtml = Get-Content 'reviews.html' -Raw -Encoding UTF8

$reviewsInjection = @"
            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-primary">系统教程</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-09-09</span>
                </div>
                <h3 class="review-title"><a href="/tutorials/clash-verge-config.html">Clash Verge 配置教程：系统代理、规则与故障排除</a></h3>
                <p class="review-summary">本文为您提供详细的 Clash Verge 配置教程。重点讲解系统代理、TUN 模式以及规则、Proxies、Rules 和 DNS 的设置与排查常见不通问题。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="/tutorials/clash-verge-config.html" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-primary">系统教程</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-09-09</span>
                </div>
                <h3 class="review-title"><a href="/tutorials/clash-verge-import-config.html">Clash Verge 导入配置教程：如何添加和使用代理配置</a></h3>
                <p class="review-summary">本文详细介绍如何在 Clash Verge 中导入订阅链接与本地配置文件，是保持节点可用性的核心步骤，也是解决部分节点连接错误的基础。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="/tutorials/clash-verge-import-config.html" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-secondary">故障排查</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-09-09</span>
                </div>
                <h3 class="review-title"><a href="/help/clash-verge-node-failed.html">Clash Verge 节点连接失败怎么办？常见原因与排查方案</a></h3>
                <p class="review-summary">本文为你提供系统性的 Clash Verge 节点失败（Timeout）排查指南。从基础检查、系统冲突到日志排查，一步步教你定位并解决节点连不上的瓶颈。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="/help/clash-verge-node-failed.html" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>
"@

if ($latestHtml -notmatch "Clash Verge 配置教程：系统代理") {
    $latestHtml = $latestHtml -replace '(<div class="reviews-container">\s*)', "`$1`n$reviewsInjection`n"
    Set-Content 'latest-articles.html' -Value $latestHtml -Encoding UTF8
    Write-Host "Injected into latest-articles.html"
}

if ($reviewsHtml -notmatch "Clash Verge 配置教程：系统代理") {
    $reviewsHtml = $reviewsHtml -replace '(<main class="reviews-container"[^>]*>\s*)', "`$1`n$reviewsInjection`n"
    Set-Content 'reviews.html' -Value $reviewsHtml -Encoding UTF8
    Write-Host "Injected into reviews.html"
}
