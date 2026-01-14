# 验证 Railway 上的 OSS 配置

## 🔍 检查步骤

### 步骤 1：查看完整的部署日志

在您提供的日志片段中，我没有看到 OSS 初始化的信息。OSS 模块应该在 `InstanceLoader` 阶段初始化。

**请在 Railway 部署日志中查找：**

1. **查找 InstanceLoader 日志**：
   ```
   [InstanceLoader] OssModule dependencies initialized
   ```
   或
   ```
   [实例加载器] OssModule依赖项已初始化
   ```

2. **查找 OSS 初始化日志**：
   ```
   🔐 [OSS] 初始化 OSS 服务...
   🔐 [OSS] OSS_ACCESS_KEY_ID: ...
   🔐 [OSS] OSS_ACCESS_KEY_SECRET: ...
   ✅ [OSS] OSS 客户端初始化成功
   ```
   或
   ```
   ⚠️ [OSS] OSS 未配置：缺少 OSS_ACCESS_KEY_ID 或 OSS_ACCESS_KEY_SECRET
   ```

3. **查找环境变量日志**：
   在服务启动时应该看到：
   ```
   📦 Environment variables:
     OSS_REGION: ...
     OSS_ACCESS_KEY_ID: ...
     OSS_ACCESS_KEY_SECRET: ...
     OSS_BUCKET: ...
   ```

### 步骤 2：检查 Railway 环境变量

1. 登录 [Railway Dashboard](https://railway.app)
2. 进入项目 → API 服务 → **"Variables"** 标签
3. 确认以下变量已添加：

| 变量名 | 是否已配置 | 检查 |
|--------|-----------|------|
| `OSS_REGION` | ⬜ | 值应为 `oss-cn-hangzhou` 或你的地域代码 |
| `OSS_ACCESS_KEY_ID` | ⬜ | 值应为你的 AccessKey ID |
| `OSS_ACCESS_KEY_SECRET` | ⬜ | 值应为你的 AccessKey Secret |
| `OSS_BUCKET` | ⬜ | 值应为你的 Bucket 名称 |

### 步骤 3：如果变量未配置

1. 在 Railway Variables 中点击 **"+ New Variable"**
2. 依次添加以下变量：

```
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=你的AccessKey_ID
OSS_ACCESS_KEY_SECRET=你的AccessKey_Secret
OSS_BUCKET=venues-images
```

3. Railway 会自动重新部署（等待 1-2 分钟）

4. 重新部署后，查看新的部署日志，应该看到：
   ```
   ✅ [OSS] OSS 客户端初始化成功
   ```

### 步骤 4：测试图片上传

1. 访问你的网站
2. 登录账号
3. 进入场地编辑页面
4. 尝试上传一张图片

**如果上传失败，查看浏览器控制台的错误信息**

## 📋 检查清单

- [ ] 已在 Railway Variables 中添加 `OSS_REGION`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_ID`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_SECRET`
- [ ] 已在 Railway Variables 中添加 `OSS_BUCKET`
- [ ] 部署日志中看到 `[InstanceLoader] OssModule dependencies initialized`
- [ ] 部署日志中看到 `🔐 [OSS] 初始化 OSS 服务...`
- [ ] 部署日志中看到 `✅ [OSS] OSS 客户端初始化成功`
- [ ] 已测试图片上传功能
- [ ] 上传的图片可以正常显示

## ❓ 如果仍然看不到 OSS 日志

如果部署日志中完全没有 OSS 相关的信息，可能的原因：

1. **OSS 模块没有被加载**：检查 `app.module.ts` 中是否导入了 `OssModule`
2. **日志被截断**：查看完整的部署日志，特别是启动阶段
3. **环境变量未设置**：即使未设置，也应该看到 `⚠️ [OSS] OSS 未配置` 的警告

## 🆘 需要帮助？

如果遇到问题，请提供：
1. Railway 部署日志中关于 OSS 的部分（搜索 `OSS` 或 `oss`）
2. Railway Variables 中 OSS 相关变量的配置状态
3. 浏览器控制台的错误信息（如果上传失败）
