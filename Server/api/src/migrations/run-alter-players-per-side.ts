import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { join } from 'path'

dotenv.config({ path: join(__dirname, '../../.env') })

// 使用与 data-source 相同的配置
function getOptions() {
  const dbUrl = process.env.DATABASE_URL
  const common = {
    type: 'postgres' as const,
    synchronize: false,
  }
  if (dbUrl) {
    const ssl = (process.env.DB_SSL || '').toLowerCase() === 'true' ? { rejectUnauthorized: false } : undefined
    return { ...common, url: dbUrl, ssl }
  }
  return {
    ...common,
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 5432),
    username: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASS || 'postgres',
    database: process.env.DB_NAME || 'venues',
  }
}

const sql = `
ALTER TABLE venue
  ALTER COLUMN players_per_side TYPE character varying(120);
`.trim()

async function run() {
  const ds = new DataSource(getOptions())
  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功')
    await ds.query(sql)
    console.log('✅ 迁移成功：players_per_side 已改为 varchar(120)')
  } catch (e) {
    console.error('❌ 执行失败:', e instanceof Error ? e.message : e)
    process.exit(1)
  } finally {
    await ds.destroy()
  }
}

run()
