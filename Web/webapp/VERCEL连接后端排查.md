# 网页「无法连接到后端服务」排查步骤

当出现 **「无法连接到后端服务」「图片处理上传失败: fetch failed」** 时，按下面顺序检查。

---

## 1. 确认 Railway 后端在运行

1. 打开 https://railway.app → 你的项目 → 点击 **findyusports（后端服务）**。
2. 看服务状态是否为 **Online**（绿点）。
3. 打开 **Deployments**，看最新一次部署是否为 **Success**；若失败或一直在部署，先等部署完成或查看 Logs 排错。
4. 在浏览器新标签页访问后端健康检查（把下面的地址换成你 Railway 后端的真实地址）：
   - `https://findyusports-production.up.railway.app/health`
   - 或 `https://你的后端域名/health`
5. 若页面显示 `{"status":"ok",...}` 且无报错，说明后端已启动且可从公网访问；若打不开或超时，说明后端未跑起来或地址不对。

---

## 2. 确认前端用的后端地址正确（Vercel）

1. 打开 https://vercel.com → 你的前端项目（webapp）→ **Settings** → **Environment Variables**。
2. 查看是否有 **`NEXT_PUBLIC_API_BASE`**：
   - **有**：值应为 Railway 后端的**根地址**，且**不要**末尾斜杠，例如：
     - `https://findyusports-production.up.railway.app`
   - **没有**：前端在生产环境会使用代码里的默认地址 `https://findyusports-production.up.railway.app`；若你的后端不是这个地址，必须新增 `NEXT_PUBLIC_API_BASE` 并设为你的后端根地址。
3. 若你刚改过该变量，保存后需 **重新部署** 前端（Deployments → 最新部署 → Redeploy），否则可能仍用旧值。

---

## 3. 确认后端地址可从公网访问

- 在浏览器或命令行测试（把 `你的后端根地址` 换成上面配置的地址）：
  - 健康检查：`https://你的后端根地址/health`
  - 若用 curl：`curl -s -o /dev/null -w "%{http_code}" https://你的后端根地址/health`，应得到 `200`。
- 若这里就超时或无法访问，问题在后端或网络，而不是前端配置；需回到 Railway 检查服务是否在线、域名是否正确。

---

## 4. 常见原因小结

| 现象 | 可能原因 | 处理方式 |
|------|----------|----------|
| 一直「无法连接」 | Railway 后端未启动或部署失败 | Railway → 后端服务 → Deployments/Logs 排查 |
| 一直「无法连接」 | 前端用的后端地址错误 | Vercel 检查 `NEXT_PUBLIC_API_BASE`，改对后重新部署前端 |
| 有时能连有时不能 | 后端重启、冷启动或超时 | Railway 看 Logs；上传大图时可能需更长时间，属正常波动 |
| 仅上传图片失败 | 后端连 OSS 超时（Railway→阿里云） | 已做串行上传+重试；若仍频繁失败，可考虑后端迁国内或换海外图床 |

---

## 5. 本地开发时

- 确保本机已启动后端（例如在 `Server/api` 下执行 `npm run start`，默认端口 4000）。
- 前端若连本地后端，在 webapp 根目录 `.env.local` 中设置：
  - `NEXT_PUBLIC_API_BASE=http://localhost:4000`
- 保存后重启前端 dev 服务器。

按以上步骤检查后，若某一步结果与预期不符，可以把那一步的现象（截图或报错原文）发出来继续排查。
