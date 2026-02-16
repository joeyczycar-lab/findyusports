import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { dataSourceOptions } from './data-source'
import {
  shanghaiFootballVenues,
  SHANGHAI_CITY_CODE,
  getLngLat,
  parseFacilities,
  ShanghaiFootballVenueRow,
} from './data/shanghai-football-venues'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: false,
})

async function main() {
  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)

  // 已存在的场地名称（全库按名称去重，同名则跳过）
  const existingNames = new Set<string>(
    (await repo.find({ select: { name: true } })).map((v) => v.name.trim())
  )
  console.log(`📋 库中已有 ${existingNames.size} 个场地名称`)

  const toInsert: ShanghaiFootballVenueRow[] = []
  const skipped: string[] = []
  for (const row of shanghaiFootballVenues) {
    const name = (row.name || '').trim()
    if (!name) continue
    if (existingNames.has(name)) {
      skipped.push(name)
      continue
    }
    toInsert.push(row)
    existingNames.add(name)
  }

  if (skipped.length > 0) {
    console.log(`⏭️  跳过已存在同名场地（${skipped.length} 个）: ${skipped.join(', ')}`)
  }
  if (toInsert.length === 0) {
    console.log('✅ 没有需要新增的场地')
    await ds.destroy()
    return
  }

  // 用原始 SQL 只插入表中存在的列，避免 TypeORM 或缺失列导致 42703
  const tableName = repo.metadata.tableName
  const colRows = await repo.query(
    `SELECT column_name FROM information_schema.columns WHERE table_name = $1 ORDER BY ordinal_position`,
    [tableName]
  )
  const existingCols = colRows.map((r: { column_name: string }) => r.column_name)
  const colSet = new Set(existingCols)
  const has = (c: string) => colSet.has(c)

  // 只选我们可能用到的、且表中存在的列（用数据库列名）
  const insertCols: string[] = []
  if (has('name')) insertCols.push('name')
  if (has('sportType')) insertCols.push('sportType')
  if (has('cityCode')) insertCols.push('cityCode')
  if (has('address')) insertCols.push('address')
  if (has('lng')) insertCols.push('lng')
  if (has('lat')) insertCols.push('lat')
  if (has('indoor')) insertCols.push('indoor')
  if (has('district_code')) insertCols.push('district_code')
  if (has('open_hours')) insertCols.push('open_hours')
  if (has('players_per_side')) insertCols.push('players_per_side')
  if (has('contact')) insertCols.push('contact')
  if (has('is_public')) insertCols.push('is_public')
  if (has('supports_walk_in')) insertCols.push('supports_walk_in')
  if (has('supports_full_court')) insertCols.push('supports_full_court')
  if (has('price_display')) insertCols.push('price_display')
  if (has('requires_reservation')) insertCols.push('requires_reservation')
  if (has('reservation_method')) insertCols.push('reservation_method')
  if (has('court_count')) insertCols.push('court_count')
  if (has('floor_type')) insertCols.push('floor_type')
  if (has('has_lighting')) insertCols.push('has_lighting')
  if (has('has_parking')) insertCols.push('has_parking')
  if (has('has_fence')) insertCols.push('has_fence')
  if (has('has_rest_area')) insertCols.push('has_rest_area')
  if (has('has_shower')) insertCols.push('has_shower')
  if (has('has_air_conditioning')) insertCols.push('has_air_conditioning')

  const quoteCol = (c: string) => (c.startsWith('"') ? c : /^[a-z0-9_]+$/.test(c) ? c : `"${c}"`)
  const quotedCols = insertCols.map(quoteCol)
  const placeholders = insertCols.map((_, i) => `$${i + 1}`).join(', ')
  const sql = `INSERT INTO ${tableName} (${quotedCols.join(', ')}) VALUES (${placeholders})`

  const valueByCol: Record<string, (row: ShanghaiFootballVenueRow, lng: number, lat: number) => unknown> = {
    name: (r) => r.name.trim(),
    sportType: () => 'football',
    cityCode: () => SHANGHAI_CITY_CODE,
    address: (r) => (r.address?.trim() ?? '').slice(0, 200) || null,
    lng: (_, lng) => lng,
    lat: (_, __, lat) => lat,
    indoor: (r) => r.indoor ?? false,
    district_code: (r) => r.districtCode || null,
    open_hours: (r) => (r.openHours?.trim() ?? '').slice(0, 200) || null,
    players_per_side: (r) => (r.playersPerSide?.trim() ?? '').slice(0, 20) || null,
    contact: (r) => (r.contact?.trim() ?? '').slice(0, 100) || null,
    is_public: (r) => r.isPublic !== false,
    supports_walk_in: (r) => r.supportsWalkIn ?? true,
    supports_full_court: (r) => r.supportsFullCourt ?? true,
    price_display: (r) => (r.priceDisplay?.trim() ?? '').slice(0, 120) || null,
    requires_reservation: (r) => !!r.reservationMethod,
    reservation_method: (r) => (r.reservationMethod?.trim() ?? '').slice(0, 200) || null,
    court_count: (r) => r.courtCount ?? null,
    floor_type: (r) => (r.floorType?.trim() ?? '').slice(0, 50) || null,
    has_lighting: (r) => parseFacilities(r.facilities).hasLighting ?? null,
    has_parking: (r) => parseFacilities(r.facilities).hasParking ?? null,
    has_fence: (r) => parseFacilities(r.facilities).hasFence ?? null,
    has_rest_area: (r) => parseFacilities(r.facilities).hasRestArea ?? null,
    has_shower: (r) => parseFacilities(r.facilities).hasShower ?? null,
    has_air_conditioning: (r) => parseFacilities(r.facilities).hasAirConditioning ?? null,
  }

  let inserted = 0
  for (const row of toInsert) {
    const { lng, lat } = getLngLat(row)
    const values = insertCols.map(col => {
      const fn = valueByCol[col]
      return fn ? fn(row, lng, lat) : null
    })
    await repo.query(sql, values)
    inserted++
  }

  console.log(`✅ 已新增 ${inserted} 个上海足球场地`)
  toInsert.forEach((row, i) => console.log(`   ${i + 1}. ${row.name.trim()}`))
  await ds.destroy()
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
