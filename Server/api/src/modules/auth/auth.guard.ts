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
    // 检查所有可能的header名称（不区分大小写）
    const authHeader = request.headers?.authorization || 
                       request.headers?.Authorization ||
                       request.headers?.['authorization'] ||
                       request.headers?.['Authorization']
    console.log('🔐 [JWT Auth Guard] Checking authentication:', {
      isPublic,
      hasAuthHeader: !!authHeader,
      authHeaderPreview: authHeader ? authHeader.substring(0, 30) + '...' : 'none',
      url: request.url,
      method: request.method,
      allHeaderKeys: Object.keys(request.headers || {}),
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
            errorCode: error?.code,
            errorType: error?.constructor?.name,
            fullError: JSON.stringify(error, Object.getOwnPropertyNames(error)),
            stack: error?.stack?.substring(0, 1000),
          })
          
          // 检查是否是 JWT 解析错误
          // 从堆栈中提取原始错误信息
          const stackStr = error?.stack || ''
          const fullErrorStr = error?.fullError || JSON.stringify(error)
          
          // 尝试从堆栈中提取 jsonwebtoken 的错误
          const isJWTError = stackStr.includes('jsonwebtoken') || stackStr.includes('JsonWebTokenError') || 
              error?.message?.includes('jwt') || 
              error?.message?.includes('token') || 
              error?.message?.includes('malformed') ||
              error?.message?.includes('invalid') ||
              error?.message?.includes('signature') ||
              error?.name === 'JsonWebTokenError' ||
              error?.name === 'TokenExpiredError' ||
              error?.name === 'NotBeforeError'
          
          if (isJWTError) {
            // 尝试从 token 中提取信息
            let tokenInfo = null
            try {
              const token = authHeader?.replace('Bearer ', '') || ''
              if (token) {
                const parts = token.split('.')
                if (parts.length === 3) {
                  const payload = JSON.parse(Buffer.from(parts[1], 'base64').toString())
                  tokenInfo = {
                    userId: payload.sub,
                    phone: payload.phone,
                    role: payload.role,
                    issuedAt: payload.iat ? new Date(payload.iat * 1000).toISOString() : null,
                    expiresAt: payload.exp ? new Date(payload.exp * 1000).toISOString() : null,
                    isExpired: payload.exp ? Date.now() / 1000 > payload.exp : null,
                  }
                }
              }
            } catch (e) {
              // 忽略解析错误
            }
            
            console.error('❌ [JWT Auth Guard] JWT parsing error:', {
              errorType: error?.constructor?.name,
              errorName: error?.name,
              message: error?.message,
              code: error?.code,
              stackContainsJWT: stackStr.includes('jsonwebtoken'),
              tokenInfo: tokenInfo,
              currentJWTSecretLength: process.env.JWT_SECRET?.length || 0,
              fullError: fullErrorStr.substring(0, 500),
            })
            console.error('💡 [JWT Auth Guard] 建议：请重新登录以获取新的 token')
            if (tokenInfo?.isExpired) {
              console.error('⚠️ [JWT Auth Guard] Token 已过期')
            } else if (tokenInfo?.issuedAt) {
              console.error('⚠️ [JWT Auth Guard] Token 签发时间:', tokenInfo.issuedAt)
            }
          }
          
          throw new UnauthorizedException(error?.message || '认证失败')
        })
      }
      return result
    } catch (error: any) {
      console.error('❌ [JWT Auth Guard] Authentication error (sync):', {
        message: error?.message,
        name: error?.name,
        statusCode: error?.statusCode,
        errorType: error?.constructor?.name,
      })
      throw error instanceof UnauthorizedException ? error : new UnauthorizedException('认证失败')
    }
  }
}
