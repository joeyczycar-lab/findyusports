import { Column, Entity, Index, PrimaryGeneratedColumn } from 'typeorm'

@Entity('venue')
export class VenueEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Column({ length: 120 })
  name!: string

  @Column({ type: 'varchar', length: 20 })
  sportType!: 'basketball' | 'football'

  @Column({ type: 'varchar', length: 6 })
  cityCode!: string

  @Column({ type: 'varchar', length: 200, nullable: true })
  address?: string

  @Index()
  @Column({ type: 'double precision' })
  lng!: number

  @Index()
  @Column({ type: 'double precision' })
  lat!: number

  // PostGIS geometry(Point, 4326)
  @Column({
    type: 'geometry',
    spatialFeatureType: 'Point',
    srid: 4326,
    nullable: true,
  })
  geom?: any

  @Column({ type: 'int', nullable: true })
  priceMin?: number

  @Column({ type: 'int', nullable: true })
  priceMax?: number

  @Column({ type: 'boolean', nullable: true })
  indoor?: boolean

  @Column({ type: 'varchar', length: 100, nullable: true })
  contact?: string // 联系方式（电话、微信等）

  @Column({ type: 'boolean', nullable: true, default: true, name: 'is_public' })
  isPublic?: boolean // 是否对外开放
}


