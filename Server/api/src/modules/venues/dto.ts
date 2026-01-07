import { Transform } from 'class-transformer'
import { IsEnum, IsNumber, IsOptional, IsString, Max, Min } from 'class-validator'

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
  sortBy?: 'city' | 'popularity' | 'name' // 排序方式：按地区、按热度、按名称
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
  indoor?: boolean

  @IsOptional()
  @IsString()
  contact?: string // 联系方式（电话、微信等）

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
}


