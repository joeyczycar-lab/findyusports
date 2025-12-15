# 阿里云 OSS 配置说明

图片上传功能需要配置阿里云 OSS（对象存储服务）。

## 配置步骤

### 1. 创建阿里云 OSS Bucket

1. 登录 [阿里云控制台](https://oss.console.aliyun.com/)
2. 创建 Bucket（存储桶）
   - 名称：建议使用 `venues-images` 或自定义
   - 地域：选择离你最近的地域（如 `oss-cn-hangzhou`）
   - 读写权限：选择"公共读"（Public Read）

### 2. 获取 AccessKey

1. 在阿里云控制台，点击右上角头像 → "AccessKey 管理"
2. 创建 AccessKey（如果还没有）
3. 记录以下信息：
   - `AccessKey ID`
   - `AccessKey Secret`

### 3. 配置环境变量

编辑 `Server/api/.env` 文件，添加以下配置：

```env
# 阿里云OSS配置
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=your_access_key_id
OSS_ACCESS_KEY_SECRET=your_access_key_secret
OSS_BUCKET=venues-images

# 防盗链配置（可选）
OSS_HOTLINK_SECRET=your_hotlink_secret_key
```

**重要提示：**
- 将 `your_access_key_id` 替换为你的 AccessKey ID
- 将 `your_access_key_secret` 替换为你的 AccessKey Secret
- 将 `oss-cn-hangzhou` 替换为你创建 Bucket 时选择的地域
- 将 `venues-images` 替换为你创建的 Bucket 名称

### 4. 重启后端服务

配置完成后，重启后端服务：

```powershell
cd F:\Findyu\Server\api
npm run dev
```

## 验证配置

配置完成后，尝试上传一张图片到场地详情页面。如果配置正确，图片应该能够成功上传。

## 常见问题

### 错误：OSS未配置
- **原因**：`.env` 文件中缺少 OSS 配置或配置不正确
- **解决**：检查 `.env` 文件中的 `OSS_ACCESS_KEY_ID` 和 `OSS_ACCESS_KEY_SECRET` 是否正确

### 错误：上传失败
- **原因**：可能是 Bucket 权限设置不正确
- **解决**：确保 Bucket 的读写权限设置为"公共读"

### 错误：签名生成失败
- **原因**：AccessKey 信息不正确或 Bucket 名称/地域不匹配
- **解决**：检查 `.env` 文件中的配置是否与阿里云控制台中的信息一致

## 临时方案（开发环境）

如果你暂时不想配置 OSS，可以：

1. **使用本地存储**（仅限开发环境）：
   - 修改代码，将图片保存到本地 `public/uploads` 目录
   - 注意：这种方式不适合生产环境

2. **使用其他云存储服务**：
   - 腾讯云 COS
   - 七牛云
   - AWS S3
   - 需要修改 `Server/api/src/modules/oss/oss.service.ts` 中的实现

## 安全建议

1. **不要将 `.env` 文件提交到 Git**
2. **使用子账号的 AccessKey**，而不是主账号的
3. **设置 AccessKey 的最小权限**，只授予 OSS 相关权限
4. **定期轮换 AccessKey**


