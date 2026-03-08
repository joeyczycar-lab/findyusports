import { IsInt, IsString, IsOptional, IsDateString, MaxLength, MinLength } from 'class-validator'

export class CreateBookingDto {
  @IsInt()
  venueId!: number

  @IsDateString()
  bookingDate!: string // YYYY-MM-DD

  @IsString()
  @MinLength(1)
  @MaxLength(50)
  timeSlot!: string

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string
}
