import 'reflect-metadata'
import * as dotenv from 'dotenv'
import { DataSource } from 'typeorm'
import { VenueEntity } from './modules/venues/venue.entity'
import { UserEntity } from './modules/auth/user.entity'
import { ReviewEntity } from './modules/venues/review.entity'
import { VenueImageEntity } from './modules/venues/image.entity'
import { dataSourceOptions } from './data-source'

dotenv.config()

const ds = new DataSource({
  ...dataSourceOptions,
  synchronize: false,
  logging: false,
})

async function viewData() {
  try {
    await ds.initialize()
    console.log('✅ 数据库连接成功\n')

    const venueRepo = ds.getRepository(VenueEntity)
    const userRepo = ds.getRepository(UserEntity)
    const reviewRepo = ds.getRepository(ReviewEntity)
    const imageRepo = ds.getRepository(VenueImageEntity)

    // 查看场地数据
    const venues = await venueRepo.find({ order: { id: 'ASC' } })
    console.log('📊 场地数据 (共', venues.length, '个):')
    console.log('='.repeat(80))
    if (venues.length === 0) {
      console.log('  暂无场地数据')
    } else {
      venues.forEach((v, index) => {
        console.log(`\n${index + 1}. ${v.name}`)
        console.log(`   ID: ${v.id}`)
        console.log(`   类型: ${v.sportType === 'basketball' ? '🏀 篮球' : '⚽ 足球'}`)
        console.log(`   城市: ${v.cityCode}`)
        if (v.address) console.log(`   地址: ${v.address}`)
        console.log(`   坐标: ${v.lng}, ${v.lat}`)
        if (v.priceMin) console.log(`   价格: ¥${v.priceMin}${v.priceMax ? ` - ¥${v.priceMax}` : ''}/小时`)
        console.log(`   室内: ${v.indoor ? '是' : '否'}`)
      })
    }

    // 查看用户数据
    const users = await userRepo.find({ order: { id: 'ASC' } })
    console.log('\n\n📊 用户数据 (共', users.length, '个):')
    console.log('='.repeat(80))
    if (users.length === 0) {
      console.log('  暂无用户数据')
    } else {
      users.forEach((u, index) => {
        console.log(`\n${index + 1}. ${u.nickname || u.phone || '未命名用户'}`)
        console.log(`   ID: ${u.id}`)
        if (u.phone) console.log(`   手机: ${u.phone}`)
        console.log(`   角色: ${u.role}`)
        console.log(`   状态: ${u.status}`)
      })
    }

    // 查看评价数据
    const reviews = await reviewRepo.find({ 
      order: { createdAt: 'DESC' },
      take: 10 
    })
    console.log('\n\n📊 评价数据 (最近', reviews.length, '条):')
    console.log('='.repeat(80))
    if (reviews.length === 0) {
      console.log('  暂无评价数据')
    } else {
      reviews.forEach((r, index) => {
        console.log(`\n${index + 1}. 场地ID: ${r.venue?.id || '未知'}`)
        console.log(`   评分: ${'⭐'.repeat(r.rating)} (${r.rating}/5)`)
        if (r.content) console.log(`   内容: ${r.content.substring(0, 50)}${r.content.length > 50 ? '...' : ''}`)
        console.log(`   时间: ${r.createdAt}`)
      })
    }

    // 查看图片数据
    const images = await imageRepo.find({ 
      order: { id: 'DESC' },
      take: 10 
    })
    console.log('\n\n📊 图片数据 (最近', images.length, '张):')
    console.log('='.repeat(80))
    if (images.length === 0) {
      console.log('  暂无图片数据')
    } else {
      images.forEach((img, index) => {
        console.log(`\n${index + 1}. 场地ID: ${img.venue?.id || '未知'}`)
        console.log(`   URL: ${img.url}`)
        console.log(`   排序: ${img.sort}`)
      })
    }

    // 统计信息
    console.log('\n\n📈 数据统计:')
    console.log('='.repeat(80))
    console.log(`   场地总数: ${venues.length}`)
    console.log(`   用户总数: ${users.length}`)
    const totalReviews = await reviewRepo.count()
    console.log(`   评价总数: ${totalReviews}`)
    const totalImages = await imageRepo.count()
    console.log(`   图片总数: ${totalImages}`)
    
    const basketballVenues = venues.filter(v => v.sportType === 'basketball').length
    const footballVenues = venues.filter(v => v.sportType === 'football').length
    console.log(`   篮球场地: ${basketballVenues}`)
    console.log(`   足球场地: ${footballVenues}`)

    await ds.destroy()
    console.log('\n✅ 数据查看完成')
  } catch (error) {
    console.error('❌ 错误:', error)
    if (error instanceof Error) {
      console.error('错误信息:', error.message)
      console.error('错误堆栈:', error.stack)
    }
    process.exit(1)
  }
}

viewData()

