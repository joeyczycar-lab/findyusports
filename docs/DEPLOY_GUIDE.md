# 网站完整部署指南

## 当前问题

Vercel 账户显示"访问受限"，可能无法部署 Next.js 应用。

## 解决方案

### 方案 A：使用 Netlify（推荐，免费且简单）

#### 1. 注册 Netlify
- 访问 https://www.netlify.com
- 使用 GitHub 账号登录

#### 2. 导入项目
1. 点击 "Add new site" → "Import an existing project"
2. 选择仓库：`joeyczycar-lab/findyusports`
3. 配置：
   - **Base directory**: `Web/webapp`
   - **Build command**: `npm run build`
   - **Publish directory**: `.next`

#### 3. 配置环境变量
在 Netlify 项目设置 → Environment variables 添加：
```
NEXT_PUBLIC_API_BASE=https://你的后端地址.up.railway.app
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key
```

#### 4. 部署
- 点击 "Deploy site"
- 等待构建完成
- 获得域名：`https://your-site.netlify.app`

#### 5. 配置自定义域名
- 项目设置 → Domain management
- 添加 `findyusports.com`
- 按提示配置 DNS

---

### 方案 B：使用 Cloudflare Pages（免费，全球 CDN）

#### 1. 注册 Cloudflare
- 访问 https://pages.cloudflare.com
- 使用 GitHub 账号登录

#### 2. 创建项目
1. 点击 "Create a project"
2. 连接 GitHub 仓库
3. 配置：
   - **Framework preset**: Next.js
   - **Build command**: `npm run build`
   - **Build output directory**: `.next`
   - **Root directory**: `Web/webapp`

#### 3. 配置环境变量
在项目设置 → Environment variables 添加：
```
NEXT_PUBLIC_API_BASE=https://你的后端地址.up.railway.app
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key
```

---

### 方案 C：解决 Vercel 账户问题

#### 1. 检查账户状态
- 登录 Vercel → Settings
- 确认邮箱已验证
- 检查 Billing 页面，确认是 Hobby（免费）计划

#### 2. 尝试重新连接
- 删除当前项目
- 重新导入项目
- 确保 Root Directory 设置为 `Web/webapp`

#### 3. 联系支持
- 访问 https://vercel.com/support
- 说明账户限制问题

---

## 后端部署（必需）

无论前端用哪个平台，都需要先部署后端：

### 使用 Railway 部署后端

#### 1. 注册 Railway
- 访问 https://railway.app
- 使用 GitHub 账号登录

#### 2. 创建项目
1. 点击 "New Project"
2. 选择 "Deploy from GitHub repo"
3. 选择仓库，路径选择 `Server/api`

#### 3. 添加数据库
1. 在项目中点击 "+ New"
2. 选择 "Database" → "Add PostgreSQL"
3. Railway 会自动创建并注入 `DATABASE_URL`

#### 4. 配置环境变量
在 Railway 项目设置 → Variables 添加：
```
PORT=4000
DATABASE_URL=${{DATABASE_URL}}
DB_SSL=true
JWT_SECRET=你的随机密钥（至少32字符）
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=你的阿里云AccessKey
OSS_ACCESS_KEY_SECRET=你的阿里云Secret
OSS_BUCKET=venues-images
OSS_HOTLINK_SECRET=你的随机字符串
```

#### 5. 运行数据库迁移
部署完成后，在 Railway 的 Deployments 中打开 Shell，运行：
```bash
npm run migration:run
npm run seed
```

#### 6. 获取后端地址
- Railway 会自动分配域名，如：`https://your-api.up.railway.app`
- 记下这个地址，用于前端环境变量

---

## 完整部署流程

1. ✅ **部署后端到 Railway**
   - 创建项目
   - 添加数据库
   - 配置环境变量
   - 运行迁移

2. ✅ **部署前端到 Netlify/Cloudflare/Vercel**
   - 导入项目
   - 配置环境变量（包含后端地址）
   - 部署

3. ✅ **配置域名**
   - 在 DNS 服务商添加 CNAME 记录
   - 指向部署平台提供的地址

4. ✅ **测试功能**
   - 访问网站
   - 测试地图、列表、详情等功能

---

## 推荐顺序

1. **先部署后端**（Railway）- 必需
2. **再部署前端**（Netlify 推荐）- 必需
3. **配置域名** - 可选但推荐
4. **测试功能** - 必需

---

## 需要帮助？

告诉我你想用哪个平台，我可以提供更详细的步骤指导。


