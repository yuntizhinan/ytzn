
## Review Article Formatting Guidelines
When generating new review articles, always use the following template structure to ensure consistency:
1. **Stylesheet**: Always link to ../index.css (not style.css).
2. **Header**: Always use the full <header class="header"> structure with dropdown menus, exactly as seen in index.html or post-detail.html. (Adjust relative paths to ../ since articles are in the eviews/ folder).
3. **Meta Info**: Under the <h1> title, always use the exact .article-meta structure with SVG icons and the following fields: 作者: 云梯指南技术编辑部, 阅读时长:, 发布于:, 更新于:, 阅读量:. This structure can be referenced from post-detail.html.
4. **Background & Layout**: Do not use inline styles on the <article> tag. The background will be managed by index.css globally. Use <article class="post-article">.
