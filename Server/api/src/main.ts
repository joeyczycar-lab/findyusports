import 'reflect-metadata'
import { NestFactory } from '@nestjs/core'
import { AppModule } from './modules/app.module'
import * as dotenv from 'dotenv'

dotenv.config()

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true })
  const port = process.env.PORT ? Number(process.env.PORT) : 4000
  app.enableCors({ origin: true, credentials: true })
  // 显式绑定到 0.0.0.0 以确保外部可访问（Railway 需要）
  await app.listen(port, '0.0.0.0')
  // eslint-disable-next-line no-console
  console.log(`API running on http://0.0.0.0:${port}`)
}

bootstrap()


