import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { PageViewEntity } from './page-view.entity'

@Injectable()
export class AnalyticsService {
  constructor(
    @InjectRepository(PageViewEntity)
    private readonly pageViewRepo: Repository<PageViewEntity>
  ) {}

  async recordPageView(data: {
    path: string
    pageType?: string
    referer?: string
    userAgent?: string
    ip?: string
    userId?: string
  }) {
    try {
      const pageView = this.pageViewRepo.create({
        path: data.path,
        pageType: data.pageType,
        referer: data.referer,
        userAgent: data.userAgent,
        ip: data.ip,
        userId: data.userId,
      })
      await this.pageViewRepo.save(pageView)
      return { success: true }
    } catch (error) {
      console.error('❌ [Analytics] Failed to record page view:', error)
      return { error: { code: 'InternalServerError', message: '记录访问失败' } }
    }
  }

  async getStats(options?: {
    startDate?: Date
    endDate?: Date
    pageType?: string
  }) {
    try {
      const qb = this.pageViewRepo.createQueryBuilder('pv')

      if (options?.startDate) {
        qb.andWhere('pv.createdAt >= :startDate', { startDate: options.startDate })
      }
      if (options?.endDate) {
        qb.andWhere('pv.createdAt <= :endDate', { endDate: options.endDate })
      }
      if (options?.pageType) {
        qb.andWhere('pv.pageType = :pageType', { pageType: options.pageType })
      }

      // 总访问量
      const totalViews = await qb.getCount()

      // 按页面路径统计
      const viewsByPath = await this.pageViewRepo
        .createQueryBuilder('pv')
        .select('pv.path', 'path')
        .addSelect('COUNT(*)', 'count')
        .groupBy('pv.path')
        .orderBy('count', 'DESC')
        .limit(20)
        .getRawMany()

      // 按页面类型统计
      const viewsByType = await this.pageViewRepo
        .createQueryBuilder('pv')
        .select('pv.pageType', 'pageType')
        .addSelect('COUNT(*)', 'count')
        .where('pv.pageType IS NOT NULL')
        .groupBy('pv.pageType')
        .orderBy('count', 'DESC')
        .getRawMany()
      
      // 注意：TypeORM 会自动处理 camelCase 到 snake_case 的转换

      // 今日访问量
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      const todayViews = await this.pageViewRepo
        .createQueryBuilder('pv')
        .where('pv.createdAt >= :today', { today })
        .getCount()

      // 最近7天访问量
      const sevenDaysAgo = new Date()
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7)
      const weekViews = await this.pageViewRepo
        .createQueryBuilder('pv')
        .where('pv.createdAt >= :sevenDaysAgo', { sevenDaysAgo })
        .getCount()

      // 最近30天访问量
      const thirtyDaysAgo = new Date()
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
      const monthViews = await this.pageViewRepo
        .createQueryBuilder('pv')
        .where('pv.createdAt >= :thirtyDaysAgo', { thirtyDaysAgo })
        .getCount()

      return {
        totalViews,
        todayViews,
        weekViews,
        monthViews,
        viewsByPath: viewsByPath.map((v: any) => ({
          path: v.path,
          count: parseInt(v.count, 10),
        })),
        viewsByType: viewsByType.map((v: any) => ({
          pageType: v.pageType,
          count: parseInt(v.count, 10),
        })),
      }
    } catch (error) {
      console.error('❌ [Analytics] Failed to get stats:', error)
      return {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '获取统计数据失败',
        },
      }
    }
  }
}

