import { Controller, Get, Res, Header } from '@nestjs/common'
import { Response } from 'express'

@Controller()
export class HealthController {
  @Get()
  @Header('Content-Type', 'application/json')
  @Header('Cache-Control', 'no-cache')
  health(@Res() res: Response) {
    // Return 200 status immediately with minimal JSON response
    // This is critical for Railway health checks
    res.status(200).json({ 
      status: 'ok', 
      service: 'sports-venues-api',
      timestamp: new Date().toISOString()
    })
  }

  @Get('health')
  @Header('Content-Type', 'application/json')
  @Header('Cache-Control', 'no-cache')
  healthCheck(@Res() res: Response) {
    // Return 200 status immediately with minimal JSON response
    // This is critical for Railway health checks
    res.status(200).json({ 
      status: 'ok', 
      service: 'sports-venues-api', 
      timestamp: new Date().toISOString() 
    })
  }
}
