import { readFileSync } from 'fs'
import { join } from 'path'
import { DataSource } from 'typeorm'

async function runMigration() {
  const dataSource = new DataSource({
    type: 'postgres',
    url: process.env.DATABASE_URL,
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  })

  try {
    await dataSource.initialize()
    console.log('✅ 数据库连接成功')

    const sql = readFileSync(
      join(__dirname, 'add-court-count-to-venue.sql'),
      'utf-8'
    )

    await dataSource.query(sql)
    console.log('✅ 迁移执行成功：添加 court_count 字段')

    await dataSource.destroy()
  } catch (error) {
    console.error('❌ 迁移失败:', error)
    process.exit(1)
  }
}

runMigration()

