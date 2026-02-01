import { Controller, Post, Body, Get, Put, UseInterceptors, UploadedFile, BadRequestException, UseGuards } from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import { AuthService } from './auth.service'
import { RegisterDto, LoginDto, UpdateProfileDto, ChangePasswordDto, ChangePhoneDto, AddPointsDto } from './auth.dto'
import { JwtAuthGuard } from './auth.guard'
import { CurrentUser } from './current-user.decorator'
import { Public } from './public.decorator'

@Controller('auth')
@UseGuards(JwtAuthGuard)
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

  @Put('change-password')
  async changePassword(@CurrentUser() user: any, @Body() dto: ChangePasswordDto) {
    return this.authService.changePassword(user.id, dto)
  }

  @Put('change-phone')
  async changePhone(@CurrentUser() user: any, @Body() dto: ChangePhoneDto) {
    return this.authService.changePhone(user.id, dto)
  }

  @Post('upload-avatar')
  @UseInterceptors(FileInterceptor('file'))
  async uploadAvatar(@CurrentUser() user: any, @UploadedFile() file: Express.Multer.File) {
    if (!file?.buffer) throw new BadRequestException('请选择图片文件')
    const mime = file.mimetype === 'image/png' ? 'image/png' : 'image/jpeg'
    return this.authService.uploadAvatar(user.id, file.buffer, mime)
  }

  @Post('points/add')
  async addPoints(@CurrentUser() user: any, @Body() dto: AddPointsDto) {
    return this.authService.addPoints(user.id, dto.reason)
  }
}
