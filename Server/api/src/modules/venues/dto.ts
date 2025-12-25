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
}


