import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { dataSourceOptions } from './data-source'
import * as readline from 'readline'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: false,
})

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
})

function question(query: string): Promise<string> {
  return new Promise((resolve) => {
    rl.question(query, resolve)
  })
}

async function main() {
  console.log('\n🏀 欢迎使用场地添加工具\n')
  console.log('提示：直接按回车可以使用默认值或跳过可选字段\n')

  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)

  try {
    // 场地名称
    const name = await question('📍 场地名称: ')
    if (!name.trim()) {
      console.log('❌ 场地名称不能为空')
      process.exit(1)
    }

    // 运动类型
    let sportType: 'basketball' | 'football' = 'basketball'
    const sportInput = await question('⚽ 运动类型 (1-篮球/basketball, 2-足球/football) [默认: 1]: ')
    if (sportInput.trim() === '2' || sportInput.trim().toLowerCase() === 'football') {
      sportType = 'football'
    }

    // 城市代码
    console.log('\n常见城市代码：')
    console.log('  1 - 北京 (110000)')
    console.log('  2 - 上海 (310000)')
    console.log('  3 - 广州 (440100)')
    console.log('  4 - 深圳 (440300)')
    console.log('  5 - 杭州 (330100)')
    console.log('  6 - 成都 (510100)')
    const cityChoice = await question('\n🏙️  选择城市 (1-6) 或直接输入城市代码: ')
    let cityCode = ''
    const cityMap: Record<string, string> = {
      '1': '110000',
      '2': '310000',
      '3': '440100',
      '4': '440300',
      '5': '330100',
      '6': '510100',
    }
    if (cityMap[cityChoice.trim()]) {
      cityCode = cityMap[cityChoice.trim()]
    } else if (/^\d{6}$/.test(cityChoice.trim())) {
      cityCode = cityChoice.trim()
    } else {
      console.log('❌ 无效的城市代码')
      process.exit(1)
    }

    // 地址
    const address = await question('📍 详细地址 (可选，直接回车跳过): ')

    // 经纬度
    console.log('\n💡 提示：可以使用以下工具获取坐标：')
    console.log('  高德地图: https://lbs.amap.com/tools/picker')
    console.log('  百度地图: https://api.map.baidu.com/lbsapi/getpoint/index.html')
    const lngStr = await question('🌐 经度 (lng): ')
    const latStr = await question('🌐 纬度 (lat): ')
    const lng = parseFloat(lngStr.trim())
    const lat = parseFloat(latStr.trim())
    if (isNaN(lng) || isNaN(lat)) {
      console.log('❌ 经纬度必须是有效数字')
      process.exit(1)
    }

    // 价格
    const priceMinStr = await question('💰 最低价格/小时 (元，可选): ')
    const priceMaxStr = await question('💰 最高价格/小时 (元，可选): ')
    const priceMin = priceMinStr.trim() ? parseInt(priceMinStr.trim()) : undefined
    const priceMax = priceMaxStr.trim() ? parseInt(priceMaxStr.trim()) : undefined

    // 室内/室外
    const indoorInput = await question('🏠 是否室内？(y-是/n-否，默认: n): ')
    const indoor = indoorInput.trim().toLowerCase() === 'y' || indoorInput.trim().toLowerCase() === 'yes'

    // 确认信息
    console.log('\n📋 请确认场地信息：')
    console.log(`  名称: ${name}`)
    console.log(`  类型: ${sportType === 'basketball' ? '篮球' : '足球'}`)
    console.log(`  城市: ${cityCode}`)
    if (address.trim()) console.log(`  地址: ${address}`)
    console.log(`  坐标: ${lng}, ${lat}`)
    if (priceMin) console.log(`  价格: ${priceMin}${priceMax ? ` - ${priceMax}` : ''} 元/小时`)
    console.log(`  室内: ${indoor ? '是' : '否'}`)

    const confirm = await question('\n✅ 确认添加？(y/n): ')
    if (confirm.trim().toLowerCase() !== 'y' && confirm.trim().toLowerCase() !== 'yes') {
      console.log('❌ 已取消')
      process.exit(0)
    }

    // 保存到数据库
    const venue = new VenueEntity()
    venue.name = name.trim()
    venue.sportType = sportType
    venue.cityCode = cityCode
    venue.address = address.trim() || undefined
    venue.lng = lng
    venue.lat = lat
    venue.priceMin = priceMin
    venue.priceMax = priceMax
    venue.indoor = indoor
    venue.geom = { type: 'Point', coordinates: [lng, lat] } as any

    const saved = await repo.save(venue)
    console.log(`\n✅ 场地已成功添加！`)
    console.log(`   ID: ${saved.id}`)
    console.log(`   名称: ${saved.name}`)
    console.log(`   坐标: ${saved.lng}, ${saved.lat}\n`)

    // 询问是否继续添加
    const continueInput = await question('🔄 是否继续添加下一个场地？(y/n): ')
    if (continueInput.trim().toLowerCase() === 'y' || continueInput.trim().toLowerCase() === 'yes') {
      rl.close()
      main() // 递归调用继续添加
      return
    }
  } catch (error) {
    console.error('❌ 错误:', error)
  } finally {
    rl.close()
    await ds.destroy()
  }
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})


