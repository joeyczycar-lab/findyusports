import 'reflect-metadata'
import { NestFactory } from '@nestjs/core'
import { AppModule } from './modules/app.module'
import * as dotenv from 'dotenv'

dotenv.config()

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true })
  const port = process.env.PORT ? Number(process.env.PORT) : 4000
  app.enableCors({ origin: true, credentials: true })
  await app.listen(port)
  // eslint-disable-next-line no-console
  console.log(`API running on http://localhost:${port}`)
}

bootstrap()


