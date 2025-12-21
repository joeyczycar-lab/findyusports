import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common'
import { Response } from 'express'

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp()
    const response = ctx.getResponse<Response>()
    
    let status = HttpStatus.INTERNAL_SERVER_ERROR
    let message = '服务器内部错误'
    let errors: any = null

    if (exception instanceof HttpException) {
      status = exception.getStatus()
      const exceptionResponse = exception.getResponse()
      
      if (typeof exceptionResponse === 'string') {
        message = exceptionResponse
      } else if (typeof exceptionResponse === 'object') {
        const responseObj = exceptionResponse as any
        message = responseObj.message || exception.message || '请求失败'
        
        // 处理验证错误
        if (Array.isArray(responseObj.message)) {
          errors = responseObj.message
          message = '验证失败'
        } else if (responseObj.message) {
          message = responseObj.message
        }
      }
    } else if (exception instanceof Error) {
      message = exception.message
    }

    response.status(status).json({
      status: 'error',
      code: status,
      message,
      ...(errors && { errors }),
      timestamp: new Date().toISOString(),
    })
  }
}

