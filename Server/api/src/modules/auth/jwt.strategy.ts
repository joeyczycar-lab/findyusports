import { Injectable, UnauthorizedException } from '@nestjs/common'
import { PassportStrategy } from '@nestjs/passport'
import { ExtractJwt, Strategy } from 'passport-jwt'
import { AuthService } from './auth.service'

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly authService: AuthService) {
    const jwtSecret = process.env.JWT_SECRET || 'default-jwt-secret'
    console.log('🔐 [JWT Strategy] Initializing with secret:', jwtSecret ? 'SET' : 'NOT SET')
    
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtSecret
    })
  }

  async validate(payload: any) {
    console.log('🔐 [JWT Strategy] Validating token payload:', {
      sub: payload.sub,
      phone: payload.phone,
      role: payload.role,
    })
    
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
