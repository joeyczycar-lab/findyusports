import { Column, CreateDateColumn, Entity, Index, ManyToOne, PrimaryGeneratedColumn } from 'typeorm'
import { VenueEntity } from './venue.entity'
import { UserEntity } from '../auth/user.entity'

@Entity('review')
export class ReviewEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Index()
  @ManyToOne(() => VenueEntity, { onDelete: 'CASCADE' })
  venue!: VenueEntity

  @Column({ type: 'int' })
  userId!: number

  @Column({ type: 'int' })
  rating!: number // 1-5

  @Column({ type: 'text' })
  content!: string

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt!: Date

  @ManyToOne(() => UserEntity, { onDelete: 'CASCADE' })
  user!: UserEntity
}


