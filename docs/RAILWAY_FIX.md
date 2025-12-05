# Railway 部署错误修复指南

## 问题
Railway 在构建根目录而不是 `Server/api` 目录，导致找不到 Node.js 应用。

## 解决方案

### 方法一：在 Railway 设置中配置 Root Directory

**如果找不到 Root Directory 设置，请使用方法二（配置文件）**

1. **登录 Railway**
   - 访问 https://railway.app
   - 进入你的项目

2. **查找 Root Directory 设置**
   - 点击项目中的服务（Service）
   - 点击 "Settings" 标签
   - 向下滚动查找 "Root Directory" 或 "Working Directory"
   - 如果找不到，说明 Railway UI 已更新，请使用方法二

3. **设置 Root Directory**
   - 输入：`Server/api`
   - 保存设置

4. **重新部署**
   - Railway 会自动触发新的部署
   - 或者手动点击 "Redeploy"

### 方法二：使用 railway.json 配置文件（推荐，最简单）

**已创建 `railway.json` 文件，格式如下：**

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "root": "Server/api"
}
```

**Railway 会自动识别这个配置文件，无需手动设置！**

只需：
1. 确保 `railway.json` 已推送到 GitHub
2. Railway 会自动检测并应用配置
3. 等待重新部署完成

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

