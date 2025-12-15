import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { VenueImageEntity } from './modules/venues/image.entity'
import { ReviewEntity } from './modules/venues/review.entity'
import { UserEntity } from './modules/auth/user.entity'
import { dataSourceOptions } from './data-source'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: true,
  logging: false,
})

async function main() {
  await ds.initialize()
  const repo = ds.getRepository(VenueEntity)
  const imgRepo = ds.getRepository(VenueImageEntity)
  const reviewRepo = ds.getRepository(ReviewEntity)
  const userRepo = ds.getRepository(UserEntity)
  // 清空并插入一些北京范围内数据
  await reviewRepo.delete({})
  await imgRepo.delete({})
  await repo.delete({})
  await userRepo.delete({})
  const user = userRepo.create({
    phone: '13800000000',
    nickname: 'czycar',
    password: '$2b$10$abcdefghijklmnopqrstuv', // placeholder hash
  })
  const savedUser = await userRepo.save(user)
  const neLng = 116.55, neLat = 39.98, swLng = 116.30, swLat = 39.84
  const randomIn = (min: number, max: number) => Math.random() * (max - min) + min
  const rows: VenueEntity[] = []
  for (let i = 0; i < 50; i++) {
    const v = new VenueEntity()
    v.name = `示例场地 ${i + 1}`
    v.sportType = i % 2 === 0 ? 'basketball' : 'football'
    v.cityCode = '110000'
    v.address = '北京市某区某路'
    v.lng = randomIn(swLng, neLng)
    v.lat = randomIn(swLat, neLat)
    // geometry point
    // 用 WKT 格式由 TypeORM 写入 geometry 列
    v.geom = { type: 'Point', coordinates: [v.lng, v.lat] } as any
    v.priceMin = Math.random() > 0.5 ? 0 : Math.floor(Math.random() * 80) + 20
    v.priceMax = v.priceMin ? v.priceMin + Math.floor(Math.random() * 40) : 0
    v.indoor = Math.random() > 0.6 ? false : true
    rows.push(v)
  }
  const saved = await repo.save(rows)
  // images & reviews
  const imgs: VenueImageEntity[] = []
  const revs: ReviewEntity[] = []
  saved.forEach((v, idx) => {
    for (let k = 0; k < 3; k++) {
      const img = new VenueImageEntity()
      img.venue = v as any
      img.url = `https://images.unsplash.com/photo-1544917841-9fdd63f3dcf9?q=80&w=800&auto=format&fit=crop&ixid=${idx}-${k}`
      img.sort = k
      img.user = savedUser as any
      img.userId = savedUser.id
      imgs.push(img)
    }
    const r = new ReviewEntity()
    r.venue = v as any
    r.rating = Math.floor(Math.random()*2)+4
    r.content = '场地不错，灯光很好，地面干净。'
    r.user = savedUser as any
    r.userId = savedUser.id
    revs.push(r)
  })
  await imgRepo.save(imgs)
  await reviewRepo.save(revs)
  // eslint-disable-next-line no-console
  console.log('Seed completed: venues', saved.length, 'images', imgs.length, 'reviews', revs.length)
  await ds.destroy()
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})