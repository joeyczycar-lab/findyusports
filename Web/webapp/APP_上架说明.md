# Find遇体育 App 上架说明

本项目使用 **Capacitor** 将网站 https://findyusports.com 打包成可上架应用商店的原生壳 App，与网页端完全同步（壳内直接加载线上网站）。

## 目录结构

- `capacitor.config.ts` - Capacitor 配置（App 名、包名、加载的 URL）
- `android/` - Android 原生工程（Android Studio 打开）
- `ios/` - iOS 原生工程（Xcode 打开，需 macOS）

## 本地运行 / 调试

### Android

1. 安装 [Android Studio](https://developer.android.com/studio)
2. 在项目根目录执行：
   ```bash
   npm run cap:android
   ```
   或手动用 Android Studio 打开 `android` 文件夹
3. 连接真机或启动模拟器，点击 Run

### iOS（仅 macOS）

1. 安装 Xcode
2. 在项目根目录执行：
   ```bash
   npm run cap:ios
   ```
   或手动用 Xcode 打开 `ios/App/App.xcworkspace`
3. 选择真机或模拟器，点击 Run

## 打包与上架

### Android（Google Play）

1. 用 Android Studio 打开 `android` 文件夹
2. **Build → Generate Signed Bundle / APK**，选择 **Android App Bundle (.aab)**（Google Play 要求）
3. 创建或选择密钥库（keystore），按向导完成签名
4. 登录 [Google Play Console](https://play.google.com/console)，创建应用，上传生成的 `.aab` 文件
5. 填写商店信息（描述、截图、隐私政策等），提交审核

### iOS（App Store）

1. 用 Xcode 打开 `ios/App/App.xcworkspace`
2. 在 Xcode 中登录 Apple Developer 账号，选择 **Signing & Capabilities** 配置 Team 和 Bundle ID
3. **Product → Archive**，归档完成后在 Organizer 中 **Distribute App**，选择 **App Store Connect**
4. 登录 [App Store Connect](https://appstoreconnect.apple.com)，创建应用，填写元数据与截图
5. 从 Xcode 上传构建版本，提交审核

## 修改配置

- **App 名称 / 包名**：在 `capacitor.config.ts` 中修改 `appName`、`appId`
- **加载的网址**：在 `capacitor.config.ts` 的 `server.url` 中修改（当前为 `https://findyusports.com`）
- 修改后执行 `npm run cap:sync` 再重新打开 Android Studio / Xcode 构建

## 与网页端同步

App 内直接加载 https://findyusports.com，数据、登录、内容与网页端一致，无需单独维护 App 内容。
