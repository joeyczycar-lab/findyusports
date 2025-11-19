import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { JwtService } from '@nestjs/jwt'
import * as bcrypt from 'bcrypt'
import { UserEntity } from './user.entity'
import { RegisterDto, LoginDto, UpdateProfileDto } from './auth.dto'

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepo: Repository<UserEntity>,
    private readonly jwtService: JwtService
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

  private generateToken(user: UserEntity) {
    const payload = { 
      sub: user.id, 
      phone: user.phone, 
      role: user.role 
    }
    return this.jwtService.sign(payload)
  }

  private sanitizeUser(user: UserEntity) {
    const { password, ...sanitized } = user
    return sanitized
  }
}
