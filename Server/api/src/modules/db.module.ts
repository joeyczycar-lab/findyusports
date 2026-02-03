import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { DataSourceOptions } from 'typeorm'

function buildTypeOrmOptions(): DataSourceOptions {
  const dbUrl = (process.env.DATABASE_URL || '').trim()
  const isProduction = process.env.NODE_ENV === 'production'

  console.log('🔍 [DB Module] Building TypeORM options:', {
    hasDatabaseUrl: !!dbUrl,
    databaseUrlPreview: dbUrl ? dbUrl.substring(0, 50) + '...' : 'none',
    dbSsl: process.env.DB_SSL,
    isProduction,
  })

  // 生产环境（含 Railway）强制使用 DATABASE_URL，不连接本机
  if (isProduction && !dbUrl) {
    console.error('❌ [DB Module] 生产环境必须设置 DATABASE_URL（Railway 会在添加 PostgreSQL 后自动注入）。请在 Railway 变量中配置 DATABASE_URL 并重新部署。')
    throw new Error('DATABASE_URL is required in production. Please set it in Railway variables (or link PostgreSQL service).')
  }

  if (dbUrl) {
    const ssl =
      (process.env.DB_SSL || '').toLowerCase() === 'true'
        ? { rejectUnauthorized: false }
        : undefined
    console.log('✅ [DB Module] Using DATABASE_URL (Railway)', { ssl: !!ssl })
    return {
      type: 'postgres',
      url: dbUrl,
      ssl,
      synchronize: false,
    }
  }

  // 仅开发环境：使用本机 PostgreSQL
  const host = process.env.DB_HOST || '127.0.0.1'
  console.log('⚠️ [DB Module] 开发环境，使用本机数据库:', { host, port: process.env.DB_PORT || 5432 })
  return {
    type: 'postgres',
    host,
    port: Number(process.env.DB_PORT || 5432),
    username: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASS || 'postgres',
    database: process.env.DB_NAME || 'venues',
    synchronize: false,
  }
}

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      useFactory: () => {
        const options = buildTypeOrmOptions()
        return {
          ...options,
          autoLoadEntities: true,
          // 添加连接重试配置
          retryAttempts: 5, // 重试5次
          retryDelay: 3000, // 每次重试间隔3秒
          // 连接超时设置
          connectTimeoutMS: 10000, // 10秒连接超时
          // 连接池配置
          extra: {
            max: 10, // 最大连接数
            min: 2, // 最小连接数
            idleTimeoutMillis: 30000, // 空闲连接超时
            connectionTimeoutMillis: 10000, // 连接超时
          },
        }
      },
    }),
  ],
})
export class DbModule {}


