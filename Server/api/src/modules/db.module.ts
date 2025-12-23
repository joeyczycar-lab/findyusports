import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { DataSourceOptions } from 'typeorm'

function buildTypeOrmOptions(): DataSourceOptions {
  const dbUrl = process.env.DATABASE_URL
  if (dbUrl) {
    const ssl =
      (process.env.DB_SSL || '').toLowerCase() === 'true'
        ? { rejectUnauthorized: false }
        : undefined
    return {
      type: 'postgres',
      url: dbUrl,
      ssl,
      synchronize: false,
    }
  }

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
        const baseOptions = buildTypeOrmOptions()
        return {
          ...baseOptions,
          autoLoadEntities: true,
          // 添加连接选项，避免阻塞应用启动
          // 这样健康检查端点可以立即响应
          extra: {
            ...(baseOptions.extra || {}),
            // PostgreSQL 连接选项
            connectionTimeoutMillis: 10000, // 10秒连接超时
            statement_timeout: 30000, // 30秒语句超时
          },
        }
      },
    }),
  ],
})
export class DbModule {}


