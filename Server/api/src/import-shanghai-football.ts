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

  const hasGeomColumn = repo.metadata.columns.some((c) => c.propertyName === 'geom')
  const entities: VenueEntity[] = toInsert.map((row) => {
    const { lng, lat } = getLngLat(row)
    const v = new VenueEntity()
    v.name = row.name.trim()
    v.sportType = 'football'
    v.cityCode = SHANGHAI_CITY_CODE
    v.districtCode = row.districtCode || undefined
    v.address = row.address?.trim() || undefined
    v.lng = lng
    v.lat = lat
    v.openHours = row.openHours?.trim() ? row.openHours.trim().slice(0, 200) : undefined
    v.playersPerSide = row.playersPerSide?.trim() ? row.playersPerSide.trim().slice(0, 20) : undefined
    v.contact = row.contact?.trim() ? row.contact.trim().slice(0, 100) : undefined
    v.isPublic = row.isPublic !== false
    v.indoor = row.indoor ?? false
    v.supportsWalkIn = row.supportsWalkIn ?? true
    v.supportsFullCourt = row.supportsFullCourt ?? true
    v.priceDisplay = row.priceDisplay?.trim() ? row.priceDisplay.trim().slice(0, 120) : undefined
    v.requiresReservation = row.reservationMethod ? true : undefined
    v.reservationMethod = row.reservationMethod?.trim() ? row.reservationMethod.trim().slice(0, 200) : undefined
    v.courtCount = row.courtCount
    v.floorType = row.floorType?.trim() ? row.floorType.trim().slice(0, 50) : undefined
    const fac = parseFacilities(row.facilities)
    v.hasLighting = fac.hasLighting
    v.hasParking = fac.hasParking
    v.hasFence = fac.hasFence
    v.hasRestArea = fac.hasRestArea
    v.hasShower = fac.hasShower
    v.hasAirConditioning = fac.hasAirConditioning
    if (hasGeomColumn) {
      v.geom = { type: 'Point', coordinates: [lng, lat] } as any
    }
    return v
  })

  const saved = await repo.save(entities)
  console.log(`✅ 已新增 ${saved.length} 个上海足球场地`)
  saved.forEach((v, i) => console.log(`   ${i + 1}. ${v.name} (ID: ${v.id})`))
  await ds.destroy()
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
