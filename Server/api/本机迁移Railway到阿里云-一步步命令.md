# 本机迁移 Railway → 阿里云 RDS 一步步命令

在**本机终端**按顺序执行。需要先安装 PostgreSQL 客户端（见下方「安装 pg_dump / psql」）。

---

## 一、安装 pg_dump / psql（未安装时执行一次）

```bash
brew install libpq
echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

（Intel Mac 可能是 `/usr/local/opt/libpq/bin`，用 `brew --prefix libpq` 查看）

---

## 二、从 Railway 导出

在终端执行（**把下面的 Railway 连接串换成你自己的**，密码里的特殊字符需 URL 编码）：

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api

# 设置 Railway 的 DATABASE_URL（示例，请替换成你的）
export RAILWAY_URL='postgresql://postgres:你的密码@yamanote.proxy.rlwy.net:29122/railway'

# 导出（Railway 一般要 SSL）
export PGSSLMODE=require
pg_dump "$RAILWAY_URL" --no-owner --no-acl -f railway_dump_$(date +%Y%m%d_%H%M%S).sql

unset RAILWAY_URL PGSSLMODE
ls -la railway_dump_*.sql
```

记下生成的 `railway_dump_YYYYMMDD_HHMMSS.sql` 文件名。

---

## 三、在阿里云 RDS 的 venues 库里开 PostGIS

用 DMS 或 psql 连上 RDS 的 **venues** 库，执行：

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

（只做一次即可。）

---

## 四、导入到阿里云 RDS

**把下面命令里的「阿里云主机、账号、密码、库名、dump 文件名」换成你的实际值**，再执行：

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api

# 设置阿里云 RDS 连接信息（请替换成你的）
export ALI_HOST='你的RDS连接地址'    # 例: pgm-bp13c80a190u3sk6.pg.rds.aliyuncs.com
export ALI_PORT=5432
export ALI_USER='你的RDS账号'        # 例: 你在「账号管理」里创建的账号
export ALI_PASS='你的RDS密码'
export ALI_DB='venues'
export DUMP_FILE='railway_dump_YYYYMMDD_HHMMSS.sql'   # 换成第二步生成的文件名

# 导入（先试 SSL，失败则去掉 ?sslmode=require 再试）
psql "postgresql://$ALI_USER:$ALI_PASS@$ALI_HOST:$ALI_PORT/$ALI_DB?sslmode=require" -f "$DUMP_FILE"

unset ALI_PASS
```

RDS 连接地址在：RDS 控制台 → 实例 → **数据库连接**（内网/外网地址）。

---

## 五、改后端连阿里云

- **Railway 上的后端**：Variables 里把 `DATABASE_URL` 改为阿里云连接串：
  `postgresql://RDS账号:RDS密码@RDS主机:5432/venues`
  需要 SSL 时加 `?sslmode=require`，并设 `DB_SSL=true`。
- **本地 .env**：在 `Server/api/.env` 里改 `DATABASE_URL` 和 `DB_SSL`，然后重启后端。

---

## 六、没有 pg_dump 时用 Docker 导出（可选）

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api

docker run --rm -e PGPASSWORD='你的Railway密码' postgres:15 \
  pg_dump -h yamanote.proxy.rlwy.net -p 29122 -U postgres -d railway \
  --no-owner --no-acl \
  > railway_dump_$(date +%Y%m%d_%H%M%S).sql
```

（需本机已装 Docker；密码含特殊字符时注意引号。）
