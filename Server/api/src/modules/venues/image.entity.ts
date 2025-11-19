import { Column, Entity, Index, ManyToOne, PrimaryGeneratedColumn } from 'typeorm'
import { VenueEntity } from './venue.entity'
import { UserEntity } from '../auth/user.entity'

@Entity('venue_image')
export class VenueImageEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Index()
  @ManyToOne(() => VenueEntity, { onDelete: 'CASCADE' })
  venue!: VenueEntity

  @Column({ type: 'int' })
  userId!: number

  @Column({ type: 'text' })
  url!: string

  @Column({ type: 'int', default: 0 })
  sort!: number

  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE' })
  user!: UserEntity
}


