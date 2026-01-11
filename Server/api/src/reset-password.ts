import { DataSource } from 'typeorm'
import { UserEntity } from './modules/auth/user.entity'
import { dataSourceOptions } from './data-source'
import * as dotenv from 'dotenv'
import * as bcrypt from 'bcrypt'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: true,
})

async function resetPassword() {
  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功\n')

    const userRepo = ds.getRepository(UserEntity)
    const phone = process.argv[2] || '15224051588'
    const newPassword = process.argv[3] || '123456'

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
    console.log(`   角色: ${user.role}`)
    console.log(`   状态: ${user.status}`)
    console.log('')

    // 加密新密码
    const hashedPassword = await bcrypt.hash(newPassword, 10)
    user.password = hashedPassword
    user.status = 'active' // 确保用户状态是 active
    
    await userRepo.save(user)
    console.log(`✅ 密码已重置为: ${newPassword}`)
    console.log(`✅ 用户状态已设置为: active`)

    // 验证更新
    const updatedUser = await userRepo.findOne({ where: { phone } })
    if (updatedUser) {
      console.log('\n✅ 验证成功:')
      console.log(`   手机: ${updatedUser.phone}`)
      console.log(`   角色: ${updatedUser.role}`)
      console.log(`   状态: ${updatedUser.status}`)
    }

    await ds.destroy()
    console.log('\n✅ 完成！')
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

resetPassword()
