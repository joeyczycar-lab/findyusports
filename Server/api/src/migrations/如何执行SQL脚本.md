# 如何执行 SQL 脚本

## 方法 1：使用 Railway 数据库控制台（推荐，适用于生产环境）

### 步骤：

1. **登录 Railway**
   - 访问 https://railway.app
   - 登录你的账号

2. **打开数据库服务**
   - 在 Railway 项目中找到你的 PostgreSQL 数据库服务
   - 点击进入数据库服务页面

3. **打开 Query 标签页**
   - 在数据库服务页面，找到 "Query" 或 "SQL Editor" 标签
   - 点击打开 SQL 查询编辑器

4. **执行 SQL 脚本**
   - 复制 `add-all-missing-columns.sql` 文件中的所有 SQL 语句
   - 粘贴到查询编辑器中
   - 点击 "Run" 或 "Execute" 按钮执行

5. **验证执行结果**
   - 查看执行结果，应该显示 "ALTER TABLE" 成功
   - 脚本末尾的验证查询会显示所有已添加的列

---

## 方法 2：使用本地 PostgreSQL 命令行（适用于本地开发）

### 步骤：

1. **打开终端**

2. **连接到数据库**
   ```bash
   # 如果使用默认配置
   psql -U postgres -d your_database_name
   
   # 或者使用连接字符串
   psql postgresql://username:password@localhost:5432/database_name
   ```

3. **执行 SQL 脚本**
   ```bash
   # 方法 A：在 psql 中直接执行
   \i /path/to/add-all-missing-columns.sql
   
   # 方法 B：从文件读取并执行
   psql -U postgres -d your_database_name -f /path/to/add-all-missing-columns.sql
   
   # 方法 C：直接粘贴 SQL 语句
   # 复制 SQL 脚本内容，粘贴到 psql 提示符中，按 Enter 执行
   ```

4. **验证执行结果**
   - 查看输出，确认所有 ALTER TABLE 语句执行成功
   - 执行脚本末尾的验证查询，查看已添加的列

---

## 方法 3：使用数据库管理工具（适用于所有环境）

### 推荐工具：
- **pgAdmin**（PostgreSQL 官方工具）
- **DBeaver**（跨平台数据库工具）
- **TablePlus**（Mac/Windows）
- **DataGrip**（JetBrains）

### 步骤：

1. **连接到数据库**
   - 打开数据库管理工具
   - 创建新的数据库连接
   - 输入连接信息（主机、端口、数据库名、用户名、密码）

2. **打开 SQL 编辑器**
   - 在工具中找到 "SQL Editor" 或 "Query" 功能
   - 打开新的查询窗口

3. **执行 SQL 脚本**
   - 打开 `add-all-missing-columns.sql` 文件
   - 复制所有 SQL 语句
   - 粘贴到 SQL 编辑器中
   - 点击 "Execute" 或按快捷键（通常是 F5 或 Cmd+Enter）

4. **查看执行结果**
   - 在结果面板中查看执行状态
   - 确认所有语句执行成功

---

## 方法 4：使用 Node.js 脚本执行（适用于自动化）

如果你想要自动化执行，可以创建一个 Node.js 脚本：

```javascript
// execute-migration.js
const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

async function executeMigration() {
  const client = new Client({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  });

  try {
    await client.connect();
    console.log('✅ 已连接到数据库');

    const sql = fs.readFileSync(
      path.join(__dirname, 'add-all-missing-columns.sql'),
      'utf8'
    );

    await client.query(sql);
    console.log('✅ SQL 脚本执行成功');

    await client.end();
  } catch (error) {
    console.error('❌ 执行失败:', error);
    process.exit(1);
  }
}

executeMigration();
```

运行：
```bash
node execute-migration.js
```

---

## 快速执行（最简单的方法）

### 如果你使用的是 Railway：

1. 打开 Railway 项目
2. 找到 PostgreSQL 数据库服务
3. 点击 "Query" 标签
4. 复制以下 SQL 并粘贴执行：

```sql
ALTER TABLE venue ADD COLUMN IF NOT EXISTS court_count INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS floor_type VARCHAR(50);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS open_hours VARCHAR(200);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_lighting BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_air_conditioning BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_parking BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_rest_area BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_fence BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_shower BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_locker BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_shop BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_walk_in BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_full_court BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS walk_in_price_min INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS walk_in_price_max INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS full_court_price_min INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS full_court_price_max INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS requires_reservation BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS reservation_method VARCHAR(200);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS players_per_side VARCHAR(20);
```

5. 点击 "Run" 执行

---

## 注意事项

1. **备份数据**：执行前建议备份数据库（虽然使用 `IF NOT EXISTS` 不会删除数据）

2. **执行顺序**：脚本中的语句可以一次性执行，也可以逐条执行

3. **错误处理**：如果某个列已存在，`IF NOT EXISTS` 会跳过，不会报错

4. **验证**：执行后可以运行脚本末尾的验证查询，确认所有列都已添加

---

## 验证执行结果

执行以下查询，确认所有列都已添加：

```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'venue' 
AND column_name IN (
  'court_count', 'floor_type', 'open_hours',
  'has_lighting', 'has_air_conditioning', 'has_parking',
  'has_rest_area', 'has_fence', 'has_shower', 'has_locker', 'has_shop',
  'supports_walk_in', 'supports_full_court',
  'walk_in_price_min', 'walk_in_price_max',
  'full_court_price_min', 'full_court_price_max',
  'requires_reservation', 'reservation_method', 'players_per_side'
)
ORDER BY column_name;
```

如果查询返回所有 19 个列，说明执行成功！
