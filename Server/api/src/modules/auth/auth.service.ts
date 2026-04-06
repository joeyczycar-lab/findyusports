import { Injectable, UnauthorizedException, ConflictException, BadRequestException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { JwtService } from '@nestjs/jwt'
import * as bcrypt from 'bcrypt'
import { UserEntity } from './user.entity'
import { RegisterDto, LoginDto, UpdateProfileDto, ChangePasswordDto, ChangePhoneDto, ResetPasswordByCodeDto } from './auth.dto'
import { OssService } from '../oss/oss.service'

type PasswordResetCodeRecord = {
  code: string
  expiresAt: number
  lastSentAt: number
  attempts: number
}

@Injectable()
export class AuthService {
  private readonly passwordResetCodes = new Map<string, PasswordResetCodeRecord>()
  private readonly codeExpireMs = 10 * 60 * 1000 // 10分钟
  private readonly sendCooldownMs = 60 * 1000 // 60秒
  private readonly maxVerifyAttempts = 5

  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepo: Repository<UserEntity>,
    private readonly jwtService: JwtService,
    private readonly ossService: OssService
  ) {}

  async register(dto: RegisterDto) {
    const { phone, password, nickname } = dto

    // 检查手机号是否已存在
    const existingUser = await this.userRepo.findOne({ where: { phone } })
    if (existingUser) {
      throw new ConflictException('手机号已注册')
    }

    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10)

    // 创建用户
    const user = this.userRepo.create({
      phone,
      password: hashedPassword,
      nickname: nickname || `用户${phone.slice(-4)}`
    })

    const savedUser = await this.userRepo.save(user)

    // 生成JWT token
    const token = this.generateToken(savedUser)

    return {
      user: this.sanitizeUser(savedUser),
      token
    }
  }

  async login(dto: LoginDto) {
    const { phone, password } = dto

    try {
      // 查找用户（若数据库未连接会在此抛错）
      const user = await this.userRepo.findOne({ where: { phone } })
      if (!user) {
        throw new UnauthorizedException('手机号或密码错误')
      }

      // 验证密码
      const isPasswordValid = await bcrypt.compare(password, user.password)
      if (!isPasswordValid) {
        throw new UnauthorizedException('手机号或密码错误')
      }

      // 检查用户状态
      if (user.status !== 'active') {
        throw new UnauthorizedException('账户已被禁用')
      }

      // 生成JWT token
      const token = this.generateToken(user)

      return {
        user: this.sanitizeUser(user),
        token
      }
    } catch (err: any) {
      // 业务异常直接抛出，由 Nest 返回 401
      if (err instanceof UnauthorizedException) throw err
      // 未预期错误：打完整日志便于在 Railway 日志中排查 500
      console.error('❌ [AuthService] login 未预期错误:', err?.message ?? err)
      console.error('❌ [AuthService] 错误名:', err?.name)
      console.error('❌ [AuthService] 堆栈:', err?.stack)
      throw err
    }
  }

  async updateProfile(userId: number, dto: UpdateProfileDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } })
    if (!user) {
      throw new UnauthorizedException('用户不存在')
    }

    // 更新用户信息
    Object.assign(user, dto)
    const updatedUser = await this.userRepo.save(user)

    return this.sanitizeUser(updatedUser)
  }

  async findById(id: number) {
    const user = await this.userRepo.findOne({ where: { id } })
    return user ? this.sanitizeUser(user) : null
  }

  async changePassword(userId: number, dto: ChangePasswordDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } })
    if (!user) throw new UnauthorizedException('用户不存在')
    const valid = await bcrypt.compare(dto.currentPassword, user.password)
    if (!valid) throw new UnauthorizedException('当前密码错误')
    user.password = await bcrypt.hash(dto.newPassword, 10)
    await this.userRepo.save(user)
    return this.sanitizeUser(user)
  }

  async changePhone(userId: number, dto: ChangePhoneDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } })
    if (!user) throw new UnauthorizedException('用户不存在')
    const valid = await bcrypt.compare(dto.password, user.password)
    if (!valid) throw new UnauthorizedException('密码错误')
    const existing = await this.userRepo.findOne({ where: { phone: dto.newPhone } })
    if (existing && existing.id !== userId) throw new ConflictException('该手机号已被注册')
    user.phone = dto.newPhone
    await this.userRepo.save(user)
    return this.sanitizeUser(user)
  }

  async sendPasswordResetCode(phone: string) {
    const now = Date.now()
    const oldRecord = this.passwordResetCodes.get(phone)
    if (oldRecord && now - oldRecord.lastSentAt < this.sendCooldownMs) {
      const waitSec = Math.ceil((this.sendCooldownMs - (now - oldRecord.lastSentAt)) / 1000)
      throw new BadRequestException(`发送过于频繁，请 ${waitSec} 秒后再试`)
    }

    const user = await this.userRepo.findOne({ where: { phone } })
    if (!user) throw new BadRequestException('该手机号未注册')

    const code = Math.floor(100000 + Math.random() * 900000).toString()
    this.passwordResetCodes.set(phone, {
      code,
      expiresAt: now + this.codeExpireMs,
      lastSentAt: now,
      attempts: 0,
    })

    // 这里可接入真实短信服务（阿里云短信/腾讯云短信等）
    // 当前先保证流程可用：开发环境返回验证码，生产环境仅记录日志。
    console.log(`📨 [AuthService] Password reset code for ${phone}: ${code}`)

    const baseResp: any = {
      success: true,
      message: '验证码已发送，请注意查收',
      expiresInSeconds: Math.floor(this.codeExpireMs / 1000),
    }
    if (process.env.NODE_ENV !== 'production') {
      baseResp.debugCode = code
    }
    return baseResp
  }

  async resetPasswordByCode(dto: ResetPasswordByCodeDto) {
    const { phone, code, newPassword } = dto
    const now = Date.now()
    const record = this.passwordResetCodes.get(phone)
    if (!record) throw new BadRequestException('请先获取短信验证码')
    if (record.expiresAt < now) {
      this.passwordResetCodes.delete(phone)
      throw new BadRequestException('验证码已过期，请重新获取')
    }
    if (record.attempts >= this.maxVerifyAttempts) {
      this.passwordResetCodes.delete(phone)
      throw new BadRequestException('验证码尝试次数过多，请重新获取')
    }
    if (record.code !== code.trim()) {
      record.attempts += 1
      this.passwordResetCodes.set(phone, record)
      throw new BadRequestException('验证码错误')
    }

    const user = await this.userRepo.findOne({ where: { phone } })
    if (!user) throw new BadRequestException('该手机号未注册')

    user.password = await bcrypt.hash(newPassword, 10)
    await this.userRepo.save(user)
    this.passwordResetCodes.delete(phone)
    return { success: true, message: '密码重置成功，请使用新密码登录' }
  }

  async addPoints(userId: number, reason: string) {
    if (reason !== 'venue_upload') throw new BadRequestException('无效的积分原因')
    const user = await this.userRepo.findOne({ where: { id: userId } })
    if (!user) throw new UnauthorizedException('用户不存在')
    user.points = (user.points ?? 0) + 1
    await this.userRepo.save(user)
    return this.sanitizeUser(user)
  }

  async uploadAvatar(userId: number, buffer: Buffer, mimeType: string) {
    const user = await this.userRepo.findOne({ where: { id: userId } })
    if (!user) throw new UnauthorizedException('用户不存在')
    const ext = mimeType === 'image/png' ? 'png' : 'jpg'
    const key = `avatar/${userId}-${Date.now()}.${ext}`
    const { uploadUrl, publicUrl } = await this.ossService.generatePresignedUrl(mimeType, ext, key)
    const body = new Uint8Array(buffer)
    const res = await fetch(uploadUrl, {
      method: 'PUT',
      headers: { 'Content-Type': mimeType },
      body,
    })
    if (!res.ok) throw new BadRequestException('头像上传失败')
    user.avatar = publicUrl
    await this.userRepo.save(user)
    return this.sanitizeUser(user)
  }

  private generateToken(user: UserEntity) {
    const payload = { 
      sub: user.id, 
      phone: user.phone, 
      role: user.role 
    }
    return this.jwtService.sign(payload)
  }

  /** 根据积分计算 VIP 等级：VIP1=20, VIP2=50, VIP3=100, VIP4=200, VIP5=500 */
  private getVipLevelFromPoints(points: number): number {
    if (points >= 500) return 5
    if (points >= 200) return 4
    if (points >= 100) return 3
    if (points >= 50) return 2
    if (points >= 20) return 1
    return 0
  }

  private sanitizeUser(user: UserEntity) {
    const { password, ...sanitized } = user
    const points = sanitized.points ?? 0
    const vipLevel = this.getVipLevelFromPoints(points)
    return {
      id: sanitized.id,
      phone: sanitized.phone,
      nickname: sanitized.nickname,
      avatar: sanitized.avatar,
      role: sanitized.role,
      status: sanitized.status,
      points,
      vipLevel,
      isVip: vipLevel >= 1,
      createdAt: sanitized.createdAt,
      updatedAt: sanitized.updatedAt,
    }
  }
}
