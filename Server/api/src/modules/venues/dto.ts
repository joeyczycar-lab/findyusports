import { Transform } from 'class-transformer'
import { IsEnum, IsNumber, IsOptional, IsString, Max, MaxLength, Min } from 'class-validator'

export enum SportType {
  Basketball = 'basketball',
  Football = 'football',
}

export class QueryVenuesDto {
  @IsOptional()
  @IsString()
  city?: string // 行政区代码如 310000

  @IsOptional()
  @IsEnum(SportType)
  sport?: SportType

  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsNumber()
  @Min(0)
  minPrice?: number

  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsNumber()
  @Min(0)
  @Max(99999)
  maxPrice?: number

  @IsOptional()
  @Transform(({ value }) => value === 'true')
  indoor?: boolean

  // 边界
  @IsOptional()
  @IsString()
  ne?: string // lng,lat

  @IsOptional()
  @IsString()
  sw?: string // lng,lat

  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsNumber()
  @Min(1)
  page?: number

  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsNumber()
  @Min(1)
  @Max(100)
  pageSize?: number

  // 支持 limit 参数（兼容前端调用）
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsNumber()
  @Min(1)
  @Max(100)
  limit?: number

  @IsOptional()
  @IsString()
  cityCode?: string // 城市代码，用于按地区筛选

  @IsOptional()
  @IsString()
  districtCode?: string // 区/县代码，次级区域筛选

  @IsOptional()
  @IsString()
  sortBy?: 'city' | 'popularity' | 'name' | 'newest' // 排序方式：按地区、按热度、按名称、按添加先后

  @IsOptional()
  @IsString()
  keyword?: string // 关键词搜索（按名称或地址）
}

export class CreateReviewDto {
  @IsNumber()
  @Min(1)
  @Max(5)
  rating!: number

  @IsString()
  content!: string
}

export class CreateVenueDto {
  @IsString()
  @MaxLength(120, { message: '场地名称不能超过 120 个字符' })
  name!: string

  @IsEnum(SportType)
  sportType!: SportType

  @IsString()
  cityCode!: string

  @IsOptional()
  @IsString()
  districtCode?: string // 区级代码，精确到区

  @IsOptional()
  @IsString()
  address?: string

  @IsNumber()
  @Min(-180)
  @Max(180)
  lng!: number

  @IsNumber()
  @Min(-90)
  @Max(90)
  lat!: number

  @IsOptional()
  @IsNumber()
  @Min(0)
  priceMin?: number

  @IsOptional()
  @IsNumber()
  @Min(0)
  priceMax?: number

  @IsOptional()
  @IsString()
  @MaxLength(120)
  priceDisplay?: string // 价格文字描述，如 "50元/小时"、"面议"

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  walkInPriceMin?: number

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  walkInPriceMax?: number

  @IsOptional()
  @IsString()
  @MaxLength(120)
  walkInPriceDisplay?: string // 散客价格文字

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  fullCourtPriceMin?: number

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  fullCourtPriceMax?: number

  @IsOptional()
  @IsString()
  @MaxLength(120)
  fullCourtPriceDisplay?: string // 包场价格文字

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  supportsWalkIn?: boolean // 是否支持散客

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  supportsFullCourt?: boolean // 是否支持包场

  @IsOptional()
  indoor?: boolean | null // null 表示既有室内也有室外

  @IsOptional()
  @IsString()
  contact?: string // 联系方式（电话、微信等）

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  requiresReservation?: boolean // 是否需要预约

  @IsOptional()
  @IsString()
  reservationMethod?: string // 预约方式（如：电话/微信/小程序 等）

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  isPublic?: boolean // 是否对外开放

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(1)
  courtCount?: number // 场地数量（篮球场/足球场数量）

  @IsOptional()
  @IsString()
  floorType?: string // 地板类型（如：木地板、塑胶、水泥等）

  @IsOptional()
  @IsString()
  playersPerSide?: string // 几人制（如：5人制、7人制、11人制）

  @IsOptional()
  @IsString()
  openHours?: string // 开放时间（如：周一至周五 9:00-22:00）

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasLighting?: boolean // 是否有灯光

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasAirConditioning?: boolean // 是否有空调

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasParking?: boolean // 是否有停车场

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasFence?: boolean // 是否有围栏

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasRestArea?: boolean // 是否有休息区

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasShower?: boolean // 是否有沐浴间

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasLocker?: boolean // 是否有储物柜

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasShop?: boolean // 是否有小卖部
}

export class UpdateVenueDto {
  @IsOptional()
  @IsString()
  @MaxLength(120, { message: '场地名称不能超过 120 个字符' })
  name?: string

  @IsOptional()
  @IsEnum(SportType)
  sportType?: SportType

  @IsOptional()
  @IsString()
  cityCode?: string

  @IsOptional()
  @IsString()
  districtCode?: string

  @IsOptional()
  @IsString()
  address?: string

  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  lng?: number

  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  lat?: number

  @IsOptional()
  @IsNumber()
  @Min(0)
  priceMin?: number

  @IsOptional()
  @IsNumber()
  @Min(0)
  priceMax?: number

  @IsOptional()
  @IsString()
  @MaxLength(120)
  priceDisplay?: string // 价格文字描述，如 "50元/小时"、"面议"

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  walkInPriceMin?: number

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  walkInPriceMax?: number

  @IsOptional()
  @IsString()
  @MaxLength(120)
  walkInPriceDisplay?: string // 散客价格文字

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  fullCourtPriceMin?: number

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(0)
  fullCourtPriceMax?: number

  @IsOptional()
  @IsString()
  @MaxLength(120)
  fullCourtPriceDisplay?: string // 包场价格文字

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  supportsWalkIn?: boolean // 是否支持散客

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  supportsFullCourt?: boolean // 是否支持包场

  @IsOptional()
  indoor?: boolean | null // null 表示既有室内也有室外

  @IsOptional()
  @IsString()
  contact?: string

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  requiresReservation?: boolean // 是否需要预约

  @IsOptional()
  @IsString()
  reservationMethod?: string // 预约方式（如：电话/微信/小程序 等）

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  isPublic?: boolean

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : Number(value))
  @IsNumber()
  @Min(1)
  courtCount?: number

  @IsOptional()
  @IsString()
  floorType?: string

  @IsOptional()
  @IsString()
  playersPerSide?: string // 几人制（如：5人制、7人制、11人制）

  @IsOptional()
  @IsString()
  openHours?: string

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasLighting?: boolean

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasAirConditioning?: boolean

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasParking?: boolean

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasFence?: boolean // 是否有围栏

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasRestArea?: boolean // 是否有休息区

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasShower?: boolean // 是否有沐浴间

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasLocker?: boolean // 是否有储物柜

  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  hasShop?: boolean // 是否有小卖部
}


