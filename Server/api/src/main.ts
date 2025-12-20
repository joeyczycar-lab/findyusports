import 'reflect-metadata'
import { NestFactory } from '@nestjs/core'
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
    
    console.log(`🌐 Configuring CORS...`)
    app.enableCors({ origin: true, credentials: true })
    
    console.log(`🔌 Binding to 0.0.0.0:${port}...`)
    // 显式绑定到 0.0.0.0 以确保外部可访问（Railway 需要）
    await app.listen(port, '0.0.0.0')
    
    // eslint-disable-next-line no-console
    console.log(`✅ API running on http://0.0.0.0:${port}`)
    console.log(`✅ Health check available at http://0.0.0.0:${port}/health`)
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


