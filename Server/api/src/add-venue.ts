import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { dataSourceOptions } from './data-source'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: true,
})

interface VenueInput {
  name: string
  sportType: 'basketball' | 'football'
  cityCode: string
  address?: string
  lng: number
  lat: number
  priceMin?: number
  priceMax?: number
  indoor?: boolean
}

async function addVenue(venueData: VenueInput) {
  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)
  
  const venue = new VenueEntity()
  venue.name = venueData.name
  venue.sportType = venueData.sportType
  venue.cityCode = venueData.cityCode
  venue.address = venueData.address
  venue.lng = venueData.lng
  venue.lat = venueData.lat
  venue.priceMin = venueData.priceMin
  venue.priceMax = venueData.priceMax
  venue.indoor = venueData.indoor
  // 只有在数据库中存在 geom 列时才设置 PostGIS geometry point
  const hasGeomColumn = repo.metadata.columns.find(c => c.propertyName === 'geom')
  if (hasGeomColumn) {
    venue.geom = { type: 'Point', coordinates: [venueData.lng, venueData.lat] } as any
  }
  
  const saved = await repo.save(venue)
  console.log(`✅ 场地已添加: ${saved.name} (ID: ${saved.id})`)
  return saved
}

async function addVenuesFromArray(venues: VenueInput[]) {
  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)
  
  // 检查是否存在 geom 列
  const hasGeomColumn = repo.metadata.columns.find(c => c.propertyName === 'geom')
  
  const rows: VenueEntity[] = []
  for (const venueData of venues) {
    const venue = new VenueEntity()
    venue.name = venueData.name
    venue.sportType = venueData.sportType
    venue.cityCode = venueData.cityCode
    venue.address = venueData.address
    venue.lng = venueData.lng
    venue.lat = venueData.lat
    venue.priceMin = venueData.priceMin
    venue.priceMax = venueData.priceMax
    venue.indoor = venueData.indoor
    // 只有在数据库中存在 geom 列时才设置 PostGIS geometry point
    if (hasGeomColumn) {
      venue.geom = { type: 'Point', coordinates: [venueData.lng, venueData.lat] } as any
    }
    rows.push(venue)
  }
  
  const saved = await repo.save(rows)
  console.log(`✅ 已批量添加 ${saved.length} 个场地`)
  return saved
}

async function main() {
  const args = process.argv.slice(2)
  
  if (args.length === 0) {
    console.log(`
使用方法：
1. 添加单个场地（通过命令行参数）：
   npm run add-venue -- --name "场地名称" --sportType basketball --cityCode 110000 --lng 116.4 --lat 39.9

2. 批量添加场地（通过 JSON 文件）：
   npm run add-venue -- --file venues.json

参数说明：
  --name: 场地名称（必填）
  --sportType: 运动类型，basketball 或 football（必填）
  --cityCode: 城市代码，如 110000（北京）、310000（上海）（必填）
  --address: 地址（可选）
  --lng: 经度（必填）
  --lat: 纬度（必填）
  --priceMin: 最低价格（可选）
  --priceMax: 最高价格（可选）
  --indoor: 是否室内，true 或 false（可选）
  --file: JSON 文件路径，包含场地数组（可选）

JSON 文件格式示例（venues.json）：
[
  {
    "name": "朝阳体育中心篮球场",
    "sportType": "basketball",
    "cityCode": "110000",
    "address": "北京市朝阳区朝阳路1号",
    "lng": 116.45,
    "lat": 39.92,
    "priceMin": 50,
    "priceMax": 100,
    "indoor": true
  },
  {
    "name": "工人体育场足球场",
    "sportType": "football",
    "cityCode": "110000",
    "address": "北京市朝阳区工人体育场北路",
    "lng": 116.44,
    "lat": 39.93,
    "priceMin": 200,
    "priceMax": 500,
    "indoor": false
  }
]
    `)
    process.exit(0)
  }

  try {
    // 检查是否使用文件模式
    const fileIndex = args.indexOf('--file')
    if (fileIndex !== -1) {
      const filePath = args[fileIndex + 1]
      if (!filePath) {
        console.error('❌ 错误: --file 参数需要指定文件路径')
        process.exit(1)
      }
      
      const fs = require('fs')
      const path = require('path')
      const fullPath = path.resolve(filePath)
      
      if (!fs.existsSync(fullPath)) {
        console.error(`❌ 错误: 文件不存在: ${fullPath}`)
        process.exit(1)
      }
      
      const fileContent = fs.readFileSync(fullPath, 'utf-8')
      const venues: VenueInput[] = JSON.parse(fileContent)
      
      if (!Array.isArray(venues)) {
        console.error('❌ 错误: JSON 文件必须包含一个数组')
        process.exit(1)
      }
      
      await addVenuesFromArray(venues)
    } else {
      // 命令行参数模式
      const getArg = (key: string): string | undefined => {
        const index = args.indexOf(`--${key}`)
        return index !== -1 && args[index + 1] ? args[index + 1] : undefined
      }
      
      const name = getArg('name')
      const sportType = getArg('sportType') as 'basketball' | 'football' | undefined
      const cityCode = getArg('cityCode')
      const address = getArg('address')
      const lngStr = getArg('lng')
      const latStr = getArg('lat')
      const priceMinStr = getArg('priceMin')
      const priceMaxStr = getArg('priceMax')
      const indoorStr = getArg('indoor')
      
      if (!name || !sportType || !cityCode || !lngStr || !latStr) {
        console.error('❌ 错误: 缺少必填参数 (name, sportType, cityCode, lng, lat)')
        process.exit(1)
      }
      
      if (sportType !== 'basketball' && sportType !== 'football') {
        console.error('❌ 错误: sportType 必须是 basketball 或 football')
        process.exit(1)
      }
      
      const lng = parseFloat(lngStr)
      const lat = parseFloat(latStr)
      
      if (isNaN(lng) || isNaN(lat)) {
        console.error('❌ 错误: lng 和 lat 必须是有效的数字')
        process.exit(1)
      }
      
      const venueData: VenueInput = {
        name,
        sportType,
        cityCode,
        address,
        lng,
        lat,
        priceMin: priceMinStr ? parseInt(priceMinStr) : undefined,
        priceMax: priceMaxStr ? parseInt(priceMaxStr) : undefined,
        indoor: indoorStr === 'true' ? true : indoorStr === 'false' ? false : undefined,
      }
      
      await addVenue(venueData)
    }
    
    await ds.destroy()
    console.log('✅ 完成')
  } catch (error) {
    console.error('❌ 错误:', error)
    await ds.destroy()
    process.exit(1)
  }
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})


