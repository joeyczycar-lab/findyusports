import { Module } from '@nestjs/common'
import { VenuesModule } from './venues/venues.module'
import { DbModule } from './db.module'
import { OssModule } from './oss/oss.module'
import { ImageModule } from './image/image.module'
import { AuthModule } from './auth/auth.module'
import { HealthController } from '../health.controller'

@Module({
  imports: [DbModule, VenuesModule, OssModule, ImageModule, AuthModule],
  controllers: [HealthController],
})
export class AppModule {}


