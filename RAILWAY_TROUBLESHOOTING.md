# Railway 后端服务 502 错误排查指南

## 问题症状
- 前端显示 "Failed to fetch" 错误
- 后端 API 返回 502 Bad Gateway
- 健康检查端点无响应

## 快速检查清单

### ✅ 1. 检查服务状态
在 Railway Dashboard → findyusports 服务：
- [ ] 服务状态是否为 "Online"？
- [ ] 如果状态是 "Crashed"，查看日志
- [ ] 如果状态是 "Offline"，需要启动服务

### ✅ 2. 检查环境变量
在 Railway Dashboard → findyusports 服务 → Variables：

必须设置以下变量：
```
DATABASE_URL = postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway
DB_SSL = true
JWT_SECRET = [你的密钥，至少32个字符]
```

**注意：**
- PORT 变量由 Railway 自动设置，通常不需要手动配置
- 确保值没有多余的空格或引号
- 确保所有变量都已保存

### ✅ 3. 查看部署日志
在 Railway Dashboard → findyusports 服务 → Deployments：

查看最新部署的日志，查找以下错误：

#### 常见错误 1：数据库连接失败
```
错误信息：ECONNREFUSED 或 connection refused
解决方法：
1. 检查 DATABASE_URL 是否正确
2. 检查 DB_SSL 是否设置为 true
3. 确认数据库服务正在运行
```

#### 常见错误 2：环境变量缺失
```
错误信息：JWT_SECRET is not set 或 DATABASE_URL is not set
解决方法：
1. 在 Variables 中添加缺失的环境变量
2. 重新部署服务
```

#### 常见错误 3：应用启动失败
```
错误信息：Failed to start application 或 Application crashed
解决方法：
1. 查看完整的错误日志
2. 检查代码是否有语法错误
3. 检查依赖是否正确安装
```

#### 常见错误 4：端口绑定错误
```
错误信息：Port already in use 或 EADDRINUSE
解决方法：
1. 确保代码使用 process.env.PORT
2. Railway 会自动设置 PORT，不要硬编码端口号
```

### ✅ 4. 检查数据库服务
在 Railway Dashboard → Postgres 服务：
- [ ] 数据库服务状态是否为 "Online"？
- [ ] 数据库是否已创建？
- [ ] 数据库迁移是否已运行？

## 修复步骤

### 步骤 1：设置环境变量
1. 登录 Railway Dashboard
2. 进入 findyusports 服务
3. 点击 "Variables" 标签
4. 添加或更新以下变量：

```
DATABASE_URL = postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway
DB_SSL = true
JWT_SECRET = 934842856538d08a5026241ee595e4fbb9db3d5af43cc4968f1d520ae65e826a
```

### 步骤 2：重新部署
1. 在 Railway Dashboard 中点击 "Redeploy"
2. 或者推送代码到 GitHub 触发自动部署
3. 等待部署完成（通常 1-2 分钟）

### 步骤 3：查看日志
1. 在部署完成后，查看最新日志
2. 查找 "✅ API running" 消息
3. 如果看到错误，根据错误信息进行修复

### 步骤 4：验证服务
1. 访问健康检查端点：
   ```
   https://findyusports-production.up.railway.app/health
   ```
2. 应该返回：
   ```json
   {
     "status": "ok",
     "service": "sports-venues-api",
     "timestamp": "..."
   }
   ```

## 如果仍然失败

请提供以下信息以便进一步诊断：

1. **Railway 服务状态**
   - 服务状态（Online/Crashed/Offline）
   - 最新部署时间

2. **环境变量列表**
   - 已设置的变量名称（隐藏敏感值）
   - 是否有缺失的变量

3. **最新日志**
   - 复制最新的错误日志
   - 特别关注启动失败的错误

4. **数据库状态**
   - 数据库服务是否正常运行
   - 数据库迁移是否成功

## 常见问题解答

### Q: 为什么服务一直返回 502？
A: 502 错误表示网关无法连接到后端应用。通常是因为：
- 应用启动失败
- 环境变量配置错误
- 数据库连接失败

### Q: 如何查看详细的错误日志？
A: 在 Railway Dashboard → findyusports 服务 → Deployments → 点击最新部署 → 查看 Logs

### Q: 环境变量设置后需要重启吗？
A: Railway 会在你保存环境变量后自动重新部署服务

### Q: 如何确认服务已正常运行？
A: 访问健康检查端点，如果返回 `{"status":"ok"}` 说明服务正常

