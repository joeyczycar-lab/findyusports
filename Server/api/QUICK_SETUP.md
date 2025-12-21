# 快速配置指南

## 在 DMS 中找到数据库连接信息

### 步骤 1：找到数据库实例
在 DMS 左侧"数据库实例"列表中，找到你的 PostgreSQL 数据库

### 步骤 2：查看连接信息
点击实例名称，在详情页查找：
- **外网地址**（格式：`xxx.rds.aliyuncs.com`）
- **端口**（通常是 `5432`）
- **数据库账号**（用户名）
- **数据库名称**

### 步骤 3：获取密码
如果不知道密码：
1. 访问 RDS 控制台：https://rds.console.aliyun.com
2. 找到你的 PostgreSQL 实例
3. 点击"账号管理"可以重置密码

## 配置本地连接

找到信息后，运行：
```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
./setup-aliyun-db.sh
```

或者直接告诉我这些信息，我帮你创建配置文件。
