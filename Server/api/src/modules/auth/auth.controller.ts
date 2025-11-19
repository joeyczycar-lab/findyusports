import { Controller, Post, Body, Get, UseGuards, Put } from '@nestjs/common'
import { AuthService } from './auth.service'
import { RegisterDto, LoginDto, UpdateProfileDto } from './auth.dto'
import { JwtAuthGuard } from './auth.guard'
import { CurrentUser } from './current-user.decorator'
import { Public } from './public.decorator'

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('register')
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto)
  }

  @Public()
  @Post('login')
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto)
  }

  @Get('profile')
  async getProfile(@CurrentUser() user: any) {
    return { user }
  }

  @Put('profile')
  async updateProfile(@CurrentUser() user: any, @Body() dto: UpdateProfileDto) {
    return this.authService.updateProfile(user.id, dto)
  }
}
