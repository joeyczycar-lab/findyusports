# 网站上线检查清单

## 当前状态检查

### 1. Railway 后端检查 ✅/❌

**检查项目：**
- [ ] Railway 项目是否正常运行？
- [ ] 后端 API 地址是什么？（例如：`https://xxx.up.railway.app`）
- [ ] 数据库是否已创建并运行迁移？
- [ ] 环境变量是否已配置完整？

**如何检查：**
1. 登录 https://railway.app
2. 查看项目状态是否为 "Running"
3. 点击项目，查看 "Settings" → "Domains"，获取后端地址
4. 在浏览器访问 `https://你的后端地址/venues`，应该返回 JSON 数据

**如果后端未运行：**
- 检查 Railway 项目的 "Deployments" 标签，查看错误日志
- 确认环境变量已正确配置
- 运行数据库迁移：`railway run npm run migration:run`

---

### 2. Vercel 前端检查 ✅/❌

**检查项目：**
- [ ] Vercel 项目是否显示"访问受限"？
- [ ] 是否有成功的部署记录？
- [ ] 环境变量 `NEXT_PUBLIC_API_BASE` 是否已配置？
- [ ] 环境变量 `NEXT_PUBLIC_AMAP_KEY` 是否已配置？

**如何检查：**
1. 登录 https://vercel.com
2. 进入 `findyusports` 项目
3. 查看 "部署" (Deployments) 标签，是否有成功的部署
4. 查看 "变量" (Variables) 标签，确认环境变量：
   - `NEXT_PUBLIC_API_BASE` = 你的 Railway 后端地址
   - `NEXT_PUBLIC_AMAP_KEY` = 你的高德地图 Key

**如果显示"访问受限"：**
- 这是账户限制问题，需要解决：
  1. 检查 Settings → Billing，确认是 Hobby（免费）计划
  2. 验证邮箱是否已验证
  3. 如果仍受限，考虑使用 Netlify 替代（见下方）

---

### 3. 环境变量配置检查 ✅/❌

**Vercel 需要的环境变量：**

```
NEXT_PUBLIC_API_BASE=https://你的railway后端地址.up.railway.app
NEXT_PUBLIC_AMAP_KEY=你的高德地图Web JS API Key
```

**如何配置：**
1. Vercel 项目 → "变量" (Variables)
2. 添加上述两个环境变量
3. 确保选择 "Production"、"Preview"、"Development" 三个环境
4. 保存后，Vercel 会自动重新部署

---

### 4. 域名配置检查 ✅/❌

**检查项目：**
- [ ] 域名 `findyusports.com` 是否已添加到 Vercel？
- [ ] DNS 记录是否已正确配置？

**如何检查：**
1. Vercel 项目 → "设置" (Settings) → "域名" (Domains)
2. 查看是否已添加 `findyusports.com`
3. 查看 DNS 配置说明

**DNS 配置：**
- 在域名服务商（如阿里云、腾讯云）添加 CNAME 记录
- 主机记录：`@` 或 `www`
- 记录值：Vercel 提供的 CNAME 地址（如 `cname.vercel-dns.com`）

---

### 5. 功能测试 ✅/❌

**测试项目：**
- [ ] 网站首页是否能正常打开？
- [ ] 地图页面是否能正常显示？
- [ ] 场地列表是否能正常加载？
- [ ] 场地详情页是否能正常显示？
- [ ] 搜索和筛选功能是否正常？

**如何测试：**
1. 访问 Vercel 提供的域名（如 `https://findyusports.vercel.app`）
2. 或访问自定义域名（如 `https://findyusports.com`）
3. 逐一测试各项功能

---

## 常见问题解决

### 问题 1：Vercel 显示"访问受限"

**解决方案：**
1. **尝试解决 Vercel 限制：**
   - Settings → Billing → 确认是 Hobby 计划
   - 验证邮箱
   - 联系 Vercel 支持

2. **使用 Netlify 替代（推荐）：**
   - 访问 https://www.netlify.com
   - 导入 GitHub 仓库
   - Base directory: `Web/webapp`
   - 配置环境变量
   - 部署

### 问题 2：网站显示但数据加载失败

**可能原因：**
- `NEXT_PUBLIC_API_BASE` 未配置或配置错误
- Railway 后端未运行
- CORS 问题

**解决方案：**
1. 检查 Vercel 环境变量 `NEXT_PUBLIC_API_BASE`
2. 确认 Railway 后端正常运行
3. 检查浏览器控制台错误信息

### 问题 3：地图无法显示

**可能原因：**
- `NEXT_PUBLIC_AMAP_KEY` 未配置
- 高德地图 Key 配置错误

**解决方案：**
1. 检查 Vercel 环境变量 `NEXT_PUBLIC_AMAP_KEY`
2. 确认高德地图 Key 已启用 Web JS API
3. 检查 Key 的域名白名单设置

---

## 快速诊断命令

### 测试后端 API
```bash
# 在浏览器或命令行测试
curl https://你的railway地址/venues
```

### 检查前端环境变量
访问 Vercel 项目 → "变量" (Variables)，确认已配置。

---

## 完成标准

网站真正上线需要满足：
- ✅ Railway 后端正常运行
- ✅ Vercel 前端成功部署（或使用 Netlify）
- ✅ 环境变量正确配置
- ✅ 域名正确解析
- ✅ 所有功能测试通过

---

## 下一步行动

根据检查结果，告诉我：
1. Railway 后端地址是什么？
2. Vercel 是否还有"访问受限"问题？
3. 环境变量是否已配置？
4. 网站当前能否访问？

我可以帮你解决具体问题！


