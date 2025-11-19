import { IsString, IsNotEmpty, Length, Matches } from 'class-validator'

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
  @IsString()
  @Length(2, 20, { message: '昵称长度2-20位' })
  nickname?: string

  @IsString()
  avatar?: string
}
