# 数据库迁移脚本

## 创建页面访问统计表

运行以下 SQL 脚本来创建 `page_view` 表：

```bash
# 使用 psql 连接数据库并执行脚本
psql $DATABASE_URL -f src/migrations/create-page-view-table.sql

# 或者直接在 psql 中执行
psql $DATABASE_URL
\i src/migrations/create-page-view-table.sql
```

### 在 Railway 上执行

1. 进入 Railway 项目
2. 打开 PostgreSQL 服务
3. 在 "Query" 标签页中执行 SQL 脚本

### 在本地执行

```bash
# 设置环境变量
export DATABASE_URL="postgresql://user:password@localhost:5432/venues"

# 执行迁移
psql $DATABASE_URL -f src/migrations/create-page-view-table.sql
```

## 表结构

- `id`: 主键，自增
- `path`: 页面路径（如 `/map`, `/venues/1`）
- `page_type`: 页面类型（如 `home`, `map`, `venue`, `admin`）
- `referer`: 来源页面
- `user_agent`: 用户代理
- `ip`: IP 地址
- `user_id`: 用户 ID（如果已登录）
- `created_at`: 访问时间

## 索引

- `idx_page_view_path`: 按路径查询
- `idx_page_view_created_at`: 按时间查询
- `idx_page_view_page_type`: 按页面类型查询

