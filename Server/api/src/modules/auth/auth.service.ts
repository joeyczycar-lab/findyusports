import { Injectable, UnauthorizedException, ConflictException, BadRequestException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { JwtService } from '@nestjs/jwt'
import * as bcrypt from 'bcrypt'
import { UserEntity } from './user.entity'
import { RegisterDto, LoginDto, UpdateProfileDto, ChangePasswordDto, ChangePhoneDto } from './auth.dto'
import { OssService } from '../oss/oss.service'

@Injectable()
export class AuthService {
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

    // 查找用户
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
