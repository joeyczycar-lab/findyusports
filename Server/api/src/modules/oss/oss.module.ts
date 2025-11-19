import { Module } from '@nestjs/common'
import { OssService } from './oss.service'
import { HotlinkProtectionService } from './hotlink-protection.service'

@Module({
  providers: [OssService, HotlinkProtectionService],
  exports: [OssService, HotlinkProtectionService],
})
export class OssModule {}
