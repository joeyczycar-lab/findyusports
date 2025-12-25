# 修复 Internal Server Error 指南

## 问题原因

"Internal Server Error" 通常由以下原因引起：

1. **后端服务未运行** - 最常见的原因
2. **数据库连接失败** - 数据库配置错误或数据库未运行
3. **API 端点未处理错误** - 代码抛出异常但未捕获

## 解决方案

### 1. 启动后端服务

**检查后端是否运行**:
```bash
lsof -ti:4000
```

如果没有输出，说明后端未运行。

**启动后端**:
```bash
cd Server/api
npm run dev
```

**或者使用启动脚本**:
```bash
cd /Users/Zhuanz/Documents/findyusports
./start-dev.sh
# 选择选项 2 或 3
```

### 2. 检查数据库连接

**检查环境变量**:
```bash
cd Server/api
cat .env
```

确保包含：
- `DATABASE_URL` 或数据库连接信息
- `DB_SSL=true`（如果使用 Railway）

**测试数据库连接**:
```bash
cd Server/api
npm run view-data
```

如果连接失败，会显示错误信息。

### 3. 检查后端日志

启动后端后，查看终端输出，查找错误信息：
- 数据库连接错误
- 表不存在错误
- 其他运行时错误

### 4. 测试 API 端点

**测试健康检查**:
```bash
curl http://localhost:4000/health
```

**测试场地列表**:
```bash
curl http://localhost:4000/venues
```

如果返回 JSON 数据，说明 API 正常。

### 5. 检查前端配置

确保前端 `.env.local` 中的 `NEXT_PUBLIC_API_BASE` 指向正确的后端地址：

```env
# 本地开发
NEXT_PUBLIC_API_BASE=http://localhost:4000

# 或生产环境
NEXT_PUBLIC_API_BASE=https://findyusports-production.up.railway.app
```

## 已修复的问题

我已经添加了以下错误处理：

1. ✅ **venues/list 端点** - 添加了 try-catch 错误处理
2. ✅ **venues/detail 端点** - 添加了 try-catch 错误处理
3. ✅ **venues/search 方法** - 添加了 try-catch 错误处理
4. ✅ **venues/detail 方法** - 添加了 try-catch 错误处理

现在即使出现错误，也会返回格式化的错误响应，而不是直接抛出 500 错误。

## 快速诊断步骤

1. **检查后端服务**:
   ```bash
   lsof -ti:4000
   ```

2. **如果未运行，启动后端**:
   ```bash
   cd Server/api && npm run dev
   ```

3. **测试 API**:
   ```bash
   curl http://localhost:4000/health
   ```

4. **查看后端日志**:
   启动后端后，查看终端输出的错误信息

5. **检查数据库**:
   ```bash
   cd Server/api && npm run view-data
   ```

## 常见错误

### 错误 1: "无法连接到后端服务"

**原因**: 后端服务未运行

**解决**: 启动后端服务

### 错误 2: "column 'geom' does not exist"

**原因**: 数据库表结构与代码不匹配

**解决**: 已修复，代码会自动检测并跳过不存在的列

### 错误 3: "relation 'venue' does not exist"

**原因**: 数据库迁移未运行

**解决**: 
```bash
cd Server/api
npm run migration:run
```

### 错误 4: "Connection refused"

**原因**: 数据库连接配置错误

**解决**: 检查 `.env` 文件中的数据库连接信息

## 需要帮助？

如果以上方法都无法解决问题，请提供：
1. 后端服务的终端输出（错误日志）
2. 浏览器控制台的错误信息（F12）
3. 具体的错误消息

