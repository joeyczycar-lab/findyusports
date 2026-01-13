# 检查 Railway OSS 配置

## 🔍 如何检查 Railway 上的 OSS 配置

### 方法 1：查看 Railway 部署日志

1. 登录 [Railway Dashboard](https://railway.app)
2. 进入项目 → API 服务 → **"Deployments"** 标签
3. 点击最新的部署
4. 在日志中搜索 `OSS` 或 `oss`

**应该看到以下信息之一：**

#### ✅ OSS 已正确配置：
```
🔐 [OSS] 初始化 OSS 服务...
🔐 [OSS] OSS_ACCESS_KEY_ID: LTAI5tA... (已设置)
🔐 [OSS] OSS_ACCESS_KEY_SECRET: 已设置
🔐 [OSS] OSS_REGION: oss-cn-hangzhou
🔐 [OSS] OSS_BUCKET: venues-images
✅ [OSS] OSS 客户端初始化成功
```

#### ❌ OSS 未配置：
```
🔐 [OSS] 初始化 OSS 服务...
🔐 [OSS] OSS_ACCESS_KEY_ID: 未设置
🔐 [OSS] OSS_ACCESS_KEY_SECRET: 未设置
⚠️ [OSS] OSS 未配置：缺少 OSS_ACCESS_KEY_ID 或 OSS_ACCESS_KEY_SECRET
🔐 [OSS] 初始化完成，客户端状态: ❌ 未初始化
```

### 方法 2：检查 Railway 环境变量

1. 在 Railway Dashboard → API 服务 → **"Variables"** 标签
2. 确认以下变量已添加：

| 变量名 | 是否已配置 | 值示例 |
|--------|-----------|--------|
| `OSS_REGION` | ⬜ | `oss-cn-hangzhou` |
| `OSS_ACCESS_KEY_ID` | ⬜ | `LTAI5tAbCdEfGhIjK1mNpQxX` |
| `OSS_ACCESS_KEY_SECRET` | ⬜ | `3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo` |
| `OSS_BUCKET` | ⬜ | `venues-images` |

### 方法 3：测试图片上传

1. 访问你的网站
2. 登录账号
3. 进入场地编辑页面
4. 尝试上传一张图片

**如果上传失败，查看浏览器控制台的错误信息：**
- `OSS未配置` → Railway 环境变量未设置
- `签名生成失败` → OSS 配置不正确
- `上传失败` → 检查 Bucket 权限

## 🔧 如果 OSS 未配置

### 步骤 1：添加环境变量

1. 在 Railway Dashboard → API 服务 → **"Variables"** 标签
2. 点击 **"+ New Variable"**
3. 依次添加以下变量：

```
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=你的AccessKey_ID
OSS_ACCESS_KEY_SECRET=你的AccessKey_Secret
OSS_BUCKET=venues-images
```

### 步骤 2：等待重新部署

Railway 会自动检测环境变量变化并重新部署（通常需要 1-2 分钟）

### 步骤 3：验证配置

1. 查看新的部署日志
2. 确认看到：`✅ [OSS] OSS 客户端初始化成功`
3. 测试图片上传功能

## 📝 获取 OSS 配置信息

如果你还没有 OSS 配置信息，请参考：
- `OSS_SETUP.md` - 基础配置说明
- `OSS_CONFIG_GUIDE.md` - 详细配置指南
- `QUICK_OSS_SETUP.md` - 快速配置指南

## ✅ 检查清单

- [ ] 已在 Railway Variables 中添加 `OSS_REGION`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_ID`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_SECRET`
- [ ] 已在 Railway Variables 中添加 `OSS_BUCKET`
- [ ] 部署日志显示 `✅ [OSS] OSS 客户端初始化成功`
- [ ] 已测试图片上传功能
- [ ] 上传的图片可以正常显示
