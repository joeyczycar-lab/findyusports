import { Controller, Post, Body, Get, UseGuards } from '@nestjs/common'
import { BookingsService } from './bookings.service'
import { CreateBookingDto } from './bookings.dto'
import { JwtAuthGuard } from '../auth/auth.guard'
import { CurrentUser } from '../auth/current-user.decorator'

@Controller('bookings')
@UseGuards(JwtAuthGuard)
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post()
  async create(@CurrentUser() user: { id: number }, @Body() dto: CreateBookingDto) {
    return this.bookingsService.create(user.id, dto)
  }

  @Get()
  async list(@CurrentUser() user: { id: number }) {
    return this.bookingsService.findByUser(user.id)
  }
}
