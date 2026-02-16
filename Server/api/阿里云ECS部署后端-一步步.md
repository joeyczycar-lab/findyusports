# 阿里云 ECS 部署后端 — 具体一步步（可直接照着点）

下面每步都写清楚在哪个页面、点哪里、填什么、执行什么命令。

---

## 准备清单（先凑齐这些再动手）

在开始前，把这些值准备好，填到下面表格里，后面直接复制粘贴用：

| 要填的内容 | 从哪里获取 | 我的值（示例） |
|------------|------------|----------------|
| **RDS 连接地址** | 见下文「如何拿到 RDS 地址」 | `pgm-bp13c80a190u3sk6io.pg.rds.aliyuncs.com` |
| **RDS 端口** | 一般是 5432 | `5432` |
| **RDS 账号** | 你建 RDS 时创建的（如 fysport） | `fysport` |
| **RDS 密码** | 你设的数据库密码 | `********` |
| **JWT_SECRET** | Railway 项目变量里复制，或本地 .env | `********` |
| **OSS_ACCESS_KEY_ID** | 见下文「如何拿到 OSS 密钥」 | `LTAI5t...` |
| **OSS_ACCESS_KEY_SECRET** | 同上 | `********` |
| **OSS_REGION** | 你的 Bucket 所在地域，如华东1 | `oss-cn-hangzhou` |
| **OSS_BUCKET** | OSS 控制台 Bucket 名称 | `venues-images` |
| **OSS_HOTLINK_SECRET** | 自己设的一串密钥（和现有一致） | `********` |
| **ECS 公网 IP** | 买好 ECS 后，实例详情里 | `115.29.162.135` |
| **Git 仓库地址** | 你的 findyusports 仓库 | `https://github.com/joeyczycar-lab/findyusports.git` |

---

## 如何拿到 RDS 地址

1. 打开：https://rdsnext.console.aliyun.com  
2. 左上角选和 ECS **同一地域**（如华东1）。  
3. 点 **实例列表** → 点你的 PostgreSQL 实例 ID。  
4. 在 **数据库连接** 区域：
   - 若 ECS 和 RDS 同 VPC：用 **内网地址**（形如 `pgm-xxx.pg.rds.aliyuncs.com`）。  
   - 若不同 VPC 或先试通：用 **外网地址**（需先点「申请外网地址」）。  
5. 记下 **连接地址**、**端口**（一般 5432）、**高权限账号名**（如 fysport）和密码。  
6. 拼成：`postgresql://账号:密码@连接地址:5432/venues`  
   - 示例：`postgresql://fysport:我的密码@pgm-bp13c80a190u3sk6io.pg.rds.aliyuncs.com:5432/venues`  
   - 密码里如有 `@#` 等特殊字符，需要 URL 编码（如 `@` 写成 `%40`）。

---

## 如何拿到 OSS 密钥（AccessKey）

1. 打开：https://ram.console.aliyun.com/users  
2. 点 **创建用户** → 登录名称随便（如 `api-oss`）→ 勾选 **OpenAPI 调用** → 确定。  
3. 在用户列表点刚建的用户 → **认证管理** → **创建 AccessKey** → 选「继续使用」→ 记下 **AccessKey ID** 和 **AccessKey Secret**（只显示一次）。  
4. 在 **权限管理** 里给该用户加 **AliyunOSSFullAccess**（或只读+写你用的 Bucket）。  
5. OSS 控制台：https://oss.console.aliyun.com → 记下 **Bucket 名称** 和 **地域**（如 oss-cn-hangzhou）。

---

## 如何拿到 JWT_SECRET（和现有用户一致）

- **若后端在 Railway 跑过**：Railway 项目 → **Variables** → 找到 `JWT_SECRET` → 复制。  
- **若只在本地跑过**：打开本机 `Server/api/.env`，复制 `JWT_SECRET=` 后面的整串。  
- 不能乱改，否则已有用户登录会失效。

---

# 第一步：买 ECS（控制台具体点哪里）

1. 打开：https://ecs.console.aliyun.com  
2. 左上角地域选 **华东1（杭州）**（和 RDS、OSS 一致）。  
3. 点 **创建实例**。  
4. 按下面选（其余可默认）：
   - **付费模式**：按量付费 或 包年包月。  
   - **地域**：华东1。  
   - **实例规格**：选 ** ecs.t6-c1m2.large**（1 核 2G）或更小 **ecs.t6-c1m1.large**（1 核 1G）。  
   - **镜像**：**Alibaba Cloud Linux 3.x** 或 **Ubuntu 22.04**。  
   - **网络**：选已有 **专有网络 VPC**（若 RDS 在同一 VPC 更好）。  
   - **公网 IP**：勾选 **分配公网 IPv4**。  
   - **安全组**：选默认或新建一个（后面会改规则）。  
   - **登录凭证**：选 **密钥对**（需先创建密钥并下载 .pem）或 **密码**（自己设 root 密码）。  
5. 点 **确认订单** → 开通。  
6. 在 **实例列表** 里点你的实例 → 在 **实例详情** 里记下 **公网 IP**（当前为 `115.29.162.135`）。

---

# 第二步：SSH 登录 ECS（本机执行）

**用密钥登录**（把路径和 IP 换成你的）：

```bash
ssh -i /path/to/你的密钥.pem root@115.29.162.135
```

**用密码登录**：

```bash
ssh root@115.29.162.135
# 提示时输入 root 密码
```

登录成功后，终端前面会变成 `[root@iZxxx ~]#`，表示已在 ECS 上。

---

# 第三步：在 ECS 上装 Node 18 和 Git（一条条执行）

下面按 **Alibaba Cloud Linux 3** 写；若是 **Ubuntu**，把 `yum` 换成 `apt`，把 `yum install` 换成 `apt install`。

```bash
# 1. 安装 Node.js 18（NodeSource）
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# 2. 验证（必须看到 v18 和版本号）
node -v
npm -v

# 3. 安装 Git
sudo yum install -y git
git --version
```

若是 **Ubuntu**，用：

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt update
sudo apt install -y nodejs git
node -v
npm -v
```

---

# 第四步：拉代码并构建（路径固定用 /var/www）

在 ECS 上**逐行**执行（把仓库地址换成你的）：

```bash
sudo mkdir -p /var/www
sudo chown $USER:$USER /var/www
cd /var/www
git clone https://github.com/joeyczycar-lab/findyusports.git
cd findyusports/Server/api
npm ci
npm run build
```

若仓库是**私有**，用（把 `你的token` 换掉）：

```bash
git clone https://你的token@github.com/joeyczycar-lab/findyusports.git
```

构建成功后执行：

```bash
ls -la dist/main.js
```

应看到一行带 `dist/main.js` 的文件信息。

---

# 第五步：写 .env 文件（一字不差照着改）

在 ECS 上执行：

```bash
cd /var/www/findyusports/Server/api
nano .env
```

在 nano 里**整段粘贴**下面内容，然后**只改其中 6 处**（见括号说明）：

```env
PORT=4000
NODE_ENV=production

DATABASE_URL=postgresql://fysport:这里填RDS密码@这里填RDS连接地址:5432/venues
DB_SSL=false

JWT_SECRET=这里填和Railway或本地一致的JWT密钥

OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=这里填AccessKeyId
OSS_ACCESS_KEY_SECRET=这里填AccessKeySecret
OSS_BUCKET=这里填你的Bucket名
OSS_HOTLINK_SECRET=这里填防盗链密钥
```

**具体替换示例**（勿直接抄，用你的值）：

- `DATABASE_URL`：若 RDS 内网地址是 `pgm-bp13c80a190u3sk6io.pg.rds.aliyuncs.com`，密码是 `MyPass123`，则写成：  
  `postgresql://fysport:MyPass123@pgm-bp13c80a190u3sk6io.pg.rds.aliyuncs.com:5432/venues`
- `JWT_SECRET`：从 Railway 或本地 .env 整段复制，不要多空格。
- `OSS_*`：从准备清单里复制。

**保存并退出 nano**：  
按 `Ctrl+O` → 回车 → 再按 `Ctrl+X`。

**检查是否写对**（不要泄露到别人）：

```bash
cat .env | grep -v SECRET | grep -v KEY
```

应能看到 PORT、DATABASE_URL 前半段、OSS_REGION、OSS_BUCKET 等，没有报错即可。

---

# 第六步：用 PM2 启动并设开机自启

在 ECS 上执行：

```bash
sudo npm install -g pm2
cd /var/www/findyusports/Server/api
pm2 start dist/main.js --name api
```

应看到类似：

```
[PM2] Starting dist/main.js in fork_mode
[PM2] Done.
┌─────┬──────┬─────────────┬─────────┬─────────┬──────────┐
│ id  │ name │ mode        │ status  │ ...     │          │
│ 0   │ api  │ fork        │ online  │ ...     │          │
└─────┴──────┴─────────────┴─────────┴─────────┴──────────┘
```

接着：

```bash
pm2 save
pm2 startup
```

`pm2 startup` 会输出一行以 `sudo env PATH=...` 开头的命令，**整行复制到终端再执行一次**，这样重启 ECS 后 api 也会自启。

**在 ECS 本机测**：

```bash
curl -s http://127.0.0.1:4000/health
```

应返回一段 JSON（如 `{"status":"ok",...}`）。若没有，先看日志：

```bash
pm2 logs api --lines 50
```

根据报错修（常见：DATABASE_URL 错、RDS 白名单没加 ECS 内网 IP 等）。

---

# 第七步：安全组放行 4000 端口（控制台具体点哪里）

1. 打开：https://ecs.console.aliyun.com  
2. 地域选 **华东1**，点 **实例与镜像** → **实例**。  
3. 点你的 ECS **实例 ID** 进入详情。  
4. 左侧点 **安全组**（或本页「安全组」那一行右侧 **配置规则**）。  
5. 点 **入方向** → **手动添加**（或 **添加规则**）。  
6. 填：
   - **授权策略**：允许  
   - **协议类型**：TCP  
   - **端口范围**：**4000/4000**  
   - **授权对象**：**0.0.0.0/0**  
   - **描述**：api  
7. 保存。

**在你自己的电脑上测**：

```bash
curl -s http://115.29.162.135:4000/health
```

能返回 JSON 说明外网已通。

---

# 第八步：Vercel 改 API 地址（不再走 Railway）

1. 打开：https://vercel.com → 登录 → 点进你的 **前端项目**（findyusports 或 webapp）。  
2. 顶部点 **Settings** → 左侧点 **Environment Variables**。  
3. 找到 **NEXT_PUBLIC_API_BASE**：
   - 若已有：点右侧 **Edit**，把 Value 改成：`http://115.29.162.135:4000`，选 **Production**（和 Preview 如需要），Save。  
   - 若没有：**Key** 填 `NEXT_PUBLIC_API_BASE`，**Value** 填 `http://115.29.162.135:4000`，选 Environment 后 Save。  
4. 顶部点 **Deployments** → 最新一次部署右侧 **⋯** → **Redeploy** → 确认。  
5. 等部署完成，用浏览器打开你的网站，试登录、列表、上传图片，确认都走新后端。

---

# 以后更新代码怎么部署（在 ECS 上执行）

```bash
cd /var/www/findyusports
git pull
cd Server/api
npm ci
npm run build
pm2 restart api
```

可写成脚本，例如：

```bash
nano /var/www/findyusports/Server/api/deploy.sh
```

内容：

```bash
#!/bin/bash
set -e
cd /var/www/findyusports
git pull
cd Server/api
npm ci
npm run build
pm2 restart api
echo "Done."
```

保存后：

```bash
chmod +x /var/www/findyusports/Server/api/deploy.sh
```

以后更新只需：

```bash
/var/www/findyusports/Server/api/deploy.sh
```

---

# 常见问题

- **curl 连不上 / 超时**：检查安全组是否放了 4000；检查 ECS 本机 `curl http://127.0.0.1:4000/health` 是否正常。  
- **启动报错 DATABASE_URL / 数据库连接失败**：检查 .env 里 `DATABASE_URL` 是否和 RDS 控制台一致；RDS **白名单**要加入 ECS 的**内网 IP**（若用内网）或 **0.0.0.0/0**（若用外网，仅测试用）。  
- **401 / 未授权**：确认 Vercel 的 `NEXT_PUBLIC_API_BASE` 已改成 ECS 地址并完成 Redeploy；浏览器清缓存或无痕再试。  
- **上传图片仍慢**：确认 ECS 和 OSS、RDS 同地域；OSS 用内网 endpoint 可再降延迟（需 ECS 和 OSS 同地域且同账号）。

做完以上步骤，请求路径就是：**用户 → Vercel → 阿里云 ECS → 阿里云 RDS/OSS**，不再经 Railway，延迟会明显下降。
