/**
 * 在 user 表上添加 points、is_vip 列（若尚未存在）。
 * 用法：在项目根目录执行，需能连上目标数据库（如 Railway）。
 *
 * 本地连 Railway：先设置 DATABASE_URL 和 DB_SSL=true，再执行：
 *   npx ts-node -r tsconfig-paths/register src/migrations/run-add-user-points-vip.ts
 *
 * 或在 Railway 控制台 → PostgreSQL → Query 里直接执行 add-user-points-vip.sql 内容。
 */
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { readFileSync } from 'fs'
import { join } from 'path'
import { dataSourceOptions } from '../data-source'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: ['query', 'error'],
})

async function runMigration() {
  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功\n')

    const sqlFile = join(__dirname, 'add-user-points-vip.sql')
    const sql = readFileSync(sqlFile, 'utf-8')

    console.log('📝 执行 SQL 迁移（user 表添加 points、is_vip）...')
    console.log('SQL:', sql)

    await ds.query(sql)

    console.log('✅ 迁移执行成功：user 表已包含 points、is_vip 列')

    await ds.destroy()
    console.log('\n✅ 操作完成')
  } catch (error) {
    console.error('❌ 错误:', error)
    if (error instanceof Error) {
      console.error('错误信息:', error.message)
      console.error('错误堆栈:', error.stack)
    }
    process.exit(1)
  }
}

runMigration()
