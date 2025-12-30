import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { UserEntity } from './modules/auth/user.entity'
import { dataSourceOptions } from './data-source'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: true,
})

async function setAdmin() {
  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功\n')

    const userRepo = ds.getRepository(UserEntity)
    const phone = '15224051588'

    // 查找用户
    const user = await userRepo.findOne({ where: { phone } })
    
    if (!user) {
      console.error(`❌ 未找到手机号为 ${phone} 的用户`)
      console.log('\n📋 当前所有用户:')
      const allUsers = await userRepo.find({ order: { id: 'ASC' } })
      if (allUsers.length === 0) {
        console.log('  暂无用户')
      } else {
        allUsers.forEach((u, index) => {
          console.log(`  ${index + 1}. ID: ${u.id}, 手机: ${u.phone}, 角色: ${u.role}, 状态: ${u.status}`)
        })
      }
      await ds.destroy()
      process.exit(1)
    }

    console.log(`📱 找到用户:`)
    console.log(`   ID: ${user.id}`)
    console.log(`   手机: ${user.phone}`)
    console.log(`   昵称: ${user.nickname || '未设置'}`)
    console.log(`   当前角色: ${user.role}`)
    console.log(`   状态: ${user.status}`)
    console.log('')

    // 更新为管理员
    if (user.role === 'admin') {
      console.log('✅ 用户已经是管理员，无需更新')
    } else {
      user.role = 'admin'
      await userRepo.save(user)
      console.log('✅ 已将用户设置为管理员 (role = "admin")')
    }

    // 验证更新
    const updatedUser = await userRepo.findOne({ where: { phone } })
    if (updatedUser && updatedUser.role === 'admin') {
      console.log('\n✅ 验证成功: 用户角色已更新为 admin')
      console.log(`\n📋 用户信息:`)
      console.log(`   ID: ${updatedUser.id}`)
      console.log(`   手机: ${updatedUser.phone}`)
      console.log(`   昵称: ${updatedUser.nickname || '未设置'}`)
      console.log(`   角色: ${updatedUser.role}`)
      console.log(`   状态: ${updatedUser.status}`)
    } else {
      console.error('❌ 验证失败: 用户角色未正确更新')
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

setAdmin()

