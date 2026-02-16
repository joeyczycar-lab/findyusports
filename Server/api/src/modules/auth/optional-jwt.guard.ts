import { Injectable, ExecutionContext } from '@nestjs/common'
import { AuthGuard } from '@nestjs/passport'

/**
 * 可选 JWT：有 token 则解析并设置 request.user，无 token 或无效则 request.user 为 undefined，不拒绝请求。
 * 用于如 POST /venues：未登录可提交，登录则记录创建者。
 */
@Injectable()
export class OptionalJwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    const request = context.switchToHttp().getRequest()
    const authHeader =
      request.headers?.authorization ||
      request.headers?.Authorization ||
      request.headers?.['x-auth-token'] ||
      request.headers?.['X-Auth-Token']
    if (!authHeader) {
      request.user = undefined
      return true
    }
    if (!request.headers['authorization'] && authHeader && !authHeader.startsWith('Bearer ')) {
      request.headers['authorization'] = `Bearer ${authHeader}`
    }
    return super.canActivate(context)
  }

  handleRequest<TUser>(err: any, user: TUser): TUser | undefined {
    if (err || !user) return undefined
    return user
  }
}
