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
        return result.catch((error) => {
          console.error('❌ [JWT Auth Guard] Authentication failed:', {
            message: error.message,
            name: error.name,
            stack: error.stack?.substring(0, 500),
          })
          // 如果是 JWT 相关错误，提供更详细的错误信息
          if (error.message?.includes('jwt') || error.message?.includes('token')) {
            console.error('❌ [JWT Auth Guard] JWT Error details:', {
              errorType: error.constructor.name,
              message: error.message,
            })
          }
          throw new UnauthorizedException(error.message || '认证失败')
        })
      }
      return result
    } catch (error) {
      console.error('❌ [JWT Auth Guard] Authentication error:', {
        message: error instanceof Error ? error.message : String(error),
        name: error instanceof Error ? error.name : 'Unknown',
      })
      throw error instanceof UnauthorizedException ? error : new UnauthorizedException('认证失败')
    }
  }
}
