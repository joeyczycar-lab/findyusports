# Railway 数据库配置 — 具体怎么做

按下面步骤做，后端在 Railway 上就会一直用 Railway 的 PostgreSQL，不会连本机。

---

## 一、在 Railway 网页里配置（部署上去的接口用 Railway 数据库）

### 1. 打开项目

1. 打开 https://railway.app 并登录。
2. 进入你的项目（例如 findyusports）。

### 2. 确保有 PostgreSQL 服务

- 在项目里能看到一个 **Postgres** 服务（带大象图标）。
- 如果没有：点 **"+ New"** → **"Database"** → **"Add PostgreSQL"**，等创建完成。

### 3. 把数据库连到你的后端服务

**方式 A：用 “Variables” 引用（推荐）**

1. 点你的 **后端 API 服务**（例如 findyusports / findyusports-production）。
2. 点 **"Variables"** 标签。
3. 点 **"Add Variable"** 或 **"New Variable"**。
4. 在 **"Add a variable from another service"** 或 **"Reference"** 里，选择 **Postgres** 服务提供的变量，例如：
   - `DATABASE_URL`  
   - 或 `POSTGRES_URL`（如果有的话，可以重命名/引用为 `DATABASE_URL`）
5. 保存后，Railway 会自动把数据库连接串注入到后端环境里，变量名就是 `DATABASE_URL`。

**方式 B：从 Postgres 里复制再粘贴**

1. 点 **Postgres** 服务 → **"Variables"** 或 **"Connect"** 标签。
2. 找到 **`DATABASE_URL`** 或 **`POSTGRES_URL`**，复制整串（形如 `postgresql://postgres:xxx@xxx.railway.app:5432/railway`）。
3. 点你的 **后端 API 服务** → **"Variables"** → **"Add Variable"**。
4. 名称填：`DATABASE_URL`  
   值贴：刚才复制的连接串。  
   保存。

### 4. 打开 SSL（Railway Postgres 一般要开）

在**同一个后端服务**的 Variables 里再加一条：

- 名称：`DB_SSL`  
- 值：`true`  

保存。

### 5. 其他建议变量（同一后端服务）

建议在后端服务的 Variables 里还有：

| 变量名 | 说明 |
|--------|------|
| `JWT_SECRET` | 随便一串长字符串（至少 20 字符），不要空着。 |
| （可选）OSS 相关 | 若用阿里云 OSS 传图，按 RAILWAY_OSS_SETUP.md 配。 |

### 6. 重新部署

- 改完 Variables 后，点 **"Deploy"** 或等自动重新部署。
- 部署完成后看 **"Deployments"** / **"Logs"**，应能看到类似：  
  `✅ [Main] 使用 Railway 数据库 (DATABASE_URL)`、`✅ [DB Module] Using DATABASE_URL (Railway)`。  
  若看到 `DATABASE_URL is required in production` 并退出，说明后端没拿到 `DATABASE_URL`，回到第 3 步检查变量是否加在了**后端服务**上。

---

## 二、本地开发想连 Railway 数据库时（可选）

只在“本地跑后端、但要连 Railway 上的库”时需要：

1. 在 **Railway** → **Postgres** → **Variables** 里复制 `DATABASE_URL`（或从后端服务 Variables 里复制）。
2. 在电脑上打开项目里的 `Server/api/.env`（没有就复制 `.env.example` 再改）。
3. 在 `.env` 里写（注意替换成你复制的值）：

```env
# 使用 Railway 的数据库（从 Railway 控制台复制）
DATABASE_URL=postgresql://postgres:xxxxx@xxxxx.railway.app:5432/railway
DB_SSL=true

# 本地端口（可选）
PORT=4000
JWT_SECRET=你的密钥
```

4. 保存后，在 `Server/api` 下执行 `npm run start`，本地也会连 Railway 数据库。

---

## 三、检查是否生效

- **Railway 部署的后端**：看 Logs 里是否有  
  `✅ [Main] 使用 Railway 数据库 (DATABASE_URL)`、  
  `✅ [DB Module] Using DATABASE_URL (Railway)`。  
  没有或报错 `DATABASE_URL is required`，就是变量没配对或没配在后端服务上。
- **本地**：能正常启动且能登录、能查场地，说明已连上 Railway 数据库。

按上面“一”做完，部署在 Railway 上的接口就会**一直用 Railway 数据库**；需要本地也连 Railway 时再按“二”配 `.env` 即可。
