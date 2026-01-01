import { Module } from '@nestjs/common'
import { VenuesModule } from './venues/venues.module'
import { DbModule } from './db.module'
import { OssModule } from './oss/oss.module'
import { ImageModule } from './image/image.module'
import { AuthModule } from './auth/auth.module'
import { AnalyticsModule } from './analytics/analytics.module'
import { HealthController } from '../health.controller'

@Module({
  imports: [DbModule, VenuesModule, OssModule, ImageModule, AuthModule, AnalyticsModule],
  controllers: [HealthController],
})
export class AppModule {}


