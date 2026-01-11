import { Injectable, UnauthorizedException } from '@nestjs/common'
import { PassportStrategy } from '@nestjs/passport'
import { ExtractJwt, Strategy } from 'passport-jwt'
import { AuthService } from './auth.service'

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly authService: AuthService) {
    const jwtSecret = process.env.JWT_SECRET || 'default-jwt-secret'
    console.log('🔐 [JWT Strategy] Initializing with secret:', jwtSecret ? 'SET (length: ' + jwtSecret.length + ')' : 'NOT SET')
    
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtSecret,
    })
  }

  async validate(payload: any) {
    if (!payload) {
      console.error('❌ [JWT Strategy] No payload received')
      throw new UnauthorizedException('无效的 token')
    }
    
    console.log('🔐 [JWT Strategy] Validating token payload:', {
      sub: payload.sub,
      phone: payload.phone,
      role: payload.role,
      exp: payload.exp,
      iat: payload.iat,
      expTime: payload.exp ? new Date(payload.exp * 1000).toISOString() : null,
      iatTime: payload.iat ? new Date(payload.iat * 1000).toISOString() : null,
      isExpired: payload.exp ? Date.now() / 1000 > payload.exp : null,
    })
    
    if (!payload.sub) {
      console.error('❌ [JWT Strategy] Missing user ID in payload')
      throw new UnauthorizedException('无效的 token payload')
    }
    
    const user = await this.authService.findById(payload.sub)
    if (!user) {
      console.error('❌ [JWT Strategy] User not found for ID:', payload.sub)
      throw new UnauthorizedException('用户不存在')
    }
    
    console.log('✅ [JWT Strategy] User validated:', {
      id: user.id,
      phone: user.phone,
      role: user.role,
    })
    
    return user
  }
}
