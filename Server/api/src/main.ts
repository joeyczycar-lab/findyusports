import 'reflect-metadata'
import { NestFactory } from '@nestjs/core'
import { AppModule } from './modules/app.module'
import * as dotenv from 'dotenv'
import * as path from 'path'
import * as fs from 'fs'

// 确保从项目根目录加载 .env 文件
// 在开发环境中，__dirname 指向 src/，在生产环境中指向 dist/
const projectRoot = path.resolve(__dirname, '../..')
const envPath = path.join(projectRoot, '.env')

// 检查 .env 文件是否存在
if (fs.existsSync(envPath)) {
  dotenv.config({ path: envPath })
  console.log('✅ [Main] Loaded .env file from:', envPath)
} else {
  // 尝试从当前工作目录加载
  dotenv.config()
  console.log('⚠️ [Main] .env file not found at:', envPath, ', trying default location')
}

async function bootstrap() {
  try {
    console.log('🚀 Starting NestJS application...')
    const hasDbUrl = !!(process.env.DATABASE_URL && process.env.DATABASE_URL.trim())
    console.log('📦 Environment variables:', {
      PORT: process.env.PORT,
      NODE_ENV: process.env.NODE_ENV,
      DATABASE_URL: hasDbUrl ? 'SET (' + process.env.DATABASE_URL!.substring(0, 50) + '...)' : 'NOT SET',
      DB_SSL: process.env.DB_SSL,
      JWT_SECRET: process.env.JWT_SECRET ? 'SET (length: ' + process.env.JWT_SECRET.length + ')' : 'NOT SET',
      OSS_REGION: process.env.OSS_REGION || 'NOT SET',
      OSS_ACCESS_KEY_ID: process.env.OSS_ACCESS_KEY_ID ? 'SET (length: ' + process.env.OSS_ACCESS_KEY_ID.length + ')' : 'NOT SET',
      OSS_ACCESS_KEY_SECRET: process.env.OSS_ACCESS_KEY_SECRET ? 'SET' : 'NOT SET',
      OSS_BUCKET: process.env.OSS_BUCKET || 'NOT SET',
    })
    if (!hasDbUrl) {
      if (process.env.NODE_ENV === 'production') {
        console.error('❌ [Main] 生产环境（Railway）必须设置 DATABASE_URL。请在 Railway 中关联 PostgreSQL 服务或在变量中配置 DATABASE_URL 后重新部署。')
        process.exit(1)
      }
      console.warn('⚠️ [Main] 开发环境：DATABASE_URL 未设置，将连接本机 PostgreSQL (127.0.0.1:5432)。')
    } else {
      console.log('✅ [Main] 使用 Railway 数据库 (DATABASE_URL)')
    }

    const app = await NestFactory.create(AppModule, { cors: true })
    const port = process.env.PORT ? Number(process.env.PORT) : 4000
    
    console.log(`🌐 Configuring CORS...`)
    app.enableCors({ origin: true, credentials: true })
    
    // 添加全局请求日志中间件
    app.use((req: any, res: any, next: any) => {
      if (req.url?.includes('/analytics/stats')) {
        console.log('📡 [Global Middleware] Request received:', {
          method: req.method,
          url: req.url,
          hasAuth: !!req.headers.authorization,
          authPreview: req.headers.authorization ? req.headers.authorization.substring(0, 30) + '...' : 'none',
        })
      }
      next()
    })
    
    console.log(`🔌 Binding to 0.0.0.0:${port}...`)
    // 显式绑定到 0.0.0.0 以确保外部可访问（Railway 需要）
    await app.listen(port, '0.0.0.0')
    
    // eslint-disable-next-line no-console
    console.log(`✅ API running on http://0.0.0.0:${port}`)
    console.log(`✅ Health check available at http://0.0.0.0:${port}/health`)
    console.log(`✅ Health check also available at http://0.0.0.0:${port}/`)
    console.log(`✅ All routes mapped successfully`)
    console.log(`✅ Service is ready to accept connections`)
    console.log(`✅ Waiting for health checks from Railway...`)
    
    // Keep the process alive and handle graceful shutdown
    process.on('SIGTERM', () => {
      console.log('⚠️  SIGTERM received, shutting down gracefully...')
      app.close().then(() => {
        console.log('✅ Application closed gracefully')
        process.exit(0)
      })
    })
    
    process.on('SIGINT', () => {
      console.log('⚠️  SIGINT received, shutting down gracefully...')
      app.close().then(() => {
        console.log('✅ Application closed gracefully')
        process.exit(0)
      })
    })
    
    // Log periodic health status (less frequent to reduce log noise)
    setInterval(() => {
      console.log(`💓 Health check: Service is running on port ${port}`)
    }, 60000) // Every 60 seconds (reduced from 30)
  } catch (error) {
    console.error('❌ Failed to start application:', error)
    if (error instanceof Error) {
      console.error('Error message:', error.message)
      console.error('Error stack:', error.stack)
    }
    process.exit(1)
  }
}

bootstrap().catch((error) => {
  console.error('❌ Unhandled error in bootstrap:', error)
  process.exit(1)
})


