import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { dataSourceOptions } from '../data-source'
import * as fs from 'fs'
import * as path from 'path'

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

    const sqlFile = path.join(__dirname, 'add-is-public-to-venue.sql')
    const sql = fs.readFileSync(sqlFile, 'utf-8')
    
    console.log('📝 执行 SQL 迁移...')
    console.log('SQL:', sql)
    
    await ds.query(sql)
    
    console.log('✅ 迁移执行成功')
    
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

