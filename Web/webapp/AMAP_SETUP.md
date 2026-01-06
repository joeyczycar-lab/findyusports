# 高德地图配置指南

## 1. 获取高德地图 API Key

1. 访问 [高德开放平台](https://console.amap.com/)
2. 登录/注册账号
3. 进入"应用管理" → "我的应用"
4. 点击"创建新应用"
5. 填写应用信息：
   - 应用名称：场地发现平台
   - 应用类型：Web端（JS API）
6. 添加 Key：
   - 点击"添加"按钮
   - Key名称：Web JS API Key
   - 服务平台：**Web端（JS API）** ⚠️ 必须选择这个
   - 白名单：可以暂时留空（开发阶段），生产环境建议配置域名白名单
7. 提交后，复制生成的 Key

## 2. 配置本地开发环境

### 方法一：创建 `.env.local` 文件（推荐）

在 `Web/webapp` 目录下创建 `.env.local` 文件：

```bash
# 高德地图 API Key
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key

# 后端 API 地址
NEXT_PUBLIC_API_BASE=http://localhost:4000
```

### 方法二：使用示例文件

```bash
cd Web/webapp
copy .env.local.example .env.local
# 然后编辑 .env.local，填入你的 Key
```

⚠️ **重要**：`.env.local` 文件已添加到 `.gitignore`，不会被提交到 Git。

## 3. 配置 Vercel 生产环境

1. 登录 [Vercel](https://vercel.com)
2. 进入 `findyusports` 项目
3. 点击 "Settings" → "Environment Variables"
4. 添加以下环境变量：

   | Key | Value | 环境 |
   |-----|-------|------|
   | `NEXT_PUBLIC_AMAP_KEY` | 你的高德地图Key | Production, Preview, Development |
   | `NEXT_PUBLIC_API_BASE` | 你的后端地址 | Production, Preview, Development |

5. 保存后，Vercel 会自动重新部署

## 4. 验证配置

### 本地验证

1. 启动开发服务器：
   ```bash
   cd Web/webapp
   npm run dev
   ```

2. 访问添加场地页面：http://localhost:3000/admin/add-venue

3. 检查地图是否正常加载：
   - ✅ 如果看到地图，说明配置成功
   - ❌ 如果看到"地图加载失败"或"Missing NEXT_PUBLIC_AMAP_KEY"，说明配置有问题

### 生产环境验证

1. 访问：https://findyusports.com/admin/add-venue
2. 检查地图是否正常加载
3. 打开浏览器开发者工具（F12），查看 Console 是否有错误

## 5. 常见问题

### Q: 地图显示"加载失败"
**A:** 检查：
- `.env.local` 文件是否存在且包含 `NEXT_PUBLIC_AMAP_KEY`
- Key 是否正确（没有多余空格）
- Key 类型是否为"Web端（JS API）"
- 重启开发服务器（修改 `.env.local` 后需要重启）

### Q: 生产环境地图不显示
**A:** 检查：
- Vercel 环境变量是否已配置
- 环境变量是否选择了正确的环境（Production）
- 是否已重新部署（修改环境变量后需要重新部署）

### Q: 提示"Invalid Key"
**A:** 可能原因：
- Key 类型错误（必须是"Web端（JS API）"）
- Key 已过期或被禁用
- 域名白名单限制（生产环境需要配置域名白名单）

### Q: 如何配置域名白名单
**A:** 
1. 登录高德开放平台
2. 进入"应用管理" → 找到你的应用
3. 点击 Key 右侧的"设置"
4. 在"服务平台"中，找到"Web端（JS API）"
5. 添加域名白名单：
   - 开发环境：`localhost:3000`
   - 生产环境：`findyusports.com`、`*.vercel.app`（如果使用 Vercel）

## 6. 高德地图服务说明

本项目使用的高德地图服务：
- **Web JS API v2.0**：用于地图显示和交互
- **插件**：
  - `AMap.Geolocation`：定位服务
  - `AMap.ToolBar`：地图工具栏
  - `AMap.MarkerCluster`：标记聚合（用于地图页面）

## 7. 相关文件

- `src/lib/amapLoader.ts`：高德地图加载器
- `src/components/LocationPicker.tsx`：地图位置选择组件
- `src/components/MapView.tsx`：地图视图组件




















