# Railway 数据库迁移到阿里云

把当前在 Railway 上的 PostgreSQL 数据迁移到阿里云 RDS PostgreSQL，并让后端改为连接阿里云。

---

## 一、前置准备

### 1. 本机需要

- 已安装 **PostgreSQL 客户端**（含 `psql`、`pg_dump`）
  - macOS: `brew install libpq`，然后把 `$(brew --prefix libpq)/bin` 加入 PATH
  - 或安装完整 Postgres: `brew install postgresql@15`
- 能访问 **Railway 控制台**（拿到 `DATABASE_URL`）
- 已有 **阿里云账号**，并已开通 **RDS PostgreSQL**

### 2. 在阿里云创建 RDS PostgreSQL

1. 登录 [阿里云 RDS 控制台](https://rdsnext.console.aliyun.com/)
2. **创建实例**：产品选 **PostgreSQL**，选地域（建议与 OSS/后端同地域，如华东1）、规格、存储，设置**高权限账号**和密码。
3. **创建数据库**：
   - 实例创建完成后，在实例详情里点 **「数据库管理」** → **「创建数据库」**
   - 数据库名建议：`venues`（与当前项目一致）
   - 字符集：UTF8
4. **白名单**：
   - **「数据安全性」** → **「白名单设置」**
   - 若后端在 **Railway**：可先加 `0.0.0.0/0` 放行（仅用于迁移和测试，生产建议改回固定 IP 或 VPC）
   - 若后端在 **阿里云 ECS**：添加该 ECS 的内网 IP 或所在安全组
5. **外网地址**（可选）：
   - 若从**本机**执行迁移：需在 **「数据库连接」** 里**开启外网地址**，并确保本机 IP 在白名单中。
6. **PostGIS 扩展**：
   - 在 RDS 控制台该实例下，**「数据库管理」** → 选中刚建的库 → **「扩展」** 或通过 DMS/SQL 执行：
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```
   - 若控制台不支持，可用 DMS 或 `psql` 连接该库后执行上述 SQL。

记下：

- **连接地址**（内网或外网，例如 `pgm-xxx.pg.rds.aliyuncs.com`）
- **端口**（一般为 5432）
- **高权限账号 / 数据库名 / 密码**

---

## 二、从 Railway 导出数据

### 方式 A：用项目自带脚本（推荐）

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
chmod +x migrate-railway-to-aliyun.sh
./migrate-railway-to-aliyun.sh export
```

按提示输入 **Railway 的 DATABASE_URL**（在 Railway 项目 → Postgres 服务 → Variables 里复制），脚本会生成 `railway_dump_YYYYMMDD_HHMMSS.sql`。

### 方式 B：本机用 pg_dump

1. 在 **Railway** → 你的项目 → **Postgres** → **Variables** 里复制 `DATABASE_URL`（形如 `postgresql://postgres:密码@主机:5432/railway`）。
2. 在终端执行（把 `你的DATABASE_URL` 换成实际连接串，注意密码中的特殊字符要 URL 编码）：

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api

# 导出为自定义格式（推荐，便于压缩和恢复）
pg_dump "你的DATABASE_URL" \
  --format=custom \
  --no-owner \
  --no-acl \
  -f railway_dump_$(date +%Y%m%d_%H%M%S).dump

# 或导出为纯 SQL（便于查看和编辑）
pg_dump "你的DATABASE_URL" \
  --no-owner \
  --no-acl \
  -f railway_dump_$(date +%Y%m%d_%H%M%S).sql
```

若 Railway 要求 SSL，可先设环境变量再执行：

```bash
export PGSSLMODE=require
pg_dump "你的DATABASE_URL" ...
```

---

## 三、导入到阿里云 RDS

### 方式 A：用项目自带脚本

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
./migrate-railway-to-aliyun.sh import
```

按提示输入：

- 阿里云 RDS **主机、端口、用户名、密码、数据库名**
- 上一步生成的 **dump 文件路径**（例如 `railway_dump_20250124_120000.sql`）

### 方式 B：本机用 psql / pg_restore

**若是 .sql 文件：**

```bash
psql "postgresql://用户名:密码@阿里云RDS地址:5432/数据库名?sslmode=require" -f railway_dump_YYYYMMDD_HHMMSS.sql
```

**若是 .dump（custom 格式）：**

```bash
pg_restore -d "postgresql://用户名:密码@阿里云RDS地址:5432/数据库名?sslmode=require" \
  --no-owner --no-acl \
  railway_dump_YYYYMMDD_HHMMSS.dump
```

导入前建议在阿里云库中先建好 PostGIS（见上文），否则依赖 PostGIS 的表可能报错。

---

## 四、后端改为连接阿里云

后端通过 **DATABASE_URL** 连接数据库；迁移后改为阿里云 RDS 即可。

### 连接串格式

```
postgresql://用户名:密码@阿里云RDS主机:5432/数据库名
```

若 RDS 要求 SSL，可加参数：

```
postgresql://用户名:密码@阿里云RDS主机:5432/数据库名?sslmode=require
```

密码中若有 `@ # /` 等特殊字符，需做 URL 编码。

### 1. 后端部署在 Railway 时

1. 打开 **Railway** → 你的项目 → **后端 API 服务** → **Variables**。
2. 修改 **DATABASE_URL**：
   - 删除原来的 Railway Postgres 引用。
   - 新建变量：名称 `DATABASE_URL`，值 = 上面的阿里云连接串。
3. **DB_SSL**：若阿里云 RDS 使用 SSL，则设 `DB_SSL=true`，否则可设为 `false` 或删除。
4. 保存后等待 **重新部署**，在 **Deployments / Logs** 中确认无数据库连接错误。

### 2. 后端在阿里云 ECS 或本地时

在 **Server/api** 的 `.env` 中：

```env
# 阿里云 RDS
DATABASE_URL=postgresql://用户名:密码@阿里云RDS主机:5432/数据库名
DB_SSL=true
# 若 RDS 未开 SSL，可改为 DB_SSL=false 或删掉

PORT=4000
JWT_SECRET=你的密钥
# OSS 等其它变量保持不变
```

保存后重启后端。

---

## 五、校验迁移结果

1. **表与数据**  
   用 DMS 或 `psql` 连阿里云库，检查：
   - 表是否齐全（如 `user`、`venue`、`venue_image`、`review`、`page_view` 等）。
   - 记录数是否与 Railway 一致（可对比主要表的 `SELECT count(*)`）。

2. **应用**  
   - 登录、场地列表、图片、评论等是否正常。
   - 若有报错，看后端日志中的数据库错误信息，并对照 [数据库连接问题解决.md](./数据库连接问题解决.md) 或 [ALIYUN_DB_SETUP.md](./ALIYUN_DB_SETUP.md)。

3. **PostGIS**  
   若项目用到了地理字段，在阿里云库执行：

   ```sql
   SELECT PostGIS_Version();
   ```

   并检查带 `geom` 等字段的表数据是否正常。

---

## 六、迁移后可选操作

- **Railway**：若不再使用 Railway 的 Postgres，可在项目里删除该服务以节省费用。
- **备份**：在阿里云 RDS 控制台开启自动备份策略。
- **安全**：若曾为迁移临时放开白名单，迁移完成后改回仅允许后端所在 IP 或 VPC 访问。

---

## 七、脚本说明

项目中的 **migrate-railway-to-aliyun.sh** 提供：

- `./migrate-railway-to-aliyun.sh export`：按提示输入 Railway `DATABASE_URL`，导出到当前目录的 `.sql` 文件。
- `./migrate-railway-to-aliyun.sh import`：按提示输入阿里云连接信息和 dump 文件路径，执行 `psql ... -f` 导入。

执行前请确保本机已安装 `pg_dump`、`psql`，并已把阿里云 RDS 白名单放开（若从本机导入）。
