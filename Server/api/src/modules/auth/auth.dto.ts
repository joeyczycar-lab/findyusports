import { IsString, IsNotEmpty, Length, Matches, IsOptional } from 'class-validator'

export class RegisterDto {
  @IsString()
  @IsNotEmpty()
  @Matches(/^1[3-9]\d{9}$/, { message: '请输入正确的手机号' })
  phone!: string

  @IsString()
  @IsNotEmpty()
  @Length(6, 20, { message: '密码长度6-20位' })
  password!: string

  @IsString()
  @Length(2, 20, { message: '昵称长度2-20位' })
  nickname?: string
}

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  phone!: string

  @IsString()
  @IsNotEmpty()
  password!: string
}

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @Length(2, 20, { message: '昵称长度2-20位' })
  nickname?: string

  @IsOptional()
  @IsString()
  avatar?: string
}

export class ChangePasswordDto {
  @IsString()
  @IsNotEmpty({ message: '请输入当前密码' })
  currentPassword!: string

  @IsString()
  @IsNotEmpty()
  @Length(6, 20, { message: '新密码长度6-20位' })
  newPassword!: string
}

export class ChangePhoneDto {
  @IsString()
  @IsNotEmpty()
  @Matches(/^1[3-9]\d{9}$/, { message: '请输入正确的手机号' })
  newPhone!: string

  @IsString()
  @IsNotEmpty({ message: '请输入当前密码以验证' })
  password!: string
}

export class AddPointsDto {
  @IsString()
  @IsNotEmpty()
  reason!: string // 例如 'venue_upload'
}
