import { Controller, Get, Res } from '@nestjs/common'
import { Response } from 'express'

@Controller()
export class HealthController {
  @Get()
  health(@Res() res: Response) {
    // Return 200 status with JSON response
    return res.status(200).json({ 
      status: 'ok', 
      service: 'sports-venues-api',
      timestamp: new Date().toISOString()
    })
  }

  @Get('health')
  healthCheck(@Res() res: Response) {
    // Return 200 status with JSON response
    return res.status(200).json({ 
      status: 'ok', 
      service: 'sports-venues-api', 
      timestamp: new Date().toISOString() 
    })
  }
}
