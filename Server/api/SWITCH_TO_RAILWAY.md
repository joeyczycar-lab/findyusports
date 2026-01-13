# 切换到 Railway 运行指南

## 📋 步骤 1：停止本地服务

如果本地后端服务正在运行，请先停止：

```bash
# 在运行后端服务的终端窗口按 Ctrl+C 停止服务
```

或者查找并停止进程：

```bash
# 查找运行中的后端进程
ps aux | grep "ts-node-dev.*main" | grep -v grep

# 如果找到进程，使用 kill 命令停止（替换 PID）
kill <PID>
```

## 📋 步骤 2：确保代码已推送到 Git

确保所有更改已提交并推送到 Git：

```bash
cd /Users/Zhuanz/Documents/findyusports
git add -A
git commit -m "准备部署到 Railway"
git push origin master
```

## 📋 步骤 3：检查 Railway 环境变量

### 3.1 登录 Railway

1. 访问 [Railway Dashboard](https://railway.app)
2. 登录你的账号
3. 进入你的项目

### 3.2 检查后端服务环境变量

1. 在项目页面，找到 **API 服务**（通常是 `api` 或 `backend`）
2. 点击进入该服务
3. 点击 **"Variables"** 标签
4. 确认以下环境变量已配置：

#### 必需的环境变量：

| 变量名 | 说明 | 是否已配置 |
|--------|------|-----------|
| `DATABASE_URL` | 数据库连接字符串 | ⬜ |
| `DB_SSL` | 数据库 SSL 设置（通常为 `true`） | ⬜ |
| `JWT_SECRET` | JWT 密钥 | ⬜ |
| `OSS_REGION` | OSS 地域代码 | ⬜ |
| `OSS_ACCESS_KEY_ID` | OSS AccessKey ID | ⬜ |
| `OSS_ACCESS_KEY_SECRET` | OSS AccessKey Secret | ⬜ |
| `OSS_BUCKET` | OSS Bucket 名称 | ⬜ |

**注意：**
- `PORT` 变量由 Railway 自动设置，不需要手动配置
- 确保所有变量值都没有多余的空格或引号

### 3.3 添加缺失的环境变量

如果缺少任何环境变量：

1. 点击 **"+ New Variable"** 按钮
2. 输入变量名和值
3. 点击 **"Add"** 保存
4. Railway 会自动重新部署服务

## 📋 步骤 4：检查 Railway 部署状态

### 4.1 查看部署日志

1. 在 Railway 服务页面，点击 **"Deployments"** 标签
2. 查看最新的部署日志
3. 确认部署成功，查找以下关键信息：

**成功标志：**
```
✅ API running on http://0.0.0.0:PORT
✅ [OSS] OSS 客户端初始化成功
✅ All routes mapped successfully
```

**如果看到错误：**
- `OSS未配置` → 检查 OSS 环境变量
- `数据库连接失败` → 检查 DATABASE_URL
- `JWT_SECRET is not set` → 检查 JWT_SECRET

### 4.2 检查服务状态

在 Railway 服务页面顶部，确认服务状态为 **"Online"**（绿色）

## 📋 步骤 5：测试图片上传

1. 访问你的网站（Railway 部署的前端地址）
2. 登录账号
3. 进入任意场地详情页或编辑页面
4. 尝试上传一张图片
5. 如果上传成功并显示图片，说明配置完成！

## 📋 步骤 6：验证 OSS 配置

在 Railway 部署日志中，应该看到：

```
🔐 [OSS] 初始化 OSS 服务...
🔐 [OSS] OSS_ACCESS_KEY_ID: LTAI5tA... (已设置)
🔐 [OSS] OSS_ACCESS_KEY_SECRET: 已设置
🔐 [OSS] OSS_REGION: oss-cn-hangzhou
🔐 [OSS] OSS_BUCKET: venues-images
✅ [OSS] OSS 客户端初始化成功
```

如果没有看到这些日志，说明 OSS 环境变量未正确配置。

## 🔧 常见问题

### 问题 1：部署后仍然提示 "OSS未配置"

**解决方法：**
1. 检查 Railway Variables 中是否添加了所有 OSS 相关变量
2. 确认变量名拼写正确（区分大小写）
3. 确认变量值没有多余的空格
4. 重新部署服务（Railway 会自动重新部署）

### 问题 2：部署失败

**解决方法：**
1. 查看 Railway 部署日志中的错误信息
2. 检查代码是否有语法错误
3. 确认 `package.json` 中的 `build` 和 `start` 脚本正确
4. 检查依赖是否正确安装

### 问题 3：图片上传失败

**解决方法：**
1. 检查 Railway 部署日志中的 OSS 初始化信息
2. 确认 OSS 环境变量值正确
3. 检查阿里云 OSS Bucket 权限是否设置为"公共读"
4. 查看浏览器控制台的错误信息

## ✅ 检查清单

完成切换后，请确认：

- [ ] 本地后端服务已停止
- [ ] 代码已推送到 Git
- [ ] Railway 环境变量已配置（包括 OSS 相关变量）
- [ ] Railway 服务状态为 "Online"
- [ ] 部署日志显示 OSS 初始化成功
- [ ] 已测试图片上传功能
- [ ] 上传的图片可以正常显示

## 📚 相关文档

- Railway OSS 配置：`RAILWAY_OSS_SETUP.md`
- OSS 快速配置：`QUICK_OSS_SETUP.md`
- OSS 详细配置：`OSS_CONFIG_GUIDE.md`

---

**完成以上步骤后，你的应用就在 Railway 上运行了！** 🎉
