import { Injectable, ExecutionContext, UnauthorizedException } from '@nestjs/common'
import { AuthGuard } from '@nestjs/passport'
import { Reflector } from '@nestjs/core'

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super()
  }

  canActivate(context: ExecutionContext) {
    const isPublic = this.reflector.getAllAndOverride<boolean>('isPublic', [
      context.getHandler(),
      context.getClass(),
    ])
    
    if (isPublic) {
      return true
    }
    
    const request = context.switchToHttp().getRequest()
    const authHeader = request.headers?.authorization || request.headers?.Authorization
    console.log('🔐 [JWT Auth Guard] Checking authentication:', {
      isPublic,
      hasAuthHeader: !!authHeader,
      authHeaderPreview: authHeader ? authHeader.substring(0, 30) + '...' : 'none',
      url: request.url,
      method: request.method,
    })
    
    try {
      const result = super.canActivate(context)
      if (result instanceof Promise) {
        return result.catch((error: any) => {
          console.error('❌ [JWT Auth Guard] Authentication failed:', {
            message: error?.message,
            name: error?.name,
            statusCode: error?.statusCode,
            error: error?.error,
            stack: error?.stack?.substring(0, 500),
          })
          
          // 检查是否是 JWT 解析错误
          if (error?.message?.includes('jwt') || 
              error?.message?.includes('token') || 
              error?.message?.includes('malformed') ||
              error?.message?.includes('invalid') ||
              error?.name === 'JsonWebTokenError' ||
              error?.name === 'TokenExpiredError') {
            console.error('❌ [JWT Auth Guard] JWT parsing error:', {
              errorType: error?.constructor?.name,
              errorName: error?.name,
              message: error?.message,
            })
          }
          
          throw new UnauthorizedException(error?.message || '认证失败')
        })
      }
      return result
    } catch (error: any) {
      console.error('❌ [JWT Auth Guard] Authentication error:', {
        message: error?.message,
        name: error?.name,
        statusCode: error?.statusCode,
      })
      throw error instanceof UnauthorizedException ? error : new UnauthorizedException('认证失败')
    }
  }
}
