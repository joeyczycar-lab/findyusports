import { Column, Entity, Index, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm'

@Entity('page_view')
export class PageViewEntity {
  @PrimaryGeneratedColumn('increment')
  id!: number

  @Index()
  @Column({ type: 'varchar', length: 200 })
  path!: string // 页面路径，如 /map, /venues/1

  @Column({ type: 'varchar', length: 50, nullable: true, name: 'page_type' })
  pageType?: string // 页面类型，如 'home', 'map', 'venue', 'admin'

  @Column({ type: 'varchar', length: 200, nullable: true, name: 'referer' })
  referer?: string // 来源页面

  @Column({ type: 'varchar', length: 500, nullable: true, name: 'user_agent' })
  userAgent?: string // 用户代理

  @Column({ type: 'varchar', length: 45, nullable: true, name: 'ip' })
  ip?: string // IP 地址

  @Column({ type: 'varchar', length: 50, nullable: true, name: 'user_id' })
  userId?: string // 用户 ID（如果已登录）

  @CreateDateColumn({ type: 'timestamptz', name: 'created_at' })
  createdAt!: Date
}

