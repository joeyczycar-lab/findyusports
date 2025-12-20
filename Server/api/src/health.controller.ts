import { Controller, Get } from '@nestjs/common'

@Controller()
export class HealthController {
  @Get()
  health() {
    return { status: 'ok', service: 'sports-venues-api' }
  }

  @Get('health')
  healthCheck() {
    return { status: 'ok', service: 'sports-venues-api', timestamp: new Date().toISOString() }
  }
}
