# Railway 数据库迁移说明

## 问题
看到错误：`column "court_count" of relation "venue" does not exist`

## 原因
数据库表中缺少新添加的字段，需要执行迁移。

## 解决方法

### 方法一：在 Railway 数据库控制台执行 SQL（推荐）

1. 登录 Railway 控制台
2. 进入你的项目
3. 找到 PostgreSQL 数据库服务
4. 点击 "Query" 或 "Connect" 按钮，打开数据库查询界面
5. 复制并执行以下 SQL：

```sql
-- 添加场地数量字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS court_count INTEGER;

-- 添加场地设施字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS floor_type VARCHAR(50);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS open_hours VARCHAR(200);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_lighting BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_air_conditioning BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_parking BOOLEAN;
```

6. 执行完成后，刷新页面，应该就可以正常添加场地了。

---

### 方法二：使用 Railway CLI

如果你安装了 Railway CLI，可以：

```bash
# 连接到数据库
railway connect

# 然后执行 SQL
psql -c "ALTER TABLE venue ADD COLUMN IF NOT EXISTS court_count INTEGER;"
psql -c "ALTER TABLE venue ADD COLUMN IF NOT EXISTS floor_type VARCHAR(50);"
psql -c "ALTER TABLE venue ADD COLUMN IF NOT EXISTS open_hours VARCHAR(200);"
psql -c "ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_lighting BOOLEAN;"
psql -c "ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_air_conditioning BOOLEAN;"
psql -c "ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_parking BOOLEAN;"
```

---

### 方法三：通过后端服务运行迁移（如果后端服务可以访问数据库）

如果你可以在本地运行后端服务并连接到 Railway 数据库：

```bash
cd Server/api
npm run migrate:add-court-count
npm run migrate:add-venue-facilities
```

---

## 验证迁移是否成功

执行迁移后，可以运行以下 SQL 验证：

```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'venue' 
AND column_name IN ('court_count', 'floor_type', 'open_hours', 'has_lighting', 'has_air_conditioning', 'has_parking');
```

如果看到这 6 个字段，说明迁移成功！

---

## 注意事项

- `IF NOT EXISTS` 确保如果字段已存在，不会报错
- 这些字段都是可选的（nullable），不会影响现有数据
- 执行迁移后，需要重启后端服务（Railway 会自动重启）

