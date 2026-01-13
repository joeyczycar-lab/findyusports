# 检查 Railway 服务日志

## 问题诊断

如果环境变量都已配置，但仍然提示 "OSS未配置"，需要检查服务日志来定位问题。

## 检查步骤

### 1. 查看服务日志

1. 在 Railway 中，点击 `findyusports` 服务
2. 点击 **"Logs"** 标签
3. 查找以下日志信息：

#### 正常情况应该看到：
```
🔐 [OSS] 初始化 OSS 服务...
🔐 [OSS] OSS_ACCESS_KEY_ID: LTAI5tD...
🔐 [OSS] OSS_ACCESS_KEY_SECRET: 已设置
🔐 [OSS] OSS_REGION: oss-cn-hangzhou
🔐 [OSS] OSS_BUCKET: [你的bucket名称]
✅ [OSS] OSS 客户端初始化成功
```

#### 如果看到：
```
⚠️ [OSS] OSS 未配置：缺少 OSS_ACCESS_KEY_ID 或 OSS_ACCESS_KEY_SECRET
```
说明环境变量没有被正确读取。

### 2. 可能的原因和解决方案

#### 原因 1：环境变量配置在了错误的服务上
- **检查**：确认环境变量配置在 `findyusports` 服务上，而不是 `Postgres` 服务
- **解决**：在正确的服务上重新配置环境变量

#### 原因 2：服务没有重新部署
- **检查**：在 "Deployments" 标签中，查看最新部署的时间
- **解决**：手动触发重新部署（Settings → Redeploy）

#### 原因 3：环境变量值有空格或特殊字符
- **检查**：在 Variables 页面，点击每个 OSS 变量，查看值是否有前后空格
- **解决**：删除前后空格，确保值正确

#### 原因 4：环境变量名称拼写错误
- **检查**：确认变量名称完全正确：
  - `OSS_ACCESS_KEY_ID`（不是 `OSS_ACCESS_KEY`）
  - `OSS_ACCESS_KEY_SECRET`（不是 `OSS_SECRET`）
  - `OSS_REGION`
  - `OSS_BUCKET`
- **解决**：删除错误的变量，重新添加正确的变量

### 3. 测试环境变量读取

上传图片时，查看日志中是否有：
```
🔐 [OSS] Generating presigned URL for key: ...
```

如果没有，说明 `generatePresignedUrl` 方法没有被调用，或者 `this.client` 为 `null`。

### 4. 手动触发重新部署

如果环境变量已更新：
1. 在 Railway 中，点击 `findyusports` 服务
2. 点击 **"Settings"** 标签
3. 找到 **"Redeploy"** 按钮
4. 点击重新部署
5. 等待部署完成（1-2 分钟）
6. 再次尝试上传图片

## 快速检查清单

- [ ] 确认环境变量配置在 `findyusports` 服务上
- [ ] 检查变量名称拼写是否正确
- [ ] 检查变量值是否有空格
- [ ] 查看服务日志，确认 OSS 初始化状态
- [ ] 手动触发重新部署
- [ ] 再次尝试上传图片
