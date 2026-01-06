# 快速启动指南

## 启动后端服务

### 方法 1：使用批处理脚本（推荐）

双击运行：
```
start-backend.bat
```

或在命令行：
```cmd
cd F:\Findyu\Server\api
start-backend.bat
```

### 方法 2：手动启动

```cmd
cd F:\Findyu\Server\api

# 1. 确保数据库容器运行
docker compose up -d

# 2. 启动后端服务
npm run dev
```

## 验证服务

启动后，在浏览器访问：
```
http://localhost:4000/health
```

如果看到响应，说明服务正常运行。

## 常见问题

### ERR_CONNECTION_REFUSED

**原因：** 后端服务未启动

**解决：** 运行 `npm run dev` 启动后端服务

### 数据库连接失败

**原因：** 数据库容器未运行

**解决：** 运行 `docker compose up -d` 启动数据库

### 端口被占用

**原因：** 4000 端口已被其他程序占用

**解决：** 
1. 修改 `.env` 文件中的 `PORT=4000` 为其他端口（如 `PORT=4001`）
2. 或关闭占用 4000 端口的程序



