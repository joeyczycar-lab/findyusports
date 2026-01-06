import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { dataSourceOptions } from './data-source'
import * as fs from 'fs'
import * as path from 'path'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: false,
})

interface VenueInput {
  name: string
  sportType: 'basketball' | 'football'
  cityCode: string
  districtCode?: string
  address?: string
  lng: number
  lat: number
  priceMin?: number
  priceMax?: number
  indoor?: boolean
  contact?: string
  isPublic?: boolean
}

async function addVenuesFromCSV(filePath: string) {
  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)
  
  console.log(`📖 读取 CSV 文件: ${filePath}`)
  const csvContent = fs.readFileSync(filePath, 'utf-8')
  const lines = csvContent.split('\n').filter(line => line.trim().length > 0)
  
  if (lines.length < 2) {
    console.error('❌ CSV 文件至少需要包含标题行和一行数据')
    process.exit(1)
  }
  
  // 解析标题行
  const headers = lines[0].split(',').map(h => h.trim())
  console.log(`📋 列标题: ${headers.join(', ')}`)
  
  // 检查必需的列
  const requiredColumns = ['name', 'sportType', 'cityCode', 'lng', 'lat']
  const missingColumns = requiredColumns.filter(col => !headers.includes(col))
  if (missingColumns.length > 0) {
    console.error(`❌ 缺少必需的列: ${missingColumns.join(', ')}`)
    console.error(`📝 CSV 文件应包含以下列: ${requiredColumns.join(', ')}`)
    process.exit(1)
  }
  
  const venues: VenueEntity[] = []
  let successCount = 0
  let errorCount = 0
  
  // 解析数据行
  for (let i = 1; i < lines.length; i++) {
    const line = lines[i]
    if (!line.trim()) continue
    
    try {
      // 简单的CSV解析（不支持引号内的逗号）
      const values = line.split(',').map(v => v.trim())
      
      if (values.length !== headers.length) {
        console.warn(`⚠️  第 ${i + 1} 行列数不匹配，跳过`)
        errorCount++
        continue
      }
      
      const row: Record<string, string> = {}
      headers.forEach((header, index) => {
        row[header] = values[index] || ''
      })
      
      // 验证和转换数据
      const sportType = row.sportType.toLowerCase()
      if (sportType !== 'basketball' && sportType !== 'football') {
        console.warn(`⚠️  第 ${i + 1} 行: sportType 必须是 basketball 或 football，跳过`)
        errorCount++
        return
      }
      
      const lng = parseFloat(row.lng)
      const lat = parseFloat(row.lat)
      if (isNaN(lng) || isNaN(lat)) {
        console.warn(`⚠️  第 ${i + 1} 行: lng 和 lat 必须是有效数字，跳过`)
        errorCount++
        return
      }
      
      const venue = new VenueEntity()
      venue.name = row.name
      venue.sportType = sportType as 'basketball' | 'football'
      venue.cityCode = row.cityCode
      venue.districtCode = row.districtCode || undefined
      venue.address = row.address || undefined
      venue.lng = lng
      venue.lat = lat
      venue.priceMin = row.priceMin ? parseInt(row.priceMin) : undefined
      venue.priceMax = row.priceMax ? parseInt(row.priceMax) : undefined
      venue.indoor = row.indoor === 'true' || row.indoor === '1' ? true : row.indoor === 'false' || row.indoor === '0' ? false : undefined
      venue.contact = row.contact || undefined
      venue.isPublic = row.isPublic === 'false' || row.isPublic === '0' ? false : true
      
      venues.push(venue)
      successCount++
    } catch (error) {
      console.error(`❌ 第 ${i + 1} 行解析错误:`, error instanceof Error ? error.message : String(error))
      errorCount++
    }
  }
  
  if (venues.length === 0) {
    console.error('❌ 没有有效的场地数据')
    process.exit(1)
  }
  
  console.log(`\n📊 统计:`)
  console.log(`  ✅ 有效数据: ${successCount} 条`)
  console.log(`  ❌ 错误数据: ${errorCount} 条`)
  console.log(`\n💾 开始批量导入...`)
  
  // 检查是否存在 geom 列
  const hasGeomColumn = repo.metadata.columns.find(c => c.propertyName === 'geom')
  
  // 批量保存
  const saved = await repo.save(venues)
  
  console.log(`\n✅ 成功导入 ${saved.length} 个场地`)
  console.log(`\n📋 导入的场地列表:`)
  saved.forEach((venue, index) => {
    console.log(`  ${index + 1}. ${venue.name} (ID: ${venue.id})`)
  })
  
  return saved
}

async function main() {
  const args = process.argv.slice(2)
  
  if (args.length === 0 || args[0] === '--help' || args[0] === '-h') {
    console.log(`
📖 CSV 批量导入场地工具

使用方法:
  npm run add-venue:csv -- <csv文件路径>

示例:
  npm run add-venue:csv -- venues.csv

CSV 文件格式:
  第一行必须是标题行，包含以下列（必需列用 * 标记）:
  
  * name          - 场地名称
  * sportType     - 运动类型 (basketball 或 football)
  * cityCode      - 城市代码 (如 110000 北京)
  * lng           - 经度
  * lat           - 纬度
  
  可选列:
  districtCode   - 区级代码 (如 110105 朝阳区)
  address        - 详细地址
  priceMin       - 最低价格 (元/小时)
  priceMax       - 最高价格 (元/小时)
  indoor         - 是否室内 (true/false 或 1/0)
  contact        - 联系方式
  isPublic       - 是否对外开放 (true/false 或 1/0，默认 true)

CSV 示例 (venues.csv):
name,sportType,cityCode,districtCode,address,lng,lat,priceMin,priceMax,indoor,contact,isPublic
朝阳体育中心篮球场,basketball,110000,110105,北京市朝阳区朝阳路1号,116.45,39.92,50,100,true,13800138000,true
工人体育场足球场,football,110000,110105,北京市朝阳区工人体育场北路,116.44,39.93,200,500,false,13800138001,true

提示:
  - CSV 文件使用逗号分隔
  - 空值可以留空或使用空字符串
  - 布尔值可以使用 true/false 或 1/0
  - 坐标可以使用高德地图坐标拾取工具获取: https://lbs.amap.com/tools/picker
    `)
    process.exit(0)
  }
  
  const csvPath = args[0]
  const fullPath = path.resolve(csvPath)
  
  if (!fs.existsSync(fullPath)) {
    console.error(`❌ 错误: 文件不存在: ${fullPath}`)
    process.exit(1)
  }
  
  try {
    await addVenuesFromCSV(fullPath)
    await ds.destroy()
    console.log('\n✅ 完成')
  } catch (error) {
    console.error('❌ 错误:', error)
    if (error instanceof Error) {
      console.error('错误信息:', error.message)
      console.error('错误堆栈:', error.stack)
    }
    await ds.destroy()
    process.exit(1)
  }
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})


