import { Column, Entity, Index, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm'

@Entity('booking')
export class BookingEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Index()
  @Column({ type: 'int', name: 'venue_id' })
  venueId!: number

  @Index()
  @Column({ type: 'int', name: 'user_id' })
  userId!: number

  @Column({ type: 'date', name: 'booking_date' })
  bookingDate!: string // YYYY-MM-DD

  @Column({ type: 'varchar', length: 50, name: 'time_slot' })
  timeSlot!: string // e.g. "09:00-11:00", "14:00-16:00"

  @Column({ type: 'varchar', length: 500, nullable: true })
  note?: string

  @Column({ type: 'varchar', length: 20, default: 'pending' })
  status!: string // pending | confirmed | cancelled

  @CreateDateColumn({ type: 'timestamptz', name: 'created_at' })
  createdAt!: Date
}
