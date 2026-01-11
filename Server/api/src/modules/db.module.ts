import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { DataSourceOptions } from 'typeorm'

function buildTypeOrmOptions(): DataSourceOptions {
  const dbUrl = process.env.DATABASE_URL
  console.log('🔍 [DB Module] Building TypeORM options:', {
    hasDatabaseUrl: !!dbUrl,
    databaseUrlPreview: dbUrl ? dbUrl.substring(0, 50) + '...' : 'none',
    dbSsl: process.env.DB_SSL,
  })
  
  if (dbUrl) {
    const ssl =
      (process.env.DB_SSL || '').toLowerCase() === 'true'
        ? { rejectUnauthorized: false }
        : undefined
    console.log('✅ [DB Module] Using DATABASE_URL with SSL:', !!ssl)
    return {
      type: 'postgres',
      url: dbUrl,
      ssl,
      synchronize: false,
    }
  }

  console.log('⚠️ [DB Module] DATABASE_URL not set, using default localhost configuration')
  return {
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
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


