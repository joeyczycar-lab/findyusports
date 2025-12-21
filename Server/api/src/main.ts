import 'reflect-metadata'
import { NestFactory } from '@nestjs/core'
import { ValidationPipe } from '@nestjs/common'
import { AppModule } from './modules/app.module'
import * as dotenv from 'dotenv'

dotenv.config()

async function bootstrap() {
  try {
    console.log('🚀 Starting NestJS application...')
    console.log('📦 Environment variables:', {
      PORT: process.env.PORT,
      NODE_ENV: process.env.NODE_ENV,
      DATABASE_URL: process.env.DATABASE_URL ? 'SET' : 'NOT SET',
    })

    const app = await NestFactory.create(AppModule, { cors: true })
    const port = process.env.PORT ? Number(process.env.PORT) : 4000
    
    // 启用全局验证管道，用于处理 DTO 验证错误
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true, // 自动过滤掉未定义的属性
        forbidNonWhitelisted: false, // 不禁止未定义的属性，只过滤
        transform: true, // 自动转换类型
        transformOptions: {
          enableImplicitConversion: true,
        },
      })
    )
    
    console.log(`🌐 Configuring CORS...`)
    app.enableCors({ origin: true, credentials: true })
    
    console.log(`🔌 Binding to 0.0.0.0:${port}...`)
    // 显式绑定到 0.0.0.0 以确保外部可访问（Railway 需要）
    await app.listen(port, '0.0.0.0')
    
    // eslint-disable-next-line no-console
    console.log(`✅ API running on http://0.0.0.0:${port}`)
    console.log(`✅ Health check available at http://0.0.0.0:${port}/health`)
    console.log(`✅ Health check also available at http://0.0.0.0:${port}/`)
    console.log(`✅ All routes mapped successfully`)
    console.log(`✅ Service is ready to accept connections`)
    console.log(`✅ Application fully initialized and ready`)
    console.log(`✅ Waiting for health checks from Railway...`)
    
    // Give Railway a moment to recognize the service is up
    // This helps prevent premature health check failures
    await new Promise(resolve => setTimeout(resolve, 1000))
    console.log(`✅ Service is now fully ready and stable`)
    
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


