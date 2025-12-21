import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { dataSourceOptions } from './src/data-source'

dotenv.config()

async function installPostGIS() {
  console.log('🚀 开始安装 PostGIS 扩展...')
  
  const dataSource = new DataSource(dataSourceOptions)
  
  try {
    // 连接到数据库
    await dataSource.initialize()
    console.log('✅ 数据库连接成功')
    
    // 检查 PostGIS 是否已安装
    const checkResult = await dataSource.query(`
      SELECT EXISTS(
        SELECT 1 FROM pg_extension WHERE extname = 'postgis'
      ) as installed
    `)
    
    if (checkResult[0]?.installed === true) {
      console.log('✅ PostGIS 扩展已经安装')
      await dataSource.destroy()
      process.exit(0)
    }
    
    // 尝试安装 PostGIS
    console.log('📦 正在安装 PostGIS 扩展...')
    try {
      await dataSource.query(`CREATE EXTENSION IF NOT EXISTS postgis`)
      console.log('✅ PostGIS 扩展安装成功！')
    } catch (error: any) {
      if (error.message.includes('not available') || error.message.includes('No such file')) {
        console.error('❌ PostGIS 扩展不可用')
        console.error('   错误信息:', error.message)
        console.error('')
        console.error('   这可能是因为：')
        console.error('   1. Railway 的 PostgreSQL 服务没有安装 PostGIS 扩展文件')
        console.error('   2. 需要在 Railway 的数据库服务中手动启用 PostGIS')
        console.error('')
        console.error('   解决方案：')
        console.error('   1. 在 Railway Dashboard → Postgres 服务 → 设置')
        console.error('   2. 查找 PostGIS 相关配置或联系 Railway 支持')
        console.error('   3. 或者使用支持 PostGIS 的 PostgreSQL 服务')
        console.error('')
        console.error('   注意：应用可以在没有 PostGIS 的情况下正常运行')
        console.error('   （使用 fallback 的经纬度查询）')
      } else {
        console.error('❌ 安装 PostGIS 时出错:', error.message)
      }
      await dataSource.destroy()
      process.exit(1)
    }
    
    // 验证安装
    const verifyResult = await dataSource.query(`
      SELECT PostGIS_version() as version
    `)
    console.log('✅ PostGIS 版本:', verifyResult[0]?.version)
    
    await dataSource.destroy()
    console.log('✅ 完成！')
    process.exit(0)
  } catch (error) {
    console.error('❌ 连接数据库失败:', error)
    if (error instanceof Error) {
      console.error('错误信息:', error.message)
    }
    process.exit(1)
  }
}

installPostGIS().catch((error) => {
  console.error('❌ 未处理的错误:', error)
  process.exit(1)
})

