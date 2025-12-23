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
        const options = {
          ...buildTypeOrmOptions(),
          autoLoadEntities: true,
          // 延迟连接，避免阻塞应用启动
          // 这样健康检查端点可以立即响应
          connectTimeoutMS: 10000, // 10秒连接超时
          retryAttempts: 3,
          retryDelay: 3000,
        }
        return options
      },
    }),
  ],
})
export class DbModule {}


