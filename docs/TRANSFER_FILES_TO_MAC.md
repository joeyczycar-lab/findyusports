# Windows 到 Mac 文件传输指南

## 📋 传输方式概览

根据文件大小和数量，选择最适合的方式：

| 方式 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| **网盘** | 所有文件 | 方便快捷，支持大文件 | 需要网络 |
| **U盘/移动硬盘** | 大文件/大量文件 | 速度快，不依赖网络 | 需要物理设备 |
| **微信文件传输助手** | 小文件（<100MB） | 最简单 | 文件大小限制 |
| **Git** | 代码和资源文件 | 版本控制 | 不适合大文件 |
| **局域网共享** | 同一网络 | 速度快 | 需要配置 |

---

## 🖼️ 项目中的图片文件

根据扫描，项目中有以下图片文件：

### 前端资源图片
- `Web/webapp/public/wechat-qrcode.jpg` - 微信二维码
- `Web/webapp/public/hero-background.jpg` - 首页背景图

### 其他图片
- `pic/2f8814bf-a2fe-417a-b251-9f6064f2ecdc.png` - 项目图片

---

## 方式 1：网盘传输（推荐）

### 使用百度网盘/OneDrive/Google Drive

**步骤：**

1. **在 Windows 上：**
   ```powershell
   # 压缩图片文件夹
   Compress-Archive -Path "F:\Findyu\Web\webapp\public\*.jpg" -DestinationPath "F:\Findyu\images.zip"
   Compress-Archive -Path "F:\Findyu\pic" -DestinationPath "F:\Findyu\pic.zip"
   ```

2. **上传到网盘**
   - 打开网盘客户端
   - 上传压缩文件

3. **在 Mac 上：**
   - 登录相同网盘账号
   - 下载压缩文件
   - 解压到项目目录：
     ```bash
     # 解压到项目目录
     unzip ~/Downloads/images.zip -d ~/Desktop/findyusports/Web/webapp/public/
     unzip ~/Downloads/pic.zip -d ~/Desktop/findyusports/
     ```

---

## 方式 2：U盘/移动硬盘（适合大文件）

**步骤：**

1. **在 Windows 上复制文件：**
   ```powershell
   # 复制前端图片
   Copy-Item "F:\Findyu\Web\webapp\public\*.jpg" -Destination "E:\FindyuImages\" -Recurse
   
   # 复制 pic 文件夹
   Copy-Item "F:\Findyu\pic" -Destination "E:\FindyuImages\pic\" -Recurse
   ```
   （`E:\` 是你的 U 盘盘符）

2. **在 Mac 上：**
   - 插入 U 盘
   - 复制文件到项目目录：
     ```bash
     # 复制前端图片
     cp /Volumes/USB/FindyuImages/*.jpg ~/Desktop/findyusports/Web/webapp/public/
     
     # 复制 pic 文件夹
     cp -r /Volumes/USB/FindyuImages/pic ~/Desktop/findyusports/
     ```

---

## 方式 3：微信文件传输助手（适合小文件）

**步骤：**

1. **在 Windows 上：**
   - 打开微信
   - 找到"文件传输助手"
   - 发送图片文件（一次可以发送多个）

2. **在 Mac 上：**
   - 打开微信
   - 从"文件传输助手"下载文件
   - 移动文件到项目目录：
     ```bash
     # 移动前端图片
     mv ~/Downloads/*.jpg ~/Desktop/findyusports/Web/webapp/public/
     
     # 移动 pic 文件夹
     mv ~/Downloads/pic ~/Desktop/findyusports/
     ```

**注意：** 微信单文件限制约 100MB，如果文件较大，建议使用其他方式。

---

## 方式 4：Git（适合代码资源）

如果图片文件不太大（< 50MB），可以使用 Git：

**步骤：**

1. **在 Windows 上：**
   ```powershell
   cd F:\Findyu
   git add Web/webapp/public/*.jpg
   git add pic/
   git commit -m "Add image files"
   git push origin main
   ```

2. **在 Mac 上：**
   ```bash
   cd ~/Desktop/findyusports
   git pull origin main
   ```

**注意：** 
- 确保 `.gitignore` 没有排除这些图片文件
- 如果文件很大，Git 可能不适合

---

## 方式 5：局域网共享（同一网络）

### 在 Windows 上设置共享

1. **创建共享文件夹：**
   ```powershell
   # 创建共享文件夹
   New-Item -ItemType Directory -Path "C:\Share\FindyuImages" -Force
   
   # 复制文件到共享文件夹
   Copy-Item "F:\Findyu\Web\webapp\public\*.jpg" -Destination "C:\Share\FindyuImages\"
   Copy-Item "F:\Findyu\pic" -Destination "C:\Share\FindyuImages\pic\" -Recurse
   ```

2. **设置文件夹共享：**
   - 右键点击 `C:\Share\FindyuImages`
   - 选择"属性" → "共享" → "高级共享"
   - 勾选"共享此文件夹"
   - 设置权限为"读取"

3. **获取 Windows IP 地址：**
   ```powershell
   ipconfig
   ```
   记录 IPv4 地址，例如：`192.168.1.100`

### 在 Mac 上连接

1. **打开 Finder**
2. **按 `Cmd + K`** 或点击"前往" → "连接服务器"
3. **输入：**
   ```
   smb://192.168.1.100/Share/FindyuImages
   ```
   （替换为你的 Windows IP 地址）
4. **输入 Windows 用户名和密码**
5. **复制文件到项目目录**

---

## 方式 6：使用 PowerShell 脚本批量传输

创建一个传输脚本：

```powershell
# transfer-images.ps1
# 将图片文件打包并准备传输

$sourceDir = "F:\Findyu"
$outputDir = "F:\FindyuTransfer"

# 创建输出目录
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

# 复制前端图片
Copy-Item "$sourceDir\Web\webapp\public\*.jpg" -Destination "$outputDir\" -Recurse

# 复制 pic 文件夹
Copy-Item "$sourceDir\pic" -Destination "$outputDir\pic\" -Recurse

# 创建压缩包
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Compress-Archive -Path "$outputDir\*" -DestinationPath "$outputDir\FindyuImages_$timestamp.zip" -Force

Write-Host "✅ 文件已打包到: $outputDir\FindyuImages_$timestamp.zip" -ForegroundColor Green
Write-Host "📋 下一步：将压缩包传输到 Mac" -ForegroundColor Yellow
```

运行脚本：
```powershell
cd F:\Findyu
.\transfer-images.ps1
```

---

## 📝 快速命令参考

### Windows 端（PowerShell）

```powershell
# 查看图片文件
Get-ChildItem "F:\Findyu\Web\webapp\public\*.jpg"
Get-ChildItem "F:\Findyu\pic\*.png"

# 压缩所有图片
Compress-Archive -Path "F:\Findyu\Web\webapp\public\*.jpg","F:\Findyu\pic" -DestinationPath "F:\Findyu\images.zip"

# 复制到 U 盘（假设 U 盘是 E:）
Copy-Item "F:\Findyu\Web\webapp\public\*.jpg" -Destination "E:\"
Copy-Item "F:\Findyu\pic" -Destination "E:\pic\" -Recurse
```

### Mac 端（Bash）

```bash
# 解压文件
unzip ~/Downloads/images.zip -d ~/Desktop/findyusports/

# 复制文件
cp ~/Downloads/*.jpg ~/Desktop/findyusports/Web/webapp/public/
cp -r ~/Downloads/pic ~/Desktop/findyusports/

# 验证文件
ls -lh ~/Desktop/findyusports/Web/webapp/public/*.jpg
ls -lh ~/Desktop/findyusports/pic/
```

---

## ✅ 传输后验证

传输完成后，在 Mac 上验证文件：

```bash
cd ~/Desktop/findyusports

# 检查前端图片
ls -lh Web/webapp/public/*.jpg

# 检查 pic 文件夹
ls -lh pic/

# 检查文件大小（应该与 Windows 上一致）
du -sh Web/webapp/public/*.jpg
du -sh pic/
```

---

## 🔧 常见问题

### Q1: 文件传输后损坏

**解决方案：**
- 使用压缩包传输（可以检测损坏）
- 使用 U 盘时，确保安全弹出
- 使用网盘时，确保上传完成后再下载

### Q2: Mac 上找不到文件

**解决方案：**
```bash
# 查找文件
find ~ -name "*.jpg" -type f
find ~ -name "*.png" -type f

# 检查下载文件夹
ls ~/Downloads/*.jpg
ls ~/Downloads/*.png
```

### Q3: 文件权限问题

**解决方案：**
```bash
# 修复文件权限
chmod 644 ~/Desktop/findyusports/Web/webapp/public/*.jpg
chmod 644 ~/Desktop/findyusports/pic/*.png
```

---

## 🎯 推荐方案

根据文件大小选择：

- **小文件（< 50MB）**：微信文件传输助手
- **中等文件（50MB - 500MB）**：网盘（百度网盘/OneDrive）
- **大文件（> 500MB）**：U盘/移动硬盘
- **代码资源**：Git（如果文件不太大）

---

**需要帮助？** 如果遇到问题，告诉我具体错误信息，我会继续帮你排查。



