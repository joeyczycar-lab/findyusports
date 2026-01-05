# 快速添加场地指南

本指南介绍几种快速添加场地的方法，从简单到复杂：

## 方法一：Web 界面添加（最简单）⭐

**适用场景**: 少量场地，需要上传图片

1. 访问: `http://localhost:3000/admin/add-venue` 或 `https://findyusports.com/admin/add-venue`
2. 填写表单信息
3. 点击"添加场地"
4. 在场地详情页上传图片

**优点**: 
- 界面友好，无需命令行
- 可以直接上传图片
- 实时验证

**缺点**: 
- 一次只能添加一个场地
- 需要手动输入坐标

---

## 方法二：CSV 批量导入（推荐）🚀

**适用场景**: 批量添加场地，已有场地数据

### 步骤：

1. **准备 CSV 文件**

   创建 `venues.csv` 文件，格式如下：

   ```csv
   name,sportType,cityCode,districtCode,address,lng,lat,priceMin,priceMax,indoor,contact,isPublic
   朝阳体育中心篮球场,basketball,110000,110105,北京市朝阳区朝阳路1号,116.45,39.92,50,100,true,13800138000,true
   工人体育场足球场,football,110000,110105,北京市朝阳区工人体育场北路,116.44,39.93,200,500,false,13800138001,true
   ```

   **必需列**:
   - `name` - 场地名称
   - `sportType` - 运动类型 (basketball 或 football)
   - `cityCode` - 城市代码 (如 110000 北京)
   - `lng` - 经度
   - `lat` - 纬度

   **可选列**:
   - `districtCode` - 区级代码
   - `address` - 详细地址
   - `priceMin` - 最低价格
   - `priceMax` - 最高价格
   - `indoor` - 是否室内 (true/false)
   - `contact` - 联系方式
   - `isPublic` - 是否对外开放 (true/false，默认 true)

2. **运行导入命令**

   ```bash
   cd Server/api
   npm run add-venue:csv -- venues.csv
   ```

3. **查看结果**

   工具会显示导入统计和场地列表。

**优点**:
- 可以批量导入
- CSV 格式易于编辑（Excel、Google Sheets）
- 速度快

**缺点**:
- 需要准备 CSV 文件
- 不能直接上传图片（需要后续在 Web 界面上传）

**示例文件**: `Server/api/venues-example.csv`

---

## 方法三：JSON 批量导入

**适用场景**: 已有 JSON 格式数据

### 步骤：

1. **准备 JSON 文件**

   创建 `venues.json` 文件：

   ```json
   [
     {
       "name": "朝阳体育中心篮球场",
       "sportType": "basketball",
       "cityCode": "110000",
       "districtCode": "110105",
       "address": "北京市朝阳区朝阳路1号",
       "lng": 116.45,
       "lat": 39.92,
       "priceMin": 50,
       "priceMax": 100,
       "indoor": true,
       "contact": "13800138000",
       "isPublic": true
     }
   ]
   ```

2. **运行导入命令**

   ```bash
   cd Server/api
   npm run add-venue -- --file venues.json
   ```

---

## 方法四：命令行单个添加

**适用场景**: 快速添加单个场地

```bash
cd Server/api
npm run add-venue -- \
  --name "场地名称" \
  --sportType basketball \
  --cityCode 110000 \
  --districtCode 110105 \
  --address "详细地址" \
  --lng 116.45 \
  --lat 39.92 \
  --priceMin 50 \
  --priceMax 100 \
  --indoor true \
  --contact "13800138000" \
  --isPublic true
```

---

## 方法五：交互式命令行工具

**适用场景**: 需要逐步输入，有提示

```bash
cd Server/api
npm run add-venue:interactive
```

按提示输入场地信息即可。

---

## 获取坐标的方法

### 方法一：高德地图坐标拾取工具（推荐）

1. 访问: https://lbs.amap.com/tools/picker
2. 在地图上找到场地位置
3. 点击位置，复制显示的经纬度
4. **注意**: 高德地图使用 GCJ-02 坐标系，如果坐标偏差较大，可能需要转换为 WGS-84

### 方法二：百度地图坐标拾取工具

1. 访问: https://api.map.baidu.com/lbsapi/getpoint/index.html
2. 在地图上找到场地位置
3. 点击位置，复制显示的经纬度

---

## 城市代码参考

| 城市 | 代码 |
|------|------|
| 北京 | 110000 |
| 上海 | 310000 |
| 广州 | 440100 |
| 深圳 | 440300 |
| 杭州 | 330100 |
| 南京 | 320100 |
| 成都 | 510100 |
| 武汉 | 420100 |
| 天津 | 120000 |
| 重庆 | 500000 |

更多城市代码请参考: https://lbs.amap.com/api/javascript-api/guide/abc/prepare

---

## 区级代码参考（部分）

### 北京 (110000)
- 东城区: 110101
- 西城区: 110102
- 朝阳区: 110105
- 丰台区: 110106
- 海淀区: 110108
- ...

### 上海 (310000)
- 黄浦区: 310101
- 徐汇区: 310104
- 长宁区: 310105
- 静安区: 310106
- 浦东新区: 310115
- ...

更多区级代码请参考: https://lbs.amap.com/api/javascript-api/guide/abc/prepare

---

## 推荐工作流程

1. **批量准备数据**: 使用 Excel 或 Google Sheets 准备 CSV 文件
2. **批量导入**: 使用 CSV 导入工具批量添加场地
3. **上传图片**: 在 Web 界面的场地详情页上传图片
4. **完善信息**: 在 Web 界面编辑和补充场地信息

---

## 常见问题

### Q: CSV 导入失败怎么办？

1. 检查 CSV 文件格式是否正确
2. 确保必需列都存在
3. 检查数据类型是否正确（坐标必须是数字）
4. 查看错误提示信息

### Q: 坐标不准确怎么办？

- 使用高德地图坐标拾取工具获取更准确的坐标
- 如果使用其他地图服务，注意坐标系转换

### Q: 可以导入图片吗？

目前批量导入工具不支持直接导入图片。建议：
1. 先批量导入场地数据
2. 然后在 Web 界面的场地详情页逐个上传图片

### Q: 如何修改已导入的场地？

在 Web 界面访问场地详情页进行编辑，或使用数据库直接修改。

---

## 更多帮助

- 查看 CSV 导入帮助: `npm run add-venue:csv -- --help`
- 查看 JSON 导入帮助: `npm run add-venue -- --help`
- 查看交互式工具: `npm run add-venue:interactive`

