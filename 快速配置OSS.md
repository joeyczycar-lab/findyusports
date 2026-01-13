# 快速配置阿里云 OSS（Railway）

## 🚀 快速步骤

### 步骤 1：准备阿里云 OSS 信息

如果你还没有阿里云 OSS，需要先创建：

1. **登录阿里云控制台**：https://oss.console.aliyun.com/
2. **创建 Bucket**：
   - 点击"创建 Bucket"
   - 名称：例如 `venues-images`
   - 地域：选择离你最近的地域（如：华东1-杭州）
   - 读写权限：选择"公共读"
   - 点击"确定"
3. **获取 AccessKey**：
   - 点击右上角头像 → "AccessKey 管理"
   - 创建 AccessKey（如果还没有）
   - 记录 `AccessKey ID` 和 `AccessKey Secret`

### 步骤 2：在 Railway 中配置环境变量

1. **登录 Railway**：https://railway.app
2. **进入你的后端项目**
3. **点击 "Variables" 标签**
4. **添加以下 4 个环境变量**：

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `OSS_REGION` | OSS 地域代码 | `oss-cn-hangzhou` |
| `OSS_ACCESS_KEY_ID` | AccessKey ID | `LTAI5tAbCdEfGhIjK1mNpQxX` |
| `OSS_ACCESS_KEY_SECRET` | AccessKey Secret | `3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo` |
| `OSS_BUCKET` | Bucket 名称 | `venues-images` |

**重要提示：**
- `OSS_REGION` 必须与你在阿里云创建 Bucket 时选择的地域一致
- `OSS_BUCKET` 必须与你在阿里云创建的 Bucket 名称完全一致
- `OSS_ACCESS_KEY_SECRET` 是敏感信息，请妥善保管

### 步骤 3：等待重新部署

添加环境变量后，Railway 会自动重新部署服务（通常需要 1-2 分钟）。

### 步骤 4：测试上传

1. 访问你的网站
2. 登录账号
3. 进入任意场地详情页
4. 点击"+ 添加图片"
5. 选择一张图片上传
6. 如果配置正确，图片应该能够成功上传并显示

## 📋 地域代码对照表

| 地域 | 代码 |
|------|------|
| 华东1（杭州） | `oss-cn-hangzhou` |
| 华东2（上海） | `oss-cn-shanghai` |
| 华北2（北京） | `oss-cn-beijing` |
| 华南1（深圳） | `oss-cn-shenzhen` |
| 华北3（张家口） | `oss-cn-zhangjiakou` |
| 华东5（南京） | `oss-cn-nanjing` |

## ✅ 配置检查清单

完成配置后，请确认：

- [ ] 已在阿里云创建 OSS Bucket
- [ ] Bucket 权限设置为"公共读"
- [ ] 已获取 AccessKey ID 和 Secret
- [ ] 已在 Railway Variables 中添加 `OSS_REGION`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_ID`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_SECRET`
- [ ] 已在 Railway Variables 中添加 `OSS_BUCKET`
- [ ] 所有变量值都正确填写（没有多余空格）
- [ ] Railway 服务已重新部署
- [ ] 已测试图片上传功能

## ❌ 常见错误

### 错误 1：上传时仍然提示"OSS未配置"

**解决方法：**
1. 检查 Railway Variables 中是否所有变量都已添加
2. 确认变量名拼写正确（区分大小写）
3. 确认变量值没有多余的空格
4. 在 Railway 服务页面点击 "Settings" → "Redeploy" 手动重新部署

### 错误 2：上传失败，提示"签名生成失败"

**解决方法：**
1. 检查 `OSS_ACCESS_KEY_ID` 和 `OSS_ACCESS_KEY_SECRET` 是否正确
2. 检查 `OSS_REGION` 是否与 Bucket 的地域一致
3. 检查 `OSS_BUCKET` 是否与 Bucket 名称一致
4. 确认 AccessKey 有 OSS 的访问权限

### 错误 3：上传成功但图片无法显示

**解决方法：**
1. 登录阿里云 OSS 控制台
2. 找到你的 Bucket，点击进入
3. 点击"权限管理" → "读写权限"
4. 确保设置为"公共读"

## 📚 详细文档

- **Railway OSS 配置详细指南**：`Server/api/RAILWAY_OSS_SETUP.md`
- **OSS 基础配置说明**：`Server/api/OSS_SETUP.md`
