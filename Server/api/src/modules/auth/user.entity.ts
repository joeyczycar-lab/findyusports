import { Column, Entity, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm'

@Entity('user')
export class UserEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Column({ type: 'varchar', length: 20, unique: true })
  phone!: string

  @Column({ type: 'varchar', length: 50, nullable: true })
  nickname?: string

  @Column({ type: 'varchar', length: 200, nullable: true })
  avatar?: string

  @Column({ type: 'varchar', length: 100 })
  password!: string

  @Column({ type: 'varchar', length: 20, default: 'user' })
  role!: string

  @Column({ type: 'varchar', length: 20, default: 'active' })
  status!: string

  @Column({ type: 'int', default: 0 })
  points!: number

  @Column({ type: 'boolean', default: false, name: 'is_vip' })
  isVip!: boolean

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt!: Date

  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt!: Date
}
