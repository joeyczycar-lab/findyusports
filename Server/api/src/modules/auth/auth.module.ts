import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { JwtModule } from '@nestjs/jwt'
import { PassportModule } from '@nestjs/passport'
import { AuthService } from './auth.service'
import { AuthController } from './auth.controller'
import { UserEntity } from './user.entity'
import { JwtStrategy } from './jwt.strategy'

@Module({
  imports: [
    TypeOrmModule.forFeature([UserEntity]),
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'default-jwt-secret',
      signOptions: { expiresIn: '7d' }
    }),
    // 添加日志以确认 JWT_SECRET 配置
    {
      provide: 'JWT_SECRET_CHECK',
      useFactory: () => {
        const secret = process.env.JWT_SECRET || 'default-jwt-secret'
        console.log('🔐 [Auth Module] JWT_SECRET configured:', secret ? 'SET (length: ' + secret.length + ')' : 'NOT SET')
        console.log('🔐 [Auth Module] JWT_SECRET preview:', secret ? secret.substring(0, 20) + '...' : 'NOT SET')
        return secret
      }
    }
  ],
  providers: [AuthService, JwtStrategy],
  controllers: [AuthController],
  exports: [AuthService]
})
export class AuthModule {}
