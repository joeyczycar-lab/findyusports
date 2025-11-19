# 网站部署指南

本文档提供多种部署方案，从最简单到最灵活，你可以根据需求选择。

---

## 方案一：最简单（推荐新手）

### 前端：Vercel（免费）
### 后端+数据库：Railway 或 Render（免费额度）

#### 步骤 1：部署后端到 Railway

1. **注册 Railway**
   - 访问 https://railway.app
   - 用 GitHub 账号登录

2. **创建新项目**
   - 点击 "New Project"
   - 选择 "Deploy from GitHub repo"
   - 选择你的仓库，路径选择 `Server/api`

3. **配置环境变量**
   在 Railway 项目设置中添加（后续可以引用自动注入的 `DATABASE_URL`）：
   ```
   PORT=4000
   DATABASE_URL=${{DATABASE_URL}}   # 选择变量后插入
   DB_SSL=true                      # 如果 Railway/云数据库要求 SSL
   JWT_SECRET=随机生成的长字符串
   OSS_REGION=oss-cn-hangzhou
   OSS_ACCESS_KEY_ID=你的阿里云AccessKey
   OSS_ACCESS_KEY_SECRET=你的阿里云Secret
   OSS_BUCKET=venues-images
   OSS_HOTLINK_SECRET=随机字符串
   ```

4. **添加 Postgres 数据库**
   - 在 Railway 项目中点击 "+ New"
   - 选择 "Database" → "Add PostgreSQL"
   - Railway 会自动创建并注入 `DATABASE_URL` 环境变量

5. **运行数据库迁移**
   - Railway 部署后，在项目设置中找到 "Deploy Logs"
   - 或者使用 Railway CLI：
     ```bash
     railway run npm run migration:run
     railway run npm run seed
     ```

6. **获取后端地址**
   - Railway 会自动分配一个域名，如：`https://your-api.up.railway.app`
   - 记下这个地址

#### 步骤 2：部署前端到 Vercel

1. **注册 Vercel**
   - 访问 https://vercel.com
   - 用 GitHub 账号登录

2. **导入项目**
   - 点击 "Add New Project"
   - 选择你的 GitHub 仓库
   - **Root Directory** 设置为 `Web/webapp`

3. **配置环境变量**
   在 Vercel 项目设置中添加：
   ```
   NEXT_PUBLIC_API_BASE=https://your-api.up.railway.app
   NEXT_PUBLIC_AMAP_KEY=你的高德地图API Key
   ```

4. **部署**
   - Vercel 会自动检测 Next.js 并构建
   - 部署完成后会给你一个域名，如：`https://your-site.vercel.app`

#### 完成！
访问 Vercel 给你的域名，网站就可以用了！

---

## 方案二：云服务器（阿里云/腾讯云）

### 需要准备
- 一台云服务器（建议 2核4G 起步）
- 域名（可选，可以用 IP 访问）

### 步骤 1：服务器环境准备

```bash
# 1. 安装 Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 2. 安装 Docker 和 Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get install docker-compose-plugin

# 3. 安装 PM2（进程管理）
sudo npm install -g pm2
```

### 步骤 2：部署数据库

```bash
cd /path/to/your/project/Server/api
docker compose up -d
```

### 步骤 3：部署后端

```bash
cd /path/to/your/project/Server/api

# 1. 安装依赖
npm install --production

# 2. 构建
npm run build

# 3. 创建 .env 文件
cat > .env << EOF
PORT=4000
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=venues
JWT_SECRET=你的JWT密钥
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=你的AccessKey
OSS_ACCESS_KEY_SECRET=你的Secret
OSS_BUCKET=venues-images
OSS_HOTLINK_SECRET=你的防盗链密钥
EOF

# 4. 运行迁移
npm run migration:run
npm run seed

# 5. 用 PM2 启动
pm2 start dist/main.js --name venues-api
pm2 save
pm2 startup  # 设置开机自启
```

### 步骤 4：部署前端

```bash
cd /path/to/your/project/Web/webapp

# 1. 安装依赖
npm install

# 2. 创建 .env.local
cat > .env.local << EOF
NEXT_PUBLIC_API_BASE=http://你的服务器IP:4000
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key
EOF

# 3. 构建
npm run build

# 4. 用 PM2 启动
pm2 start npm --name venues-web -- start
pm2 save
```

### 步骤 5：配置 Nginx（反向代理）

```bash
# 安装 Nginx
sudo apt-get install nginx

# 创建配置文件
sudo nano /etc/nginx/sites-available/venues
```

Nginx 配置内容：
```nginx
server {
    listen 80;
    server_name 你的域名或IP;

    # 前端
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # 后端 API
    location /api {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

```bash
# 启用配置
sudo ln -s /etc/nginx/sites-available/venues /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 步骤 6：配置防火墙

```bash
# 开放 80 和 443 端口
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

---

## 方案三：Docker 容器化部署

### 创建 Dockerfile

#### 后端 Dockerfile (`Server/api/Dockerfile`)
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY --from=builder /app/dist ./dist
EXPOSE 4000
CMD ["node", "dist/main.js"]
```

#### 前端 Dockerfile (`Web/webapp/Dockerfile`)
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["npm", "start"]
```

### 创建 docker-compose.prod.yml

```yaml
version: '3.8'
services:
  db:
    image: postgis/postgis:15-3.4
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=venues
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  api:
    build:
      context: ./Server/api
      dockerfile: Dockerfile
    environment:
      - PORT=4000
      - DB_HOST=db
      - DB_PORT=5432
      - DB_USER=postgres
      - DB_PASS=postgres
      - DB_NAME=venues
      - JWT_SECRET=${JWT_SECRET}
      - OSS_REGION=${OSS_REGION}
      - OSS_ACCESS_KEY_ID=${OSS_ACCESS_KEY_ID}
      - OSS_ACCESS_KEY_SECRET=${OSS_ACCESS_KEY_SECRET}
      - OSS_BUCKET=${OSS_BUCKET}
      - OSS_HOTLINK_SECRET=${OSS_HOTLINK_SECRET}
    depends_on:
      - db
    ports:
      - "4000:4000"

  web:
    build:
      context: ./Web/webapp
      dockerfile: Dockerfile
    environment:
      - NEXT_PUBLIC_API_BASE=http://localhost:4000
      - NEXT_PUBLIC_AMAP_KEY=${NEXT_PUBLIC_AMAP_KEY}
    depends_on:
      - api
    ports:
      - "3000:3000"

volumes:
  pgdata:
```

### 部署

```bash
# 1. 创建 .env 文件（包含所有环境变量）
# 2. 构建并启动
docker compose -f docker-compose.prod.yml up -d

# 3. 运行迁移
docker compose -f docker-compose.prod.yml exec api npm run migration:run
docker compose -f docker-compose.prod.yml exec api npm run seed
```

---

## 重要提醒

### 1. 数据库迁移
无论用哪种方案，部署后都要运行：
```bash
npm run migration:run
npm run seed
```

### 2. 环境变量安全
- **不要**把 `.env` 文件提交到 Git
- 在生产环境使用环境变量管理工具（如 Vercel/Railway 的环境变量设置）

### 3. HTTPS
- Vercel 自动提供 HTTPS
- 云服务器需要配置 SSL 证书（可以用 Let's Encrypt 免费证书）

### 4. 域名绑定
- Vercel：在项目设置中添加自定义域名
- 云服务器：在域名 DNS 设置中添加 A 记录指向服务器 IP

### 5. 监控与日志
- 建议使用 PM2 的监控功能
- 或者使用云服务的日志查看功能

---

## 推荐方案对比

| 方案 | 难度 | 成本 | 适合场景 |
|------|------|------|----------|
| Vercel + Railway | ⭐ 简单 | 免费（有额度限制） | 个人项目、MVP |
| 云服务器 | ⭐⭐⭐ 中等 | 约 50-200元/月 | 需要更多控制权 |
| Docker 容器化 | ⭐⭐⭐⭐ 较难 | 根据服务器 | 企业级、需要扩展 |

**建议**：如果是第一次部署，先用 **方案一（Vercel + Railway）**，最简单快速！

