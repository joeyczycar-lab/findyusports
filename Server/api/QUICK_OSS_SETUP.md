# 快速配置阿里云 OSS

## 📋 配置步骤（5分钟完成）

### 1. 获取阿里云 OSS 配置信息

#### 1.1 创建 OSS Bucket（如果还没有）

1. 访问 [阿里云 OSS 控制台](https://oss.console.aliyun.com/)
2. 点击 **"创建 Bucket"**
3. 填写信息：
   - **Bucket 名称**：`venues-images`（或自定义，需全局唯一）
   - **地域**：选择离你最近的地域（如：`华东1（杭州）`）
   - **读写权限**：选择 **"公共读"**
4. 点击 **"确定"** 完成创建
5. **记录**：Bucket 名称和地域代码（如：`oss-cn-hangzhou`）

#### 1.2 获取 AccessKey

1. 在阿里云控制台右上角，点击 **头像** → **"AccessKey 管理"**
2. 如果还没有 AccessKey，点击 **"创建 AccessKey"**
3. **重要**：AccessKey Secret 只显示一次，请立即保存！
4. **记录**：
   - AccessKey ID
   - AccessKey Secret

### 2. 配置 .env 文件

打开 `Server/api/.env` 文件，找到以下配置（目前被注释了）：

```env
# 阿里云OSS配置（可选，如果需要图片上传功能）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
```

**修改为**（取消注释并填入真实值）：

```env
# 阿里云OSS配置
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=LTAI5tAbCdEfGhIjK1mNpQxX
OSS_ACCESS_KEY_SECRET=3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo
OSS_BUCKET=venues-images
```

**说明**：
- 将 `oss-cn-hangzhou` 替换为你创建 Bucket 时选择的地域代码
- 将 `LTAI5tAbCdEfGhIjK1mNpQxX` 替换为你的 AccessKey ID
- 将 `3xK9mPqR5sTvW7yZ1aBcDeFgHiJkLmNo` 替换为你的 AccessKey Secret
- 将 `venues-images` 替换为你创建的 Bucket 名称

### 3. 验证配置

运行配置检查脚本：

```bash
cd Server/api
./check-oss-config.sh
```

如果看到 "✅ 所有必需的 OSS 配置项都已正确配置！"，说明配置成功。

### 4. 重启后端服务

```bash
cd Server/api
npm run dev
```

### 5. 测试图片上传

1. 访问场地详情页面
2. 点击 "+ 添加图片" 按钮
3. 选择一张图片上传
4. 如果上传成功并显示图片，说明配置完成！

---

## 🔍 配置检查清单

- [ ] 已创建 OSS Bucket
- [ ] Bucket 权限设置为"公共读"
- [ ] 已获取 AccessKey ID 和 Secret
- [ ] 已在 `.env` 文件中取消注释并填入真实值
- [ ] 运行 `./check-oss-config.sh` 检查通过
- [ ] 已重启后端服务
- [ ] 已测试图片上传功能

---

## ❓ 常见问题

### Q: 如何查看地域代码？

A: 在阿里云 OSS 控制台的 Bucket 列表中，点击你的 Bucket，在"概览"页面可以看到"访问域名"，例如：
- `venues-images.oss-cn-hangzhou.aliyuncs.com` → 地域代码是 `oss-cn-hangzhou`
- `venues-images.oss-cn-beijing.aliyuncs.com` → 地域代码是 `oss-cn-beijing`

### Q: AccessKey Secret 忘记了怎么办？

A: AccessKey Secret 只显示一次，如果忘记了，需要：
1. 删除旧的 AccessKey
2. 创建新的 AccessKey
3. 更新 `.env` 文件中的配置

### Q: 配置后仍然提示 "OSS未配置"？

A: 请检查：
1. `.env` 文件中的配置是否取消了注释（没有 `#` 号）
2. 配置值是否正确（没有多余的空格或引号）
3. 是否重启了后端服务

---

## 📚 详细文档

- 完整配置指南：`OSS_CONFIG_GUIDE.md`
- 快速设置：`OSS_SETUP.md`
- Railway 部署配置：`RAILWAY_OSS_SETUP.md`
