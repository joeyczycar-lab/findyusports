import { Column, Entity, Index, PrimaryGeneratedColumn } from 'typeorm'

@Entity('venue')
export class VenueEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Column({ length: 120 })
  name!: string

  @Column({ type: 'varchar', length: 20, name: 'sportType' })
  sportType!: 'basketball' | 'football'

  @Column({ type: 'varchar', length: 6, name: 'cityCode' })
  cityCode!: string

  @Column({ type: 'varchar', length: 6, nullable: true, name: 'district_code' })
  districtCode?: string // 区级代码，精确到区

  @Column({ type: 'varchar', length: 200, nullable: true })
  address?: string

  @Index()
  @Column({ type: 'double precision' })
  lng!: number

  @Index()
  @Column({ type: 'double precision' })
  lat!: number

  // PostGIS geometry(Point, 4326)
  // 注意：如果数据库中没有 geom 列，TypeORM 可能会报错
  // 代码中已经有检查逻辑，如果 geom 列不存在，会使用原生 SQL 查询
  @Column({
    type: 'geometry',
    spatialFeatureType: 'Point',
    srid: 4326,
    nullable: true,
    select: false, // 默认不选择此列，避免在查询时出错
  })
  geom?: any

  @Column({ type: 'int', nullable: true, name: 'priceMin' })
  priceMin?: number

  @Column({ type: 'int', nullable: true, name: 'priceMax' })
  priceMax?: number

  @Column({ type: 'boolean', nullable: true, name: 'supports_walk_in' })
  supportsWalkIn?: boolean // 是否支持散客

  @Column({ type: 'int', nullable: true, name: 'walk_in_price_min' })
  walkInPriceMin?: number // 散客最低价格（元/小时）

  @Column({ type: 'int', nullable: true, name: 'walk_in_price_max' })
  walkInPriceMax?: number // 散客最高价格（元/小时）

  @Column({ type: 'boolean', nullable: true, name: 'supports_full_court' })
  supportsFullCourt?: boolean // 是否支持包场

  @Column({ type: 'int', nullable: true, name: 'full_court_price_min' })
  fullCourtPriceMin?: number // 包场最低价格（元/小时）

  @Column({ type: 'int', nullable: true, name: 'full_court_price_max' })
  fullCourtPriceMax?: number // 包场最高价格（元/小时）

  @Column({ type: 'boolean', nullable: true })
  indoor?: boolean

  @Column({ type: 'varchar', length: 100, nullable: true })
  contact?: string // 联系方式（电话、微信等）

  @Column({ type: 'boolean', nullable: true, name: 'requires_reservation' })
  requiresReservation?: boolean // 是否需要预约

  @Column({ type: 'varchar', length: 200, nullable: true, name: 'reservation_method' })
  reservationMethod?: string // 预约方式（如：电话/微信/小程序 等）

  @Column({ type: 'boolean', nullable: true, default: true, name: 'is_public' })
  isPublic?: boolean // 是否对外开放

  @Column({ type: 'int', nullable: true, name: 'court_count' })
  courtCount?: number // 场地数量（篮球场/足球场数量）

  @Column({ type: 'varchar', length: 50, nullable: true, name: 'floor_type' })
  floorType?: string // 地板类型（如：木地板、塑胶、水泥等）

  @Column({ type: 'varchar', length: 200, nullable: true, name: 'open_hours' })
  openHours?: string // 开放时间（如：周一至周五 9:00-22:00）

  @Column({ type: 'boolean', nullable: true, name: 'has_lighting' })
  hasLighting?: boolean // 是否有灯光

  @Column({ type: 'boolean', nullable: true, name: 'has_air_conditioning' })
  hasAirConditioning?: boolean // 是否有空调

  @Column({ type: 'boolean', nullable: true, name: 'has_parking' })
  hasParking?: boolean // 是否有停车场

  @Column({ type: 'boolean', nullable: true, name: 'has_rest_area' })
  hasRestArea?: boolean // 是否有休息区

  @Column({ type: 'boolean', nullable: true, name: 'has_shower', select: false })
  hasShower?: boolean // 是否有沐浴间

  @Column({ type: 'boolean', nullable: true, name: 'has_locker', select: false })
  hasLocker?: boolean // 是否有储物柜

  @Column({ type: 'boolean', nullable: true, name: 'has_shop', select: false })
  hasShop?: boolean // 是否有小卖部
}


