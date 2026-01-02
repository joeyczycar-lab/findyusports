import { Injectable, ExecutionContext } from '@nestjs/common'
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
    })
    
    return super.canActivate(context)
  }
}
