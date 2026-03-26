import { DataSource } from 'typeorm'
import * as dotenv from 'dotenv'

dotenv.config()

async function runMigration() {
  const dataSource = new DataSource({
    type: 'postgres',
    url: process.env.DATABASE_URL,
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  })

  try {
    await dataSource.initialize()
    console.log('✅ 数据库连接成功')

    await dataSource.query(`
      ALTER TABLE venue
      ADD COLUMN IF NOT EXISTS approval_status varchar(20) DEFAULT 'approved';
    `)

    await dataSource.query(`
      UPDATE venue
      SET approval_status = 'approved'
      WHERE approval_status IS NULL;
    `)

    await dataSource.query(`
      CREATE INDEX IF NOT EXISTS idx_venue_approval_status ON venue (approval_status);
    `)

    console.log('✅ 迁移执行成功：已添加 approval_status 审核字段')
    await dataSource.destroy()
  } catch (error) {
    console.error('❌ 迁移失败:', error)
    process.exit(1)
  }
}

runMigration()
