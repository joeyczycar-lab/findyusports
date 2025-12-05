# Railway 部署错误修复指南

## 问题
Railway 在构建根目录而不是 `Server/api` 目录，导致找不到 Node.js 应用。

## 解决方案

### 方法一：在 Railway 设置中配置 Root Directory（推荐）

1. **登录 Railway**
   - 访问 https://railway.app
   - 进入你的项目

2. **配置 Root Directory**
   - 点击项目名称进入项目详情
   - 点击服务（Service）名称进入服务设置
   - 在 "Settings" 标签页中找到 "Root Directory"
   - 设置为：`Server/api`
   - 保存设置

3. **重新部署**
   - Railway 会自动触发新的部署
   - 或者手动点击 "Redeploy"

### 方法二：使用 railway.json 配置文件

在仓库根目录创建 `railway.json` 文件（已创建，见下方）

---

## 验证

部署成功后，你应该看到：
- ✅ 构建成功
- ✅ 服务运行中
- ✅ 获得后端地址（如 `https://xxx.up.railway.app`）

## 下一步

部署成功后：
1. 运行数据库迁移：`railway run npm run migration:run`
2. 运行种子数据：`railway run npm run seed`
3. 获取后端地址，配置到 Vercel 的 `NEXT_PUBLIC_API_BASE`

