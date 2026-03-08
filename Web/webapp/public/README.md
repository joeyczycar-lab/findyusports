# Public 目录说明

## 微信二维码图片

请将你的微信二维码图片命名为 `wechat-qrcode.jpg` 并放在此目录下。

### 图片要求：
- 文件名：`wechat-qrcode.jpg`
- 格式：JPG 或 PNG
- 建议尺寸：至少 400x400 像素
- 确保二维码清晰可扫描

### 如何获取二维码：
1. 打开微信
2. 点击右上角 "+" → "添加朋友"
3. 选择 "我的二维码"
4. 截图或保存二维码图片
5. 将图片重命名为 `wechat-qrcode.jpg` 并放到此目录

## APP 下载二维码（导航栏「下载APP」）

网页端顶栏「下载APP」悬停时会显示二维码。请将 APP 下载页或应用商店的二维码图片命名为 `app-download-qrcode.png` 并放在此目录。若未放置该文件，将自动回退显示 `wechat-qrcode.jpg`。

- 文件名：`app-download-qrcode.png`
- 建议尺寸：约 200×200 像素以上，正方形

## 安卓 APK 直链（扫码直接下载）

手机访问 `/app` 时会自动跳转到 APK 下载。请将构建好的安卓安装包命名为 `findyusports.apk` 并放在此目录（`public/findyusports.apk`），这样扫码或访问 https://findyusports.com/app 时即可直接下载。

- 文件名：`findyusports.apk`（必须）
- 来源：执行 `npm run cap:build:android` 或 `npm run cap:build:android:release` 后，将 `android/app/build/outputs/apk/debug/app-debug.apk` 或 `release/app-release.apk` 复制并重命名为 `findyusports.apk` 放到 `public/` 下。

