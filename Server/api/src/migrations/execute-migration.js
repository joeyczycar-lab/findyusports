#!/usr/bin/env node

/**
 * 自动执行数据库迁移脚本
 * 使用方法：
 * 1. 确保已安装依赖：npm install pg
 * 2. 设置环境变量或修改下面的连接信息
 * 3. 运行：node execute-migration.js
 */

const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

// 从环境变量读取数据库连接信息
// 优先使用 DATABASE_URL（Railway 格式）
let clientConfig;
if (process.env.DATABASE_URL) {
  // Railway 使用 DATABASE_URL 格式：postgresql://user:password@host:port/database
  clientConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }, // Railway 需要 SSL
  };
} else {
  // 使用单独的连接参数
  clientConfig = {
    host: process.env.DB_HOST || process.env.PGHOST,
    port: process.env.DB_PORT || process.env.PGPORT || 5432,
    database: process.env.DB_NAME || process.env.PGDATABASE,
    user: process.env.DB_USER || process.env.PGUSER,
    password: process.env.DB_PASSWORD || process.env.PGPASSWORD,
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  };
}

const client = new Client(clientConfig);

async function executeMigration() {
  try {
    console.log('🔌 正在连接到数据库...');
    await client.connect();
    console.log('✅ 已成功连接到数据库');

    // 读取 SQL 脚本
    const sqlPath = path.join(__dirname, 'add-all-missing-columns.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    console.log('📝 正在执行 SQL 脚本...');
    
    // 执行 SQL（分割成多个语句）
    const statements = sql
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0 && !s.startsWith('--'));

    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      if (statement.trim()) {
        try {
          await client.query(statement + ';');
          console.log(`✅ 执行语句 ${i + 1}/${statements.length} 成功`);
        } catch (error) {
          // 如果是列已存在的错误，忽略
          if (error.message.includes('already exists') || error.message.includes('duplicate')) {
            console.log(`⚠️  语句 ${i + 1}：列已存在，跳过`);
          } else {
            console.error(`❌ 语句 ${i + 1} 执行失败:`, error.message);
            throw error;
          }
        }
      }
    }

    console.log('✅ SQL 脚本执行完成！');

    // 验证结果
    console.log('\n🔍 验证已添加的列...');
    const verifyResult = await client.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'venue' 
      AND column_name IN (
        'court_count', 'floor_type', 'open_hours',
        'has_lighting', 'has_air_conditioning', 'has_parking',
        'has_rest_area', 'has_fence', 'has_shower', 'has_locker', 'has_shop',
        'supports_walk_in', 'supports_full_court',
        'walk_in_price_min', 'walk_in_price_max',
        'full_court_price_min', 'full_court_price_max',
        'requires_reservation', 'reservation_method', 'players_per_side'
      )
      ORDER BY column_name;
    `);

    console.log(`\n✅ 找到 ${verifyResult.rows.length} 个列：`);
    verifyResult.rows.forEach(row => {
      console.log(`   - ${row.column_name} (${row.data_type})`);
    });

    await client.end();
    console.log('\n🎉 迁移完成！');
  } catch (error) {
    console.error('\n❌ 执行失败:', error.message);
    if (error.code === 'ECONNREFUSED') {
      console.error('\n💡 提示：请检查数据库连接信息是否正确');
      console.error('   可以在 .env 文件中设置以下环境变量：');
      console.error('   - DB_HOST 或 PGHOST');
      console.error('   - DB_PORT 或 PGPORT');
      console.error('   - DB_NAME 或 PGDATABASE');
      console.error('   - DB_USER 或 PGUSER');
      console.error('   - DB_PASSWORD 或 PGPASSWORD');
    }
    process.exit(1);
  }
}

executeMigration();
