import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { JwtModule } from '@nestjs/jwt'
import { PassportModule } from '@nestjs/passport'
import { AuthService } from './auth.service'
import { AuthController } from './auth.controller'
import { UserEntity } from './user.entity'
import { JwtStrategy } from './jwt.strategy'
import { OssModule } from '../oss/oss.module'

@Module({
  imports: [
    TypeOrmModule.forFeature([UserEntity]),
    PassportModule,
    OssModule,
    JwtModule.registerAsync({
      useFactory: () => {
        const secret = process.env.JWT_SECRET || 'default-jwt-secret'
        console.log('🔐 [Auth Module] JWT_SECRET configured:', secret ? 'SET (length: ' + secret.length + ')' : 'NOT SET')
        console.log('🔐 [Auth Module] JWT_SECRET preview:', secret ? secret.substring(0, 20) + '...' : 'NOT SET')
        if (!secret || secret === 'default-jwt-secret') {
          console.error('⚠️ [Auth Module] WARNING: Using default JWT_SECRET! This is insecure!')
        }
        return {
          secret,
          signOptions: { expiresIn: '7d' }
        }
      }
    })
  ],
  providers: [AuthService, JwtStrategy],
  controllers: [AuthController],
  exports: [AuthService]
})
export class AuthModule {}
