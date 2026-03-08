import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { BookingEntity } from './booking.entity'
import { CreateBookingDto } from './bookings.dto'

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(BookingEntity)
    private readonly bookingRepo: Repository<BookingEntity>,
  ) {}

  async create(userId: number, dto: CreateBookingDto) {
    const booking = this.bookingRepo.create({
      venueId: dto.venueId,
      userId,
      bookingDate: dto.bookingDate,
      timeSlot: dto.timeSlot,
      note: dto.note?.trim() || undefined,
      status: 'pending',
    })
    await this.bookingRepo.save(booking)
    return { id: booking.id, ...booking }
  }

  async findByUser(userId: number) {
    const qb = this.bookingRepo
      .createQueryBuilder('b')
      .leftJoin('venue', 'v', 'v.id = b.venue_id')
      .addSelect('v.name', 'venueName')
      .where('b.user_id = :userId', { userId })
      .orderBy('b.booking_date', 'DESC')
      .addOrderBy('b.created_at', 'DESC')
    const { entities, raw } = await qb.getRawAndEntities()
    const items = entities.map((e, i) => ({ ...e, venueName: (raw[i] as any)?.venueName ?? '' }))
    return { items }
  }
}
