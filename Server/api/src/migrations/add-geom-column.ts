import { DataSource } from 'typeorm'
import { dataSourceOptions } from '../data-source'
import * as dotenv from 'dotenv'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: true,
})

async function addGeomColumn() {
  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功\n')

    // 检查 PostGIS 扩展是否已安装
    console.log('📦 检查 PostGIS 扩展...')
    const extensionCheck = await ds.query(`
      SELECT EXISTS(
        SELECT 1 FROM pg_extension WHERE extname = 'postgis'
      ) as exists
    `)
    
    const hasPostGIS = extensionCheck[0]?.exists === true
    
    if (!hasPostGIS) {
      console.log('📦 尝试安装 PostGIS 扩展...')
      try {
        await ds.query('CREATE EXTENSION IF NOT EXISTS postgis')
        console.log('✅ PostGIS 扩展已安装\n')
      } catch (e: any) {
        if (e?.message?.includes('is not available') || e?.message?.includes('postgis')) {
          console.warn('⚠️  PostGIS 未安装或不可用，跳过 geom 列添加。')
          console.warn('   应用将使用 lng/lat 字段，功能不受影响。若需空间索引，请在数据库服务器上安装 PostGIS 后重试。\n')
          await ds.destroy()
          return
        }
        throw e
      }
    } else {
      console.log('✅ PostGIS 扩展已存在\n')
    }

    // 检查 geom 列是否已存在
    console.log('🔍 检查 geom 列...')
    const columnCheck = await ds.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'venue' AND column_name = 'geom'
    `)
    
    if (columnCheck && columnCheck.length > 0) {
      console.log('✅ geom 列已存在，无需添加\n')
      await ds.destroy()
      return
    }

    // 添加 geom 列
    console.log('➕ 添加 geom 列...')
    await ds.query(`
      ALTER TABLE venue 
      ADD COLUMN IF NOT EXISTS geom geometry(Point, 4326)
    `)
    console.log('✅ geom 列已添加\n')

    // 创建空间索引
    console.log('📊 创建空间索引...')
    try {
      await ds.query(`
        CREATE INDEX IF NOT EXISTS idx_venue_geom 
        ON venue USING GIST (geom)
      `)
      console.log('✅ 空间索引已创建\n')
    } catch (indexError: any) {
      if (indexError.message?.includes('already exists')) {
        console.log('✅ 空间索引已存在\n')
      } else {
        console.warn('⚠️  创建空间索引失败:', indexError.message)
      }
    }

    // 为现有数据填充 geom 列（如果有 lng 和 lat）
    console.log('🔄 为现有数据填充 geom 列...')
    const updateResult = await ds.query(`
      UPDATE venue 
      SET geom = ST_SetSRID(ST_MakePoint(lng, lat), 4326)
      WHERE geom IS NULL AND lng IS NOT NULL AND lat IS NOT NULL
    `)
    console.log(`✅ 已更新 ${updateResult[1] || 0} 条记录的 geom 列\n`)

    await ds.destroy()
    console.log('✅ 迁移完成！')
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

addGeomColumn()
