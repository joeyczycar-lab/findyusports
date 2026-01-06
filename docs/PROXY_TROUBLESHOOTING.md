# 代理服务器问题排查指南

## 🔍 问题诊断

### 第一步：检查代理服务器状态

1. **测试代理服务器是否可用**
   ```powershell
   # 测试代理服务器连接
   Test-NetConnection -ComputerName 你的代理服务器地址 -Port 你的代理端口
   ```

2. **检查代理服务器配置**
   - 确认代理服务器地址和端口是否正确
   - 确认是否需要用户名和密码
   - 确认代理类型（HTTP/HTTPS/SOCKS5）

### 第二步：检查系统代理设置

#### Windows 系统代理设置

1. **打开系统设置**
   - 按 `Win + I` 打开设置
   - 进入 "网络和 Internet" → "代理"

2. **检查代理配置**
   - 手动代理设置是否已启用
   - 代理地址和端口是否正确
   - 是否设置了"不使用代理的地址"

3. **使用命令行检查**
   ```powershell
   # 查看当前代理设置
   netsh winhttp show proxy
   ```

#### PowerShell 环境变量

```powershell
# 检查环境变量
$env:HTTP_PROXY
$env:HTTPS_PROXY
$env:http_proxy
$env:https_proxy
$env:NO_PROXY
```

### 第三步：测试连接

#### 测试 Google

```powershell
# 测试 Google DNS
Test-NetConnection -ComputerName 8.8.8.8 -Port 53

# 测试 Google 网站
Test-NetConnection -ComputerName www.google.com -Port 443

# 使用 curl 测试
curl -v https://www.google.com
```

#### 测试其他国外网站

```powershell
# 测试 GitHub
curl -v https://www.github.com

# 测试 Twitter
curl -v https://www.twitter.com
```

---

## 🔧 解决方案

### 方案 1：配置系统代理

#### 方法 A：通过系统设置

1. **打开代理设置**
   - `Win + I` → "网络和 Internet" → "代理"

2. **配置手动代理**
   - 启用"使用代理服务器"
   - 输入代理地址和端口
   - 例如：`127.0.0.1:7890` 或 `192.168.1.100:8080`

3. **设置例外列表（可选）**
   - 添加不需要代理的地址
   - 例如：`localhost;127.0.0.1;*.local`

#### 方法 B：通过命令行

```powershell
# 设置 HTTP 代理
netsh winhttp set proxy proxy-server="http=代理地址:端口;https=代理地址:端口"

# 示例
netsh winhttp set proxy proxy-server="http=127.0.0.1:7890;https=127.0.0.1:7890"

# 查看设置
netsh winhttp show proxy

# 重置代理（如果需要）
netsh winhttp reset proxy
```

### 方案 2：配置环境变量

#### PowerShell（当前会话）

```powershell
# 设置 HTTP 代理
$env:HTTP_PROXY = "http://代理地址:端口"
$env:HTTPS_PROXY = "http://代理地址:端口"

# 如果需要认证
$env:HTTP_PROXY = "http://用户名:密码@代理地址:端口"

# 设置不使用代理的地址
$env:NO_PROXY = "localhost,127.0.0.1,*.local"
```

#### 永久设置（系统环境变量）

1. **打开环境变量设置**
   - 按 `Win + R`，输入 `sysdm.cpl`
   - 点击"高级" → "环境变量"

2. **添加系统变量**
   - 变量名：`HTTP_PROXY`
   - 变量值：`http://代理地址:端口`
   - 同样添加 `HTTPS_PROXY`

3. **重启 PowerShell 或重启电脑**

### 方案 3：配置特定应用的代理

#### Git 代理配置

```powershell
# 设置 Git HTTP 代理
git config --global http.proxy http://代理地址:端口
git config --global https.proxy http://代理地址:端口

# 查看配置
git config --global --get http.proxy
git config --global --get https.proxy

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

#### npm 代理配置

```powershell
# 设置 npm 代理
npm config set proxy http://代理地址:端口
npm config set https-proxy http://代理地址:端口

# 查看配置
npm config get proxy
npm config get https-proxy

# 取消代理
npm config delete proxy
npm config delete https-proxy
```

#### Docker 代理配置

如果使用 Docker，需要配置 Docker Desktop：

1. **打开 Docker Desktop**
2. **Settings → Resources → Proxies**
3. **配置代理**
   - Manual proxy configuration
   - HTTP proxy: `http://代理地址:端口`
   - HTTPS proxy: `http://代理地址:端口`
4. **Apply & Restart**

### 方案 4：检查防火墙和安全软件

1. **Windows 防火墙**
   - 检查是否阻止了代理连接
   - 临时关闭防火墙测试

2. **安全软件**
   - 检查杀毒软件/安全软件是否阻止
   - 添加代理软件到白名单

3. **企业网络**
   - 如果在公司网络，可能需要联系 IT 部门
   - 可能需要配置企业代理

### 方案 5：DNS 解析问题

#### 更换 DNS 服务器

1. **打开网络设置**
   - `Win + I` → "网络和 Internet" → "更改适配器选项"
   - 右键你的网络连接 → "属性"
   - 选择 "Internet 协议版本 4 (TCP/IPv4)" → "属性"

2. **使用自定义 DNS**
   - 首选 DNS：`8.8.8.8` (Google DNS)
   - 备用 DNS：`8.8.4.4` (Google DNS)
   - 或使用：`1.1.1.1` (Cloudflare DNS)

#### 使用命令行配置 DNS

```powershell
# 查看当前 DNS
Get-DnsClientServerAddress

# 设置 DNS（需要管理员权限）
Set-DnsClientServerAddress -InterfaceAlias "你的网络适配器名称" -ServerAddresses "8.8.8.8","8.8.4.4"
```

---

## 🧪 测试和验证

### 测试脚本

创建一个测试脚本 `test-proxy.ps1`：

```powershell
Write-Host "=== 代理连接测试 ===" -ForegroundColor Cyan
Write-Host ""

# 测试 Google
Write-Host "测试 Google..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 10 -UseBasicParsing
    Write-Host "[OK] Google 可访问" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Google 无法访问: $($_.Exception.Message)" -ForegroundColor Red
}

# 测试 GitHub
Write-Host "测试 GitHub..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://www.github.com" -TimeoutSec 10 -UseBasicParsing
    Write-Host "[OK] GitHub 可访问" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] GitHub 无法访问: $($_.Exception.Message)" -ForegroundColor Red
}

# 测试 DNS
Write-Host "测试 DNS..." -ForegroundColor Yellow
try {
    $dns = Resolve-DnsName -Name "www.google.com" -ErrorAction Stop
    Write-Host "[OK] DNS 解析正常" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] DNS 解析失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "当前代理设置:" -ForegroundColor Cyan
netsh winhttp show proxy
```

运行测试：
```powershell
.\test-proxy.ps1
```

---

## 🔍 常见问题

### Q1: 代理设置后仍然无法访问

**可能原因：**
- 代理服务器本身有问题
- 代理地址或端口配置错误
- 需要认证但未配置

**解决方案：**
1. 确认代理服务器是否正常运行
2. 检查代理地址和端口
3. 如果代理需要认证，添加用户名和密码

### Q2: 部分网站可以访问，部分不行

**可能原因：**
- DNS 解析问题
- 代理规则配置问题
- 某些网站被特殊处理

**解决方案：**
1. 更换 DNS 服务器
2. 检查代理软件的规则设置
3. 尝试直接 IP 访问测试

### Q3: 本地服务（localhost）也走代理

**解决方案：**
```powershell
# 设置不使用代理的地址
netsh winhttp set proxy proxy-server="http=代理地址:端口" bypass-list="localhost;127.0.0.1;*.local"
```

### Q4: Docker 无法连接网络

**解决方案：**
1. 在 Docker Desktop 中配置代理
2. 或配置 Docker daemon.json：
   ```json
   {
     "proxies": {
       "http-proxy": "http://代理地址:端口",
       "https-proxy": "http://代理地址:端口",
       "no-proxy": "localhost,127.0.0.1"
     }
   }
   ```

---

## 📝 常用代理软件配置

### Clash

```yaml
# Clash 配置示例
port: 7890
socks-port: 7891
allow-lan: true
mode: rule
log-level: info
external-controller: 127.0.0.1:9090
```

系统代理设置：`127.0.0.1:7890`

### V2Ray

系统代理设置：根据 V2Ray 配置的端口（通常是 10808）

### Shadowsocks

系统代理设置：根据 Shadowsocks 配置的端口（通常是 1080）

---

## ✅ 检查清单

完成配置后，请确认：

- [ ] 代理服务器正在运行
- [ ] 系统代理设置已配置
- [ ] 环境变量已设置（如需要）
- [ ] DNS 服务器已配置
- [ ] 防火墙未阻止代理连接
- [ ] 可以访问 Google
- [ ] 可以访问 GitHub
- [ ] 本地服务（localhost）不受影响

---

**需要帮助？** 如果遇到问题，请提供：
1. 使用的代理软件名称
2. 代理服务器地址和端口
3. 具体的错误信息
4. 测试结果



