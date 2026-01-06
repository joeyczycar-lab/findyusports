import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource, DataSourceOptions } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { VenueImageEntity } from './modules/venues/image.entity'
import { ReviewEntity } from './modules/venues/review.entity'
import { UserEntity } from './modules/auth/user.entity'
import { PageViewEntity } from './modules/analytics/page-view.entity'

dotenv.config()

function buildDataSourceOptions(): DataSourceOptions {
  const entities = [VenueEntity, VenueImageEntity, ReviewEntity, UserEntity, PageViewEntity]
  const migrations = [__dirname + '/migrations/*.{ts,js}']
  const common: DataSourceOptions = {
  type: 'postgres',
    entities,
    migrations,
    synchronize: false,
  }

  const dbUrl = process.env.DATABASE_URL
  if (dbUrl) {
    const ssl =
      (process.env.DB_SSL || '').toLowerCase() === 'true'
        ? { rejectUnauthorized: false }
        : undefined
    return {
      ...common,
      url: dbUrl,
      ssl,
    }
  }

  return {
    ...common,
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  username: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASS || 'postgres',
  database: process.env.DB_NAME || 'venues',
  }
}

export const dataSourceOptions = buildDataSourceOptions()

// 创建 DataSource 实例
const AppDataSource = new DataSource(dataSourceOptions)

// 默认导出，供 TypeORM CLI 使用（必须只有一个导出）
export default AppDataSource


