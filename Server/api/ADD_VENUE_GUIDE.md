# 添加场地数据指南

## 🎯 最简单的方法（推荐）

### 方法一：交互式命令行工具 ⭐ 最简单

运行命令后，系统会逐步询问每个字段，你只需要按提示输入即可：

```powershell
cd Server/api
npm run add-venue:interactive
```

**特点：**
- ✅ 无需记忆参数
- ✅ 逐步引导，简单直观
- ✅ 支持默认值，可选字段可直接回车跳过
- ✅ 添加完成后可继续添加下一个

**示例流程：**
```
🏀 欢迎使用场地添加工具

📍 场地名称: 朝阳体育中心篮球场
⚽ 运动类型 (1-篮球/basketball, 2-足球/football) [默认: 1]: 1
🏙️  选择城市 (1-6) 或直接输入城市代码: 1
📍 详细地址 (可选，直接回车跳过): 北京市朝阳区朝阳路1号
💰 最低价格/小时 (元，可选): 50
💰 最高价格/小时 (元，可选): 100
🏠 是否室内？(y-是/n-否，默认: n): y

📋 请确认场地信息：
  名称: 朝阳体育中心篮球场
  类型: 篮球
  城市: 110000
  地址: 北京市朝阳区朝阳路1号
  价格: 50 - 100 元/小时
  室内: 是

✅ 确认添加？(y/n): y

✅ 场地已成功添加！
   ID: 1
   名称: 朝阳体育中心篮球场

📸 提示：添加场地后，可以通过管理界面或 API 上传场地图片
```

### 方法二：Web 管理界面 🌐 最直观

访问网站管理页面，在浏览器中填写表单：

```
https://findyusports.com/admin/add-venue
```

**特点：**
- ✅ 图形界面，操作直观
- ✅ 下拉选择城市，无需记忆代码
- ✅ 实时验证，错误提示清晰
- ✅ 添加成功后自动清空表单，可继续添加

---

## 方法三：使用管理脚本（批量添加）

### 1. 批量添加（JSON 文件）

创建或编辑 `venues.json` 文件，参考 `venues-example.json` 的格式：

```json
[
  {
    "name": "场地名称",
    "sportType": "basketball",
    "cityCode": "110000",
    "address": "详细地址",
    "priceMin": 50,
    "priceMax": 100,
    "indoor": true
  }
]
```

然后运行：

```powershell
cd Server/api
npm run add-venue -- --file venues.json
```

### 2. 单个添加（命令行）

```powershell
cd Server/api
npm run add-venue -- --name "朝阳体育中心篮球场" --sportType basketball --cityCode 110000 --address "北京市朝阳区朝阳路1号" --priceMin 50 --priceMax 100 --indoor true
```

### 参数说明

**必填参数：**
- `--name`: 场地名称
- `--sportType`: 运动类型（`basketball` 或 `football`）
- `--cityCode`: 城市代码
  - `110000`: 北京
  - `310000`: 上海
  - `440100`: 广州
  - `440300`: 深圳
  - 更多城市代码请查询国家统计局标准

**可选参数：**
- `--address`: 详细地址
- `--priceMin`: 最低价格（元/小时）
- `--priceMax`: 最高价格（元/小时）
- `--indoor`: 是否室内（`true` 或 `false`）

## 方法二：通过 API 接口

### 创建场地 API

**端点：** `POST /venues`

**需要认证：** 是（需要 JWT token）

**请求体：**
```json
{
  "name": "场地名称",
  "sportType": "basketball",
  "cityCode": "110000",
  "address": "详细地址",
  "priceMin": 50,
  "priceMax": 100,
  "indoor": true
}
```

**示例（使用 curl）：**
```bash
curl -X POST https://your-api-domain.com/venues \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "朝阳体育中心篮球场",
    "sportType": "basketball",
    "cityCode": "110000",
    "address": "北京市朝阳区朝阳路1号",
    "priceMin": 50,
    "priceMax": 100,
    "indoor": true
  }'
```

## 上传场地图片

添加场地后，可以通过以下方式上传场地图片：

### 方法 1：Web 管理界面上传（推荐）

1. 访问场地详情页面或管理页面
2. 点击"上传图片"按钮
3. 选择图片文件（支持 JPG、PNG 格式，最大 10MB）
4. 系统会自动压缩并生成多尺寸图片

### 方法 2：通过 API 上传

**端点：** `POST /venues/:id/upload`

**需要认证：** 是（需要 JWT token）

**请求格式：** `multipart/form-data`

**参数：**
- `file`: 图片文件（必填）

**示例（使用 curl）：**
```bash
curl -X POST https://your-api-domain.com/venues/1/upload \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "file=@/path/to/image.jpg"
```

**响应示例：**
```json
{
  "id": 1,
  "url": "https://your-oss-domain.com/venues/xxx-large.jpg",
  "sizes": {
    "thumbnail": "https://your-oss-domain.com/venues/xxx-thumbnail.jpg",
    "small": "https://your-oss-domain.com/venues/xxx-small.jpg",
    "medium": "https://your-oss-domain.com/venues/xxx-medium.jpg",
    "large": "https://your-oss-domain.com/venues/xxx-large.jpg"
  },
  "info": {
    "width": 1920,
    "height": 1080,
    "size": 245678,
    "format": "jpeg"
  }
}
```

**图片要求：**
- 支持格式：JPG、JPEG、PNG
- 最大文件大小：10MB
- 系统会自动压缩并生成多种尺寸（缩略图、小、中、大）
- 建议上传高质量图片，系统会自动优化

### 查看场地图片

**端点：** `GET /venues/:id/images`

**示例：**
```bash
curl -X GET https://your-api-domain.com/venues/1/images
```

## 常见城市代码

- `110000`: 北京市
- `120000`: 天津市
- `310000`: 上海市
- `500000`: 重庆市
- `440100`: 广州市
- `440300`: 深圳市
- `330100`: 杭州市
- `320100`: 南京市
- `510100`: 成都市
- `420100`: 武汉市

## 注意事项

1. **价格单位**：价格单位为人民币元/小时
2. **数据库连接**：确保 `.env` 文件中的数据库配置正确
3. **图片上传**：上传图片需要用户登录认证，建议在添加场地后通过 Web 界面上传图片
4. **图片存储**：图片存储在阿里云 OSS，系统会自动生成多尺寸版本以优化加载速度

## 查看已添加的场地

访问前端网站或使用 API：

```bash
GET /venues?cityCode=110000&sport=basketball
```

