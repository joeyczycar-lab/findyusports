# 阿里云 OSS 详细配置指南

本指南将详细说明如何配置阿里云 OSS 以支持图片上传功能。

## 📋 前置要求

1. 拥有阿里云账号（如果没有，请先注册：https://www.aliyun.com/）
2. 完成实名认证（上传图片功能需要）

---

## 第一步：创建 OSS Bucket（存储桶）

### 1.1 登录阿里云控制台

1. 访问 [阿里云控制台](https://ecs.console.aliyun.com/)
2. 使用你的阿里云账号登录

### 1.2 进入 OSS 控制台

1. 在控制台首页，搜索 "OSS" 或 "对象存储"
2. 点击进入 **"对象存储 OSS"** 服务

### 1.3 创建 Bucket

1. 点击左侧菜单的 **"Bucket 列表"**
2. 点击右上角的 **"创建 Bucket"** 按钮
3. 填写以下信息：

   **基本信息：**
   - **Bucket 名称**：填写 `venues-images`（或你喜欢的名称，需全局唯一）
   - **地域**：选择离你最近的地域，例如：
     - `华东1（杭州）` → 对应代码：`oss-cn-hangzhou`
     - `华东2（上海）` → 对应代码：`oss-cn-shanghai`
     - `华北2（北京）` → 对应代码：`oss-cn-beijing`
     - `华南1（深圳）` → 对应代码：`oss-cn-shenzhen`
   
   **读写权限：**
   - 选择 **"公共读"**（Public Read）
   - ⚠️ 注意：选择"公共读"后，上传的图片可以通过 URL 直接访问

   **其他设置：**
   - **存储类型**：选择 "标准存储"（默认）
   - **同城冗余**：根据需要选择（一般不需要）
   - **版本控制**：关闭（默认）
   - **服务端加密**：关闭（默认）

4. 点击 **"确定"** 完成创建

### 1.4 记录 Bucket 信息

创建成功后，记录以下信息：
- **Bucket 名称**：例如 `venues-images`
- **地域代码**：例如 `oss-cn-hangzhou`
- **访问域名**：例如 `venues-images.oss-cn-hangzhou.aliyuncs.com`

---

## 第二步：获取 AccessKey（访问密钥）

### 2.1 进入 AccessKey 管理页面

1. 在阿里云控制台右上角，点击你的 **头像**
2. 在下拉菜单中选择 **"AccessKey 管理"**
3. 如果提示需要验证，请完成验证

### 2.2 创建 AccessKey

1. 如果还没有 AccessKey，点击 **"创建 AccessKey"**
2. 系统会提示你：
   - 选择验证方式（手机验证码或邮箱验证码）
   - 完成验证后，会显示 AccessKey 信息

### 2.3 保存 AccessKey 信息

⚠️ **重要：AccessKey Secret 只显示一次，请立即保存！**

记录以下信息：
- **AccessKey ID**：例如 `LTAI5tAbCdEfGhIjK1mNpQxX`
- **AccessKey Secret**：例如 `3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo`

**安全提示：**
- 不要将 AccessKey 分享给他人
- 不要将 AccessKey 提交到 Git 仓库
- 建议使用子账号的 AccessKey（见下方"安全建议"）

---

## 第三步：配置项目环境变量

### 3.1 打开 .env 文件

1. 使用文本编辑器打开文件：`F:\Findyu\Server\api\.env`
2. 如果文件不存在，可以创建一个新文件

### 3.2 添加 OSS 配置

在 `.env` 文件中，找到或添加以下配置（取消注释并填入真实值）：

```env
# 阿里云OSS配置
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=LTAI5tAbCdEfGhIjK1mNpQxX
OSS_ACCESS_KEY_SECRET=3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo
OSS_BUCKET=venues-images

# 防盗链配置（可选，暂时可以不配置）
# OSS_HOTLINK_SECRET=your_hotlink_secret_key
```

**配置说明：**
- `OSS_REGION`：填写你在步骤 1.3 中选择的地域代码
- `OSS_ACCESS_KEY_ID`：填写你在步骤 2.3 获取的 AccessKey ID
- `OSS_ACCESS_KEY_SECRET`：填写你在步骤 2.3 获取的 AccessKey Secret
- `OSS_BUCKET`：填写你在步骤 1.3 创建的 Bucket 名称

### 3.3 保存文件

保存 `.env` 文件，确保：
- 没有多余的空格
- 值没有用引号包裹
- 每行一个配置项

---

## 第四步：重启后端服务

### 4.1 停止当前运行的后端服务

如果后端服务正在运行，请先停止它（在运行服务的终端窗口按 `Ctrl+C`）

### 4.2 重新启动后端服务

在 PowerShell 中运行：

```powershell
cd F:\Findyu\Server\api
npm run dev
```

### 4.3 检查启动日志

启动后，检查控制台输出：
- 如果没有错误信息，说明配置成功
- 如果看到 OSS 相关的错误，请检查配置是否正确

---

## 第五步：验证配置

### 5.1 测试图片上传

1. 启动前端服务（如果还没启动）：
   ```powershell
   cd F:\Findyu\Web\webapp
   npm run dev
   ```

2. 访问网站：`http://localhost:3000`

3. 登录账号（如果没有账号，先注册）

4. 访问任意场地详情页面，例如：`http://localhost:3000/venues/1`

5. 点击 **"+ 添加图片"** 按钮

6. 选择一张图片文件（JPG 或 PNG，小于 10MB）

7. 等待上传完成

### 5.2 检查结果

- ✅ **成功**：图片显示在页面上，说明配置正确
- ❌ **失败**：查看错误提示，根据错误信息排查问题

---

## 🔧 常见问题排查

### 问题 1：提示 "OSS未配置"

**原因：** `.env` 文件中的配置没有生效

**解决方法：**
1. 检查 `.env` 文件是否存在
2. 检查配置项是否正确（没有注释符号 `#`）
3. 确保重启了后端服务
4. 检查配置值是否有空格或引号

### 问题 2：提示 "签名生成失败" 或 "AccessDenied"

**原因：** AccessKey 信息不正确或权限不足

**解决方法：**
1. 检查 `OSS_ACCESS_KEY_ID` 和 `OSS_ACCESS_KEY_SECRET` 是否正确
2. 检查 AccessKey 是否被禁用
3. 确保 AccessKey 有 OSS 的访问权限

### 问题 3：提示 "Bucket 不存在"

**原因：** Bucket 名称或地域配置不正确

**解决方法：**
1. 检查 `OSS_BUCKET` 是否与创建的 Bucket 名称完全一致
2. 检查 `OSS_REGION` 是否与创建 Bucket 时选择的地域代码一致
3. 登录阿里云控制台，确认 Bucket 确实存在

### 问题 4：上传成功但图片无法显示

**原因：** Bucket 权限设置不正确

**解决方法：**
1. 登录阿里云 OSS 控制台
2. 找到你的 Bucket，点击进入
3. 点击 **"权限管理"** → **"读写权限"**
4. 确保设置为 **"公共读"**

---

## 🔒 安全建议

### 1. 使用子账号 AccessKey（推荐）

为了安全，建议创建子账号并使用子账号的 AccessKey：

1. 在阿里云控制台，进入 **"访问控制 RAM"**
2. 创建子账号
3. 为子账号授予 OSS 的读写权限
4. 使用子账号的 AccessKey 配置项目

### 2. 限制 AccessKey 权限

如果使用主账号 AccessKey，建议：
- 只授予必要的 OSS 权限
- 不要授予其他服务的权限

### 3. 定期轮换 AccessKey

- 建议每 3-6 个月更换一次 AccessKey
- 更换后，更新 `.env` 文件并重启服务

### 4. 保护 .env 文件

- 确保 `.env` 文件在 `.gitignore` 中（不会被提交到 Git）
- 不要将 `.env` 文件分享给他人
- 在生产环境中，使用环境变量或密钥管理服务

---

## 📝 配置示例

完整的 `.env` 文件示例：

```env
# 服务器配置
PORT=4000

# 数据库配置
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=324714
DB_NAME=venues

# JWT 配置
JWT_SECRET=your_jwt_secret_key_here

# 阿里云OSS配置
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=LTAI5tAbCdEfGhIjK1mNpQxX
OSS_ACCESS_KEY_SECRET=3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo
OSS_BUCKET=venues-images

# 防盗链配置（可选）
OSS_HOTLINK_SECRET=your_hotlink_secret_key
```

---

## ✅ 配置检查清单

完成配置后，请确认：

- [ ] 已创建 OSS Bucket
- [ ] Bucket 权限设置为"公共读"
- [ ] 已获取 AccessKey ID 和 Secret
- [ ] 已在 `.env` 文件中配置了所有 OSS 相关配置
- [ ] 已重启后端服务
- [ ] 已测试图片上传功能
- [ ] 上传的图片可以正常显示

---

## 🆘 需要帮助？

如果遇到问题，请：

1. 查看浏览器控制台的错误信息
2. 查看后端服务的日志输出
3. 检查阿里云 OSS 控制台中的 Bucket 设置
4. 参考 [阿里云 OSS 官方文档](https://help.aliyun.com/product/31815.html)

---

**配置完成后，你就可以正常上传场地图片了！** 🎉


