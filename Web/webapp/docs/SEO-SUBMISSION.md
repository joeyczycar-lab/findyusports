# 搜索引擎提交指南（FY体育）

部署上线后，按下面步骤提交各搜索引擎，便于收录与推广。

---

## 一、确认这两项可访问

在浏览器中打开（把 `你的主域名` 换成实际域名，如 findyusports.com）：

- **robots.txt**  
  `https://你的主域名/robots.txt`  
  应看到 `User-agent: *`、`Allow: /` 和 `Sitemap: https://你的主域名/sitemap.xml`。

- **sitemap**  
  `https://你的主域名/sitemap.xml`  
  应看到 XML 站点地图，包含首页、地图、场地列表、APP 下载等链接。

若有第二个域名，同样访问该域名下的 `/robots.txt` 和 `/sitemap.xml`，会按当前域名自动生成，无需改代码。

---

## 二、百度（必做）

1. 打开 [百度搜索资源平台](https://ziyuan.baidu.com/)，用百度账号登录。
2. 进入 **用户中心 → 站点管理 → 添加网站**。
3. 输入主域名（如 `https://findyusports.com`），选择「站点属性」（如「PC 站」）。
4. 验证站点（三种方式任选其一）：
   - **文件验证**：下载验证文件，放到站点根目录（如 `public/`），保证能访问 `https://你的域名/验证文件名.txt`。
   - **HTML 标签验证**：把给出的 meta 标签放到全站 `<head>` 里（可在 `app/layout.tsx` 的 head 中加）。
   - **CNAME 验证**：按提示在域名 DNS 添加 CNAME 记录。
5. 验证通过后，在 **链接提交** 里：
   - 使用 **普通收录**：提交 sitemap 地址 `https://你的域名/sitemap.xml`。
   - 若有权限，可使用 **快速收录**，提交重要页面 URL（首页、地图页等）。
6. 如有第二个域名，在「站点管理」里再添加该域名并同样验证、提交 sitemap。

---

## 三、搜狗

1. 打开 [搜狗站长平台](https://zhanzhang.sogou.com/)，登录。
2. **添加网站**，填写主域名，按提示完成验证（文件 / 标签 / CNAME 等）。
3. 在 **链接提交** 或 **Sitemap** 中提交：`https://你的域名/sitemap.xml`。
4. 第二个域名同样新增站点并提交 sitemap。

---

## 四、头条搜索（字节）

1. 打开 [头条搜索资源平台](https://zhanzhang.toutiao.com/)（原头条站长平台），登录。
2. **添加站点**，输入主域名，选择验证方式并完成验证。
3. 在 **数据引入 → 链接提交** 中提交 sitemap：`https://你的域名/sitemap.xml`。
4. 第二个域名同样添加并提交。

---

## 五、必应 Bing（可选，对国际用户有帮助）

1. 打开 [Bing Webmaster Tools](https://www.bing.com/webmasters)，用微软账号登录。
2. **Add a site**，输入主域名。
3. 按提示验证（DNS 或上传文件等）。
4. 验证通过后，在 **Sitemaps** 中提交 `https://你的域名/sitemap.xml`。

---

## 六、Google（可选，海外用户）

1. 打开 [Google Search Console](https://search.google.com/search-console)。
2. **添加资源**，选择「网址前缀」，输入主域名。
3. 用 HTML 文件上传、meta 标签或 DNS 等方式验证。
4. 在 **站点地图** 中提交 `https://你的域名/sitemap.xml`。

---

## 七、提交后建议

| 项目 | 说明 |
|------|------|
| 多域名 | 每个域名单独添加、验证并提交该域名下的 sitemap，不要混用。 |
| 更新频率 | sitemap 已按页面类型设置了 `changeFrequency`，无需每天重复提交。 |
| 主动推送 | 百度/搜狗若开放「主动推送」接口，可对新上线的重要页面（如新城市、新场地列表）做一次推送，加快收录。 |
| 查看收录 | 在搜索引擎里搜 `site:你的域名`，查看已收录页面数量与质量。 |

---

## 八、站内已做的 SEO 支持

- **动态 robots.txt**：`/robots.txt` 按当前访问域名生成，并指向该域名的 `/sitemap.xml`。
- **动态 sitemap**：`/sitemap.xml` 按当前域名生成链接，支持多域名。
- **页面 metadata**：全站 title、description、Open Graph 已配置，且按访问域名生成 canonical/OG url。
- **语义化与结构**：地图、列表、详情页结构清晰，便于抓取。

按上述步骤提交后，一般数天到数周内会开始收录；持续更新内容（如新增场地、城市）并保持链接可访问，有利于长期搜索表现。
