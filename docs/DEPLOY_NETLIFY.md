# 使用 Netlify 部署前端指南

## 步骤 1：注册 Netlify

1. 访问 https://www.netlify.com
2. 使用 GitHub 账号登录

## 步骤 2：导入项目

1. 点击 "Add new site" → "Import an existing project"
2. 选择你的 GitHub 仓库 `joeyczycar-lab/findyusports`
3. **Base directory** 设置为 `Web/webapp`
4. **Build command** 设置为 `npm run build`
5. **Publish directory** 设置为 `.next`

## 步骤 3：配置环境变量

在 Netlify 项目设置 → Site settings → Environment variables 中添加：

```
NEXT_PUBLIC_API_BASE=https://你的后端地址.up.railway.app
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key
```

## 步骤 4：配置 Next.js 构建

由于 Netlify 需要特殊配置，创建 `netlify.toml` 文件：

```toml
[build]
  command = "npm run build"
  publish = ".next"

[[plugins]]
  package = "@netlify/plugin-nextjs"
```

## 步骤 5：部署

1. 点击 "Deploy site"
2. Netlify 会自动构建并部署
3. 部署完成后会给你一个域名，如：`https://your-site.netlify.app`

## 步骤 6：配置自定义域名

1. 在 Netlify 项目设置 → Domain management
2. 添加自定义域名 `findyusports.com`
3. 按照提示配置 DNS 记录


