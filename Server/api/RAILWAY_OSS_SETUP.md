# Railway 部署环境 OSS 配置指南

本指南说明如何在 Railway 部署环境中配置阿里云 OSS，以支持图片上传功能。

## 📋 前置要求

1. 已创建阿里云 OSS Bucket（参考 `OSS_SETUP.md`）
2. 已获取 AccessKey ID 和 Secret（参考 `OSS_SETUP.md`）
3. Railway 项目已部署

---

## 第一步：在 Railway 中配置环境变量

### 1.1 登录 Railway

1. 访问 [Railway Dashboard](https://railway.app)
2. 登录你的账号
3. 进入你的项目

### 1.2 找到后端服务

1. 在项目页面，找到 **API 服务**（通常是 `api` 或 `backend`）
2. 点击进入该服务

### 1.3 添加环境变量

1. 点击服务页面顶部的 **"Variables"** 标签
2. 点击 **"+ New Variable"** 按钮
3. 依次添加以下环境变量：

#### 必需的环境变量：

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `OSS_REGION` | OSS 地域代码 | `oss-cn-hangzhou` |
| `OSS_ACCESS_KEY_ID` | AccessKey ID | `LTAI5tAbCdEfGhIjK1mNpQxX` |
| `OSS_ACCESS_KEY_SECRET` | AccessKey Secret | `3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo` |
| `OSS_BUCKET` | Bucket 名称 | `venues-images` |

#### 可选的环境变量：

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `OSS_HOTLINK_SECRET` | 防盗链密钥（可选） | `your_random_secret_key` |

### 1.4 填写变量值

**重要提示：**
- `OSS_REGION`：填写你在阿里云创建 Bucket 时选择的地域代码
  - 华东1（杭州）→ `oss-cn-hangzhou`
  - 华东2（上海）→ `oss-cn-shanghai`
  - 华北2（北京）→ `oss-cn-beijing`
  - 华南1（深圳）→ `oss-cn-shenzhen`
- `OSS_ACCESS_KEY_ID`：填写你的阿里云 AccessKey ID
- `OSS_ACCESS_KEY_SECRET`：填写你的阿里云 AccessKey Secret（**注意保密**）
- `OSS_BUCKET`：填写你在阿里云创建的 Bucket 名称

### 1.5 保存配置

1. 每添加一个变量后，点击 **"Add"** 保存
2. 确保所有变量都已添加完成
3. Railway 会自动重新部署服务（通常需要 1-2 分钟）

---

## 第二步：验证配置

### 2.1 检查部署日志

1. 在 Railway 服务页面，点击 **"Deployments"** 标签
2. 查看最新的部署日志
3. 确认部署成功（没有错误）

### 2.2 测试图片上传

1. 访问你的网站
2. 登录账号
3. 进入任意场地详情页
4. 尝试上传一张图片
5. 如果配置正确，图片应该能够成功上传并显示

---

## 常见问题

### 问题 1：上传时提示 "OSS未配置"

**原因：** Railway 环境变量未正确配置

**解决方法：**
1. 检查 Railway Variables 中是否添加了所有必需的环境变量
2. 确认变量名拼写正确（区分大小写）
3. 确认变量值没有多余的空格
4. 重新部署服务（Railway 会自动重新部署）

### 问题 2：上传失败，提示 "签名生成失败"

**原因：** AccessKey 信息不正确或 Bucket 配置不匹配

**解决方法：**
1. 检查 `OSS_ACCESS_KEY_ID` 和 `OSS_ACCESS_KEY_SECRET` 是否正确
2. 检查 `OSS_REGION` 是否与 Bucket 的地域一致
3. 检查 `OSS_BUCKET` 是否与 Bucket 名称一致
4. 确认 AccessKey 有 OSS 的访问权限

### 问题 3：上传成功但图片无法显示

**原因：** Bucket 权限设置不正确

**解决方法：**
1. 登录阿里云 OSS 控制台
2. 找到你的 Bucket，点击进入
3. 点击 **"权限管理"** → **"读写权限"**
4. 确保设置为 **"公共读"**

### 问题 4：Railway 部署后配置不生效

**原因：** 环境变量添加后需要重新部署

**解决方法：**
1. 在 Railway 服务页面，点击 **"Settings"** 标签
2. 找到 **"Redeploy"** 选项
3. 点击 **"Redeploy"** 重新部署服务
4. 或者等待 Railway 自动重新部署（通常会自动触发）

---

## 🔒 安全建议

1. **保护 AccessKey Secret**
   - 不要在代码中硬编码 AccessKey
   - 不要将 AccessKey 提交到 Git 仓库
   - Railway 的环境变量是加密存储的，相对安全

2. **使用子账号 AccessKey（推荐）**
   - 在阿里云控制台创建子账号
   - 为子账号授予 OSS 的读写权限
   - 使用子账号的 AccessKey 配置 Railway

3. **定期轮换 AccessKey**
   - 建议每 3-6 个月更换一次
   - 更换后，更新 Railway 环境变量并重新部署

---

## 📝 配置检查清单

完成配置后，请确认：

- [ ] 已在 Railway Variables 中添加 `OSS_REGION`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_ID`
- [ ] 已在 Railway Variables 中添加 `OSS_ACCESS_KEY_SECRET`
- [ ] 已在 Railway Variables 中添加 `OSS_BUCKET`
- [ ] 所有变量值都正确填写
- [ ] Railway 服务已重新部署
- [ ] 已测试图片上传功能
- [ ] 上传的图片可以正常显示

---

## 🆘 需要帮助？

如果遇到问题，请：

1. 查看 Railway 部署日志中的错误信息
2. 查看浏览器控制台的错误信息
3. 检查阿里云 OSS 控制台中的 Bucket 设置
4. 参考 `OSS_SETUP.md` 和 `OSS_CONFIG_GUIDE.md` 获取更多信息


