import { Module } from '@nestjs/common'
import { VenuesController } from './venues.controller'
import { VenuesService } from './venues.service'
import { TypeOrmModule } from '@nestjs/typeorm'
import { VenueEntity } from './venue.entity'
import { ReviewEntity } from './review.entity'
import { VenueImageEntity } from './image.entity'
import { OssModule } from '../oss/oss.module'
import { ImageModule } from '../image/image.module'
import { AuthModule } from '../auth/auth.module'

@Module({
  imports: [TypeOrmModule.forFeature([VenueEntity, ReviewEntity, VenueImageEntity]), OssModule, ImageModule, AuthModule],
  controllers: [VenuesController],
  providers: [VenuesService],
})
export class VenuesModule {}


