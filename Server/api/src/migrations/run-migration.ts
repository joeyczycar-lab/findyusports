import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { dataSourceOptions } from '../data-source'
import * as fs from 'fs'
import * as path from 'path'

dotenv.config()

async function runMigration() {
  const ds = new DataSource({
    ...dataSourceOptions,
    synchronize: false,
    logging: true,
  })

  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功\n')

    const migrationFile = path.join(__dirname, 'create-page-view-table.sql')
    const sql = fs.readFileSync(migrationFile, 'utf-8')
    
    console.log('📄 执行 SQL 迁移脚本...')
    console.log('SQL 内容:')
    console.log(sql)
    console.log('\n')

    // 执行 SQL
    await ds.query(sql)
    
    console.log('✅ 迁移成功完成！')
    console.log('✅ page_view 表已创建')
    
    // 验证表是否存在
    const result = await ds.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_name = 'page_view'
    `)
    
    if (result.length > 0) {
      console.log('✅ 验证成功: page_view 表存在')
    } else {
      console.warn('⚠️  警告: 无法验证表是否存在')
    }

    await ds.destroy()
    console.log('\n✅ 操作完成')
  } catch (error) {
    console.error('❌ 错误:', error)
    if (error instanceof Error) {
      console.error('错误信息:', error.message)
      console.error('错误堆栈:', error.stack)
    }
    await ds.destroy()
    process.exit(1)
  }
}

runMigration()


