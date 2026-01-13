# 检查 OSS 配置

## 可能的原因

如果你之前设置过 OSS 配置，但现在仍然提示"OSS未配置"，可能是以下原因：

### 1. 环境变量配置在了错误的服务上

**问题：** Railway 项目中可能有多个服务（数据库、API 等），环境变量需要配置在 **API 服务**上，而不是数据库服务。

**检查方法：**
1. 登录 Railway：https://railway.app
2. 进入你的项目
3. 确认你配置环境变量的服务是 **API 服务**（后端服务），而不是 PostgreSQL 数据库服务
4. 如果配置在了数据库服务上，需要在 API 服务中重新配置

### 2. 环境变量名称不匹配

**问题：** 环境变量名称必须完全一致（区分大小写）

**检查方法：**
在 Railway API 服务的 Variables 中，确认以下变量名完全一致：
- `OSS_ACCESS_KEY_ID`（不是 `OSS_ACCESS_KEY` 或其他）
- `OSS_ACCESS_KEY_SECRET`（不是 `OSS_SECRET` 或其他）
- `OSS_REGION`
- `OSS_BUCKET`

### 3. 环境变量值有问题

**问题：** 变量值可能有空格、换行符或其他问题

**检查方法：**
1. 在 Railway Variables 中，点击每个变量查看值
2. 确认值前后没有多余的空格
3. 确认值没有换行符
4. 确认值是正确的（特别是 AccessKey ID 和 Secret）

### 4. 服务重新部署后环境变量丢失

**问题：** Railway 服务重新部署或重置后，环境变量可能丢失

**检查方法：**
1. 在 Railway API 服务页面，点击 "Variables" 标签
2. 查看是否还有 OSS 相关的环境变量
3. 如果不存在，需要重新添加

### 5. 环境变量未生效

**问题：** 添加环境变量后，服务没有重新部署或重启

**解决方法：**
1. 在 Railway API 服务页面，点击 "Settings" 标签
2. 找到 "Redeploy" 选项
3. 点击 "Redeploy" 手动重新部署服务

## 快速检查步骤

### 步骤 1：检查 Railway 环境变量

1. 登录 Railway：https://railway.app
2. 进入你的项目
3. **找到 API 服务**（不是数据库服务）
4. 点击 "Variables" 标签
5. 检查是否存在以下变量：
   - `OSS_ACCESS_KEY_ID`
   - `OSS_ACCESS_KEY_SECRET`
   - `OSS_REGION`
   - `OSS_BUCKET`

### 步骤 2：检查变量值

如果变量存在，检查：
1. 变量值是否正确
2. 变量值前后是否有空格
3. `OSS_REGION` 是否与 Bucket 地域一致
4. `OSS_BUCKET` 是否与 Bucket 名称一致

### 步骤 3：重新部署

如果变量都存在且正确：
1. 在 Railway API 服务页面，点击 "Settings" → "Redeploy"
2. 等待重新部署完成（1-2 分钟）
3. 再次尝试上传图片

## 如果仍然不行

请提供以下信息：
1. Railway Variables 中是否能看到这 4 个变量？
2. 变量值是否正确？
3. Railway 部署日志中是否有相关错误？
4. 浏览器控制台中的具体错误信息是什么？
