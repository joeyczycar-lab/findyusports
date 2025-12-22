import { Controller, Get, Res, Header } from '@nestjs/common'
import { Response } from 'express'

@Controller()
export class HealthController {
  @Get()
  @Header('Content-Type', 'application/json')
  @Header('Cache-Control', 'no-cache, no-store, must-revalidate')
  @Header('Pragma', 'no-cache')
  @Header('Expires', '0')
  health(@Res() res: Response) {
    // Return 200 status immediately with minimal JSON response
    // This is critical for Railway health checks
    // Use res.end() to ensure immediate response without waiting
    res.status(200)
    res.setHeader('Content-Type', 'application/json')
    res.end(JSON.stringify({ 
      status: 'ok', 
      service: 'sports-venues-api',
      timestamp: new Date().toISOString()
    }))
  }

  @Get('health')
  @Header('Content-Type', 'application/json')
  @Header('Cache-Control', 'no-cache, no-store, must-revalidate')
  @Header('Pragma', 'no-cache')
  @Header('Expires', '0')
  healthCheck(@Res() res: Response) {
    // Return 200 status immediately with minimal JSON response
    // This is critical for Railway health checks
    // Use res.end() to ensure immediate response without waiting
    res.status(200)
    res.setHeader('Content-Type', 'application/json')
    res.end(JSON.stringify({ 
      status: 'ok', 
      service: 'sports-venues-api', 
      timestamp: new Date().toISOString() 
    }))
  }
}
