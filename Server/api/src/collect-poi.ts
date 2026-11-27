import 'reflect-metadata'
import * as dotenv from 'dotenv'
import * as fs from 'fs'
import * as path from 'path'

dotenv.config()

/**
 * 高德 POI 批量采集（只读公开 POI，不写库）
 *
 * 用法:
 *   npx ts-node src/collect-poi.ts <cityCode> [basketball|football|both] [maxPages]
 * 示例:
 *   npx ts-node src/collect-poi.ts 330100 both 5
 *
 * 输出: Web/webapp/data/poi-<cityCode>-<sport>.csv（对齐导入模板）
 *       Web/webapp/data/poi-<cityCode>-<sport>.json（含评分/照片备查）
 */

const KEY = process.env.AMAP_WEB_KEY?.trim()

const KEYWORDS: Record<'basketball' | 'football', string[]> = {
  basketball: ['篮球馆', '篮球公园', '篮球场'],
  football: ['足球场', '足球公园', '足球俱乐部'],
}

// 类别码：纯球类场馆
const KEEP_TYPECODE: Record<'basketball' | 'football', string[]> = {
  basketball: ['080104'],
  football: ['080105'],
}

// 名称中出现以下任一关键词 → 视为综合馆 / 学校场地，剔除
const NAME_BLOCK = /大学|学院|中学|小学|校区|校内|学校|校园|体育中心|体育场|奥体|训练基地|文体|健身|游泳|羽毛球|网球|乒乓|桌球|综合|击剑|武术|搏击|舞蹈|瑜伽|轮滑|滑板|攀岩|高尔夫|台球|训练营|培训|体能|训练中心|训练场|院内|内部|武警|医院|篮羽|羽网|街区/

interface Poi {
  id: string
  name: string
  type: string
  typecode: string
  address: string
  location: string
  tel: string | string[]
  adcode: string
  adname: string
  cityname: string
  keytag?: string
  biz_ext?: { rating?: string; cost?: string; open_time?: string; opentime2?: string }
  photos?: { url: string }[]
}

function csvEscape(v: string): string {
  const s = String(v ?? '')
  return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s
}

function normTel(tel: string | string[] | undefined): string {
  if (!tel) return ''
  if (Array.isArray(tel)) return tel.filter(Boolean).join(';')
  return String(tel).trim()
}

function keepPoi(poi: Poi, sport: 'basketball' | 'football'): boolean {
  const code = poi.typecode || ''
  const type = poi.type || ''
  const name = poi.name || ''
  const addr = poi.address || ''
  const typeOk = KEEP_TYPECODE[sport].includes(code) || type.includes(sport === 'basketball' ? '篮球' : '足球')
  if (!typeOk) return false
  if (NAME_BLOCK.test(name) || NAME_BLOCK.test(addr)) return false
  return true
}

async function fetchPage(keyword: string, cityCode: string, page: number): Promise<Poi[]> {
  const url = `https://restapi.amap.com/v3/place/text?key=${KEY}&keywords=${encodeURIComponent(
    keyword,
  )}&city=${cityCode}&citylimit=true&offset=25&page=${page}&extensions=all`
  const res = await fetch(url)
  const data = await res.json()
  if (String(data.status) !== '1') {
    console.warn(`⚠️ 接口返回 ${data.info || ''} (${keyword} p${page})`)
    return []
  }
  return (data.pois || []) as Poi[]
}

async function collect(cityCode: string, sport: 'basketball' | 'football'): Promise<Poi[]> {
  const seen = new Map<string, Poi>()
  for (const kw of KEYWORDS[sport]) {
    let page = 1
    while (page <= MAX_PAGES) {
      const pois = await fetchPage(kw, cityCode, page)
      if (pois.length === 0) break
      for (const p of pois) {
        if (p.id && !seen.has(p.id)) seen.set(p.id, p)
      }
      if (pois.length < 25) break
      page++
      await new Promise((r) => setTimeout(r, 150)) // 温和限流
    }
  }
  return [...seen.values()].filter((p) => keepPoi(p, sport))
}

const HEADERS = [
  'name', 'sportType', 'cityCode', 'districtCode', 'address', 'lng', 'lat',
  'priceMin', 'priceMax', 'priceDisplay', 'supportsWalkIn', 'walkInPriceDisplay',
  'supportsFullCourt', 'fullCourtPriceDisplay', 'indoor', 'contact',
  'requiresReservation', 'reservationMethod', 'isPublic', 'courtCount', 'floorType',
  'playersPerSide', 'openHours', 'hasLighting', 'hasAirConditioning', 'hasParking',
  'hasFence', 'hasRestArea', 'hasShower', 'hasLocker', 'hasShop',
]

function cleanOpenHours(ext?: Poi['biz_ext']): string {
  if (!ext) return ''
  const basic = s(ext.open_time)
  if (basic && /^\d{1,2}:\d{2}/.test(basic)) return basic
  const full = s(ext.opentime2)
  if (!full) return ''
  // 去掉含具体日期的节假日特殊时段，只保留常规首段
  let first = full.split(/[；;]/)[0].trim()
  first = first.replace(/\s*20\d{2}-.*$/, '').trim()
  return /20\d{2}-/.test(first) ? '' : first
}

function s(v: any): string {
  if (v == null) return ''
  if (Array.isArray(v)) return v.filter(Boolean).join(' ')
  return String(v).trim()
}

function toCsvRow(poi: Poi, sport: 'basketball' | 'football', cityCode: string): string {
  const [lng, lat] = (poi.location || '').split(',').map(Number)
  const costNum = Number(s(poi.biz_ext?.cost))
  const priceDisplay = Number.isFinite(costNum) && costNum > 0 ? `参考人均${Math.round(costNum)}元` : ''
  const openHours = cleanOpenHours(poi.biz_ext)
  const address = poi.address || `${poi.adname || ''}${poi.name}`
  const row: Record<string, string> = {
    name: poi.name,
    sportType: sport,
    cityCode,
    districtCode: poi.adcode || '',
    address,
    lng: Number.isFinite(lng) ? String(lng) : '',
    lat: Number.isFinite(lat) ? String(lat) : '',
    priceMin: '',
    priceMax: '',
    priceDisplay,
    supportsWalkIn: '',
    walkInPriceDisplay: '',
    supportsFullCourt: '',
    fullCourtPriceDisplay: '',
    indoor: '',
    contact: normTel(poi.tel),
    requiresReservation: '',
    reservationMethod: '',
    isPublic: 'true',
    courtCount: '',
    floorType: '',
    playersPerSide: sport === 'football' ? '5人制、7人制' : '',
    openHours,
    hasLighting: '',
    hasAirConditioning: '',
    hasParking: '',
    hasFence: '',
    hasRestArea: '',
    hasShower: '',
    hasLocker: '',
    hasShop: '',
  }
  return HEADERS.map((h) => csvEscape(row[h])).join(',')
}

let MAX_PAGES = 5

async function main() {
  const args = process.argv.slice(2)
  const cityCode = args[0]
  const sportArg = (args[1] || 'both').toLowerCase()
  MAX_PAGES = Number(args[2] || 5)
  if (!KEY) { console.error('❌ 缺少 AMAP_WEB_KEY'); process.exit(1) }
  if (!/^\d{6}$/.test(cityCode || '')) { console.error('❌ 需要 6 位 cityCode，如 330100'); process.exit(1) }

  const sports: ('basketball' | 'football')[] =
    sportArg === 'both' ? ['basketball', 'football'] : sportArg === 'football' ? ['football'] : ['basketball']

  const outDir = path.resolve(__dirname, '../../../Web/webapp/data')
  fs.mkdirSync(outDir, { recursive: true })

  for (const sport of sports) {
    const pois = await collect(cityCode, sport)
    console.log(`\n📌 ${cityCode} ${sport}: 过滤后 ${pois.length} 条`)
    pois.slice(0, 60).forEach((p) => console.log(`  - ${p.name} | ${p.address} | ${normTel(p.tel) || '无电话'}`))

    const csvLines = [HEADERS.join(',')]
    for (const p of pois) csvLines.push(toCsvRow(p, sport, cityCode))
    const csvPath = path.join(outDir, `poi-${cityCode}-${sport}.csv`)
    fs.writeFileSync(csvPath, csvLines.join('\n') + '\n', 'utf-8')

    const jsonPath = path.join(outDir, `poi-${cityCode}-${sport}.json`)
    fs.writeFileSync(jsonPath, JSON.stringify(pois, null, 1), 'utf-8')
    console.log(`✅ 写出 ${csvPath}`)
  }
}

main().catch((e) => {
  console.error('❌ 采集错误:', e instanceof Error ? e.message : e)
  process.exit(1)
})
