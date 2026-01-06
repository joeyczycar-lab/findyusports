# Railway 数据库配置指南

## 📋 快速配置步骤

### 第一步：获取 Railway 数据库连接信息

1. **登录 Railway**
   - 访问：https://railway.app
   - 登录你的账号

2. **找到你的数据库服务**
   - 在项目列表中找到你的项目
   - 点击数据库服务（PostgreSQL）

3. **获取连接字符串**
   - 点击 **"Connect"** 或 **"Variables"** 标签页
   - 找到 `DATABASE_URL` 或 `POSTGRES_URL`
   - 复制完整的连接字符串，格式类似：
     ```
     postgresql://postgres:password@containers-us-west-xxx.railway.app:5432/railway
     ```

### 第二步：配置 .env 文件

1. **创建 .env 文件**
   ```powershell
   cd F:\Findyu\Server\api
   copy .env.example .env
   ```

2. **编辑 .env 文件**
   - 打开 `Server/api/.env` 文件
   - 设置以下配置：

   ```env
   # Railway 数据库连接（必须）
   DATABASE_URL=postgresql://postgres:password@hostname:port/railway
   DB_SSL=true

   # 服务器端口
   PORT=4000

   # JWT 密钥（必须，可以生成一个随机字符串）
   JWT_SECRET=your_random_secret_key_here_change_this
   ```

   **重要提示：**
   - 将 `DATABASE_URL` 替换为你从 Railway 复制的实际连接字符串
   - `DB_SSL=true` 是必须的，因为 Railway 数据库需要 SSL 连接
   - `JWT_SECRET` 可以生成一个随机字符串，例如：
     ```powershell
     # PowerShell 生成随机字符串
     -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
     ```

### 第三步：初始化 PostGIS 扩展

Railway PostgreSQL 数据库需要启用 PostGIS 扩展（用于地理位置查询）。

**方法 1：使用 Railway 的 Query 功能（推荐）**

1. 在 Railway 数据库页面，点击 **"Query"** 标签页
2. 执行以下 SQL：
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```

**方法 2：使用命令行工具**

如果你安装了 `psql`：
```bash
psql "你的DATABASE_URL" -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

### 第四步：运行数据库迁移

配置完成后，运行数据库迁移来创建表结构：

```powershell
cd F:\Findyu\Server\api
npm run migration:run
```

### 第五步：启动后端服务

```powershell
npm run dev
```

如果看到类似这样的输出，说明配置成功：
```
API running on http://localhost:4000
```

---

## 🔍 验证配置

### 检查数据库连接

启动后端后，检查日志中是否有数据库连接错误。如果看到类似这样的错误：

```
Error: connect ECONNREFUSED
```

说明数据库连接配置有问题，请检查：
1. `DATABASE_URL` 是否正确
2. `DB_SSL=true` 是否已设置
3. Railway 数据库是否正在运行

### 测试注册接口

在浏览器中打开：
```
http://localhost:4000/auth/register
```

或者使用 curl 测试：
```powershell
curl -X POST http://localhost:4000/auth/register `
  -H "Content-Type: application/json" `
  -d '{\"phone\":\"13800000001\",\"password\":\"123456\",\"nickname\":\"测试用户\"}'
```

---

## 🔧 常见问题

### Q1: 连接失败 "ECONNREFUSED"

**原因：** Railway 数据库可能已暂停或连接字符串不正确

**解决方案：**
1. 检查 Railway 数据库服务是否正在运行
2. 重新复制 `DATABASE_URL`（Railway 的连接字符串可能会变化）
3. 确保 `DB_SSL=true` 已设置

### Q2: PostGIS 扩展错误

**错误信息：** `extension "postgis" does not exist`

**解决方案：**
1. 在 Railway Query 页面执行：`CREATE EXTENSION IF NOT EXISTS postgis;`
2. 如果 Railway 不支持 PostGIS，可能需要：
   - 使用 Railway 的 PostGIS 模板创建数据库
   - 或联系 Railway 支持

### Q3: 迁移失败 "relation already exists"

**原因：** 数据库表已经存在

**解决方案：**
```powershell
# 如果需要重置数据库（⚠️ 会删除所有数据）
npm run migration:revert
npm run migration:run
```

### Q4: JWT_SECRET 未设置

**错误信息：** `JWT_SECRET is required`

**解决方案：**
在 `.env` 文件中添加：
```env
JWT_SECRET=your_random_secret_key_here
```

---

## 📝 完整配置示例

`.env` 文件完整示例：

```env
# 服务器配置
PORT=4000

# Railway 数据库配置
DATABASE_URL=postgresql://postgres:your_password@containers-us-west-123.railway.app:5432/railway
DB_SSL=true

# JWT 配置
JWT_SECRET=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6

# 阿里云OSS配置（可选）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
# OSS_HOTLINK_SECRET=your_hotlink_secret_key
```

---

## ✅ 配置检查清单

完成配置后，请确认：

- [ ] 已从 Railway 获取 `DATABASE_URL`
- [ ] 已创建 `.env` 文件
- [ ] 已设置 `DATABASE_URL` 和 `DB_SSL=true`
- [ ] 已设置 `JWT_SECRET`
- [ ] 已在 Railway 数据库中创建 PostGIS 扩展
- [ ] 已运行数据库迁移（`npm run migration:run`）
- [ ] 后端服务已启动（`npm run dev`）
- [ ] 可以访问 `http://localhost:4000/auth/register`

---

**配置完成后，你的注册功能应该就能正常工作了！** 🎉



