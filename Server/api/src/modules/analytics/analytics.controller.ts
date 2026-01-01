import { Controller, Post, Get, Body, Query, UseGuards, Headers } from '@nestjs/common'
import { AnalyticsService } from './analytics.service'
import { Public } from '../auth/public.decorator'
import { JwtAuthGuard } from '../auth/auth.guard'
import { CurrentUser } from '../auth/current-user.decorator'

@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Public()
  @Post('page-view')
  async recordPageView(
    @Body() body: { path: string; pageType?: string; referer?: string },
    @Headers('user-agent') userAgent?: string,
    @Headers('x-forwarded-for') forwardedFor?: string,
    @Headers('referer') referer?: string
  ) {
    const ip = forwardedFor?.split(',')[0]?.trim() || 'unknown'
    return this.analyticsService.recordPageView({
      path: body.path,
      pageType: body.pageType,
      referer: body.referer || referer,
      userAgent: userAgent,
      ip,
    })
  }

  @Get('stats')
  @UseGuards(JwtAuthGuard)
  async getStats(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Query('pageType') pageType?: string,
    @CurrentUser() user?: any
  ) {
    // 检查用户是否为管理员
    if (!user || user.role !== 'admin') {
      return {
        error: {
          code: 'Forbidden',
          message: '只有管理员可以查看统计数据',
        },
      }
    }

    const options: any = {}
    if (startDate) options.startDate = new Date(startDate)
    if (endDate) options.endDate = new Date(endDate)
    if (pageType) options.pageType = pageType

    return this.analyticsService.getStats(options)
  }
}

