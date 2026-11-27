import 'reflect-metadata'
import * as dotenv from 'dotenv'
import * as fs from 'fs'
import * as path from 'path'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { dataSourceOptions } from './data-source'
import { geocodeAddress } from './lib/geocode'

dotenv.config()

/**
 * 批量导入场地（带自动查重 + 字段校验）
 *
 * 用法:
 *   # 先预览（不写库），生成校验/查重报告
 *   npm run add-venue:bulk -- <csv路径> --dry-run
 *   # 正式入库
 *   npm run add-venue:bulk -- <csv路径>
 *
 * 必需列: name, sportType(basketball|football), cityCode, lng, lat
 * 可选列: districtCode, address, priceMin, priceMax, priceDisplay,
 *   supportsWalkIn, walkInPriceDisplay, supportsFullCourt, fullCourtPriceDisplay,
 *   indoor, contact, requiresReservation, reservationMethod, isPublic,
 *   courtCount, floorType, playersPerSide, openHours,
 *   hasLighting, hasAirConditioning, hasParking, hasFence, hasRestArea,
 *   hasShower, hasLocker, hasShop, approvalStatus
 */

const ds = new DataSource({ ...dataSourceOptions, synchronize: false, logging: false })

// ---- 轻量 CSV 解析（支持双引号、逗号转义、换行） ----
function parseCsv(text: string): string[][] {
  const rows: string[][] = []
  let row: string[] = []
  let field = ''
  let inQuotes = false
  for (let i = 0; i < text.length; i++) {
    const ch = text[i]
    if (inQuotes) {
      if (ch === '"') {
        if (text[i + 1] === '"') { field += '"'; i++ } else inQuotes = false
      } else field += ch
    } else {
      if (ch === '"') inQuotes = true
      else if (ch === ',') { row.push(field); field = '' }
      else if (ch === '\n') { row.push(field); rows.push(row); row = []; field = '' }
      else if (ch === '\r') { /* skip */ }
      else field += ch
    }
  }
  if (field.length > 0 || row.length > 0) { row.push(field); rows.push(row) }
  return rows.filter((r) => r.some((c) => c.trim() !== ''))
}

function norm(s?: string | null): string {
  return String(s ?? '')
    .toLowerCase()
    .replace(/[\s（）()【】\[\]{}·•\-—_，,。.、/\\:：;；#＃'"'“”‘’!?！？]/g, '')
}

function toBool(v: string | undefined): boolean | undefined {
  if (v == null || v.trim() === '') return undefined
  return ['true', '1', 'yes', '是', '开放'].includes(v.trim().toLowerCase())
}
function toNum(v: string | undefined): number | undefined {
  if (v == null || v.trim() === '') return undefined
  const n = Number(v)
  return Number.isFinite(n) ? n : undefined
}

interface Row {
  raw: Record<string, string>
  errors: string[]
}

async function main() {
  const args = process.argv.slice(2)
  if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
    console.log('批量导入: npm run add-venue:bulk -- <csv路径> [--dry-run]')
    process.exit(0)
  }
  const dryRun = args.includes('--dry-run')
  const csvPath = path.resolve(args[0])
  if (!fs.existsSync(csvPath)) { console.error('❌ 文件不存在:', csvPath); process.exit(1) }

  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)

  const rows = parseCsv(fs.readFileSync(csvPath, 'utf-8'))
  if (rows.length < 2) { console.error('❌ CSV 至少需要标题行 + 一行数据'); process.exit(1) }
  const headers = rows[0].map((h) => h.trim())
  console.log(`📋 列: ${headers.join(', ')}`)

  const required = ['name', 'sportType', 'cityCode']
  const missing = required.filter((c) => !headers.includes(c))
  if (missing.length) { console.error('❌ 缺少必需列:', missing.join(', ')); process.exit(1) }

  // 库内已有：规范化名称集合、规范化地址集合（同运动类型）
  const existing = await repo.query(`SELECT name, address, "sportType" FROM venue`)
  const nameSet = new Set<string>()
  const addrSet = new Set<string>()
  for (const e of existing) {
    nameSet.add(`${e.sportType}|${norm(e.name)}`)
    if (e.address) addrSet.add(`${e.sportType}|${norm(e.address)}`)
  }
  console.log(`🗄️  库内已有 ${existing.length} 条场地，开始查重校验...`)

  const valid: VenueEntity[] = []
  const skipped: { line: number; name: string; reason: string }[] = []
  const seenInFile = new Set<string>()

  for (let i = 1; i < rows.length; i++) {
    const cells = rows[i]
    const raw: Record<string, string> = {}
    headers.forEach((h, idx) => (raw[h] = (cells[idx] ?? '').trim()))
    const errors: string[] = []

    const name = raw.name
    const sportType = (raw.sportType || '').toLowerCase()
    if (!name) errors.push('名称为空')
    if (!['basketball', 'football'].includes(sportType)) errors.push('sportType 必须为 basketball/football')
    if (!raw.cityCode) errors.push('cityCode 为空')
    let lng = toNum(raw.lng)
    let lat = toNum(raw.lat)
    if (lng != null && (lng < -180 || lng > 180 || lat == null || lat < -90 || lat > 90)) errors.push('坐标越界')

    // 查重：库内 + 文件内重复
    const dupKey = `${sportType}|${norm(name)}`
    if (!errors.length) {
      if (nameSet.has(dupKey)) skipped.push({ line: i + 1, name, reason: '库内同名' })
      else if (raw.address && addrSet.has(`${sportType}|${norm(raw.address)}`)) skipped.push({ line: i + 1, name, reason: '库内同地址' })
      else if (seenInFile.has(dupKey)) skipped.push({ line: i + 1, name, reason: '文件内重复' })
    }

    // 坐标缺失时调用高德地理编码补全
    let geocoded: { lng: number; lat: number; adcode?: string } | null = null
    if (!errors.length && (lng == null || lat == null)) {
      if (!raw.address) {
        errors.push('无地址且无坐标，无法地理编码')
      } else {
        geocoded = await geocodeAddress(raw.address, raw.cityCode)
        if (!geocoded) errors.push('地理编码未命中，无法确定坐标')
        else { lng = geocoded.lng; lat = geocoded.lat }
      }
    }

    if (errors.length) { skipped.push({ line: i + 1, name: name || '(空)', reason: errors.join('; ') }); continue }
    seenInFile.add(dupKey)

    const v = new VenueEntity()
    v.name = name.slice(0, 120)
    v.sportType = sportType as 'basketball' | 'football'
    v.cityCode = raw.cityCode
    v.districtCode = raw.districtCode || geocoded?.adcode || undefined
    v.address = raw.address ? raw.address.slice(0, 200) : undefined
    v.lng = lng!
    v.lat = lat!
    v.priceMin = toNum(raw.priceMin)
    v.priceMax = toNum(raw.priceMax)
    v.priceDisplay = raw.priceDisplay || undefined
    v.supportsWalkIn = toBool(raw.supportsWalkIn)
    v.walkInPriceDisplay = raw.walkInPriceDisplay || undefined
    v.supportsFullCourt = toBool(raw.supportsFullCourt)
    v.fullCourtPriceDisplay = raw.fullCourtPriceDisplay || undefined
    v.indoor = toBool(raw.indoor)
    v.contact = raw.contact || undefined
    v.requiresReservation = toBool(raw.requiresReservation)
    v.reservationMethod = raw.reservationMethod || undefined
    v.isPublic = raw.isPublic === '' ? true : toBool(raw.isPublic) ?? true
    v.courtCount = toNum(raw.courtCount)
    v.floorType = raw.floorType || undefined
    v.playersPerSide = raw.playersPerSide || undefined
    v.openHours = raw.openHours || undefined
    v.hasLighting = toBool(raw.hasLighting)
    v.hasAirConditioning = toBool(raw.hasAirConditioning)
    v.hasParking = toBool(raw.hasParking)
    v.hasFence = toBool(raw.hasFence)
    v.hasRestArea = toBool(raw.hasRestArea)
    v.hasShower = toBool(raw.hasShower)
    v.hasLocker = toBool(raw.hasLocker)
    v.hasShop = toBool(raw.hasShop)
    valid.push(v)
  }

  console.log(`\n📊 校验结果: 有效 ${valid.length} 条, 跳过 ${skipped.length} 条`)
  if (skipped.length) {
    console.log('\n⏭️  跳过明细:')
    skipped.forEach((s) => console.log(`  行${s.line} [${s.reason}] ${s.name}`))
  }

  if (dryRun) {
    console.log('\n🧪 dry-run 模式，未写入数据库。去掉 --dry-run 正式入库。')
    await ds.destroy()
    return
  }

  if (valid.length === 0) { console.log('没有可导入的有效数据'); await ds.destroy(); return }

  console.log(`\n💾 开始写入 ${valid.length} 条...`)
  const saved = await repo.save(valid)
  console.log(`✅ 成功导入 ${saved.length} 个场地`)
  saved.forEach((v, idx) => console.log(`  ${idx + 1}. ${v.name} (ID: ${v.id})`))
  await ds.destroy()
}

main().catch((e) => {
  console.error('❌ 错误:', e instanceof Error ? e.message : e)
  process.exit(1)
})
