# 微信二维码图片上传说明

## 文件位置
将微信二维码图片保存为：`public/wechat-qrcode.jpg`

## 图片要求
- 文件名：`wechat-qrcode.jpg`（必须）
- 格式：JPG/JPEG
- 建议尺寸：至少 200x200 像素
- 建议大小：小于 500KB

## 上传步骤

### 方法 1：直接复制文件
1. 将微信二维码图片保存到本地
2. 将图片重命名为 `wechat-qrcode.jpg`
3. 复制到 `Web/webapp/public/` 目录下
4. 刷新页面即可看到

### 方法 2：使用命令行
```bash
# 如果图片在其他位置，可以复制过来
cp /path/to/your/qrcode.jpg Web/webapp/public/wechat-qrcode.jpg
```

### 方法 3：在编辑器中操作
1. 在 VS Code 或 Cursor 中打开 `Web/webapp/public/` 目录
2. 将图片文件拖拽到该目录
3. 重命名为 `wechat-qrcode.jpg`

## 验证
上传后，访问主页（`http://localhost:3000`），在右侧边栏（桌面端）或场地列表下方（移动端）应该能看到微信二维码。

## 注意事项
- 图片路径是 `/wechat-qrcode.jpg`（public 目录下的文件可以直接通过 `/` 访问）
- 如果图片加载失败，组件会显示提示信息
- 确保图片文件名完全匹配：`wechat-qrcode.jpg`（区分大小写）


