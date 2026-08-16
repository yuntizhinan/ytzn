$html = Get-Content 'index.html' -Raw -Encoding UTF8
$topMatch = [regex]::Match($html, '(?s)(.*?<div class="left-column">)')
$topPart = $topMatch.Groups[1].Value
$bottomMatch = [regex]::Match($html, '(?s)(<!-- RIGHT STICKY COLUMN -->\s*<aside class="right-column">.*)')
$bottomPart = $bottomMatch.Groups[1].Value

$middlePart = @"
      <section class="section">
        <div class="container">
          <div class="section-header">
            <h2>最新文章发布</h2>
            <p>这里收录了本站最新的所有文章与评测，按发布时间从上至下排列。</p>
          </div>
          <div class="reviews-container">

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-primary">系统教程</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-16</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=hongmeng-google-play-2026">华为鸿蒙怎么装 Google Play?2026 HarmonyOS 谷歌商店安装教程(含纯血鸿蒙)</a></h3>
                <p class="review-summary">华为鸿蒙安装 Google Play 完全教程：深入解析缺乏 GMS 授权与纯血鸿蒙底层架构，详解华为应用市场官方 GSpace / GBox / 出境易环境容器免 Root 安装配置，含图文指引、消息推送保活与关键排错。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=hongmeng-google-play-2026" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-orange">高性价比</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-11</span>
                </div>
                <h3 class="review-title"><a href="reviews/xxyun.html">2026 XXYUN机场评测：9.99元100G老牌BGP专线机场推荐</a></h3>
                <p class="review-summary">XXYUN机场怎么样？本文实测XXYUN机场速度、稳定性与流媒体解锁能力，月付仅9.99元享100G流量、全BGP中转+三网优化，老牌运营两年稳定，支持Netflix/Disney+/ChatGPT，附9折优惠券。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="reviews/xxyun.html" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-orange">高性价比</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-10</span>
                </div>
                <h3 class="review-title"><a href="reviews/flybit.html">flybit机场评测：15元128G高性价比｜解锁ChatGPT</a></h3>
                <p class="review-summary">Flybit机场（飞云）以15元128G的超高性价比横空出世，成为2026年机场圈的一匹黑马。本文深度评测其在晚高峰的网络表现、流媒体解锁能力，以及对ChatGPT等原生AI平台的完美支持……</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="reviews/flybit.html" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-secondary">IEPL 专线</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-08</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=speedworld-2026">速界机场2026 晚高峰稳定性测速测评</a></h3>
                <p class="review-summary">作为在2026年受到关注的订阅制节点服务，速界机场主要宣传IEPL国际专线与多端客户端兼容。本次评测从线路质量、套餐资费、节点可用性以及流媒体AI解锁等多个维度进行了客观测评，并深度剖析其防跑路风险建议……</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=speedworld-2026" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-primary">直连 / 中转</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-05</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=jilianyun-2026">极连云机场深度测评：全IPLC专线与不限设备的高性价比出海解析</a></h3>
                <p class="review-summary">作为2026年翻墙工具有力新星，极连云采用多线BGP中转。本次评测在晚高峰极限负载期间，针对其网速丢包率、全场景流媒体及前沿AI解锁进行了实操测试，提供真实可靠的对比选购反馈……</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=jilianyun-2026" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-orange">大带宽 BGP</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-02</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=edge">边缘机场深度测评：企业级专线与多入口中转分析</a></h3>
                <p class="review-summary">从线路质量、套餐价格、节点覆盖、客户端配置、流媒体与AI工具解锁等维度对边缘机场进行深度测评，并提供最新注册优惠与官网链接。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=edge" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-green">BGP 中转</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-02</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=kuaili">快狸机场深度评测</a></h3>
                <p class="review-summary">快狸机场是一款性能优秀的平价大带宽中转优化机场，全线搭载原生 Vless 协议，提供极致的数据吞吐上限，支持多设备并发与流媒体/AI工具解锁。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=kuaili" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-secondary">新手入门</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-08-01</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=recommend-guide">2026年稳定高速机场推荐指南</a></h3>
                <p class="review-summary">新手购买机场前必须知道的避坑常识，包括专线与中转的区别。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=recommend-guide" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-primary">选型指南</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-07-28</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=how-to-choose">机场怎么选择？教你三步挑出好节点</a></h3>
                <p class="review-summary">通过本地网络测试、目标用途（看视频还是打游戏）来选择最适合自己的机场。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=how-to-choose" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-orange">客户端教程</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-07-25</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=clash-tutorial">Clash 全平台配置与订阅导入教程</a></h3>
                <p class="review-summary">支持 Clash Verge、Clash for Windows、Clash Meta 各分支配置教程。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=clash-tutorial" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

            <div class="review-item" style="width: 100%;">
              <div class="review-info">
                <div class="review-meta">
                  <span class="badge badge-green">PC专题</span>
                  <span style="font-size: 0.85rem; color: var(--text-muted);">发布时间: 2026-07-20</span>
                </div>
                <h3 class="review-title"><a href="post-detail.html?id=win-client">Windows客户端最佳实践与下载导航</a></h3>
                <p class="review-summary">盘点 Windows 平台上最好用的代理客户端，从老牌内核到最新内核。</p>
              </div>
              <div class="review-actions" style="align-self: flex-start; margin-top: 1rem;">
                <a href="post-detail.html?id=win-client" class="btn btn-outline" style="padding: 0.6rem 1.2rem; font-size: 0.85rem;">阅读全文</a>
              </div>
            </div>

          </div>
        </div>
      </section>
    </div> <!-- End Left Column -->
"@

$newHtml = $topPart + $middlePart + $bottomPart
$newHtml = $newHtml -replace '<title>2026 机场推荐与网络工具指南 - 稳定高速的科学上网网络服务推荐</title>', '<title>最新文章发布 - 2026 机场推荐与网络工具指南</title>'

Set-Content -Path 'latest-articles.html' -Value $newHtml -Encoding UTF8
Write-Host "Created latest-articles.html successfully"
