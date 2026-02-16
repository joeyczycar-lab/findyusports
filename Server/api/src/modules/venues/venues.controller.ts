import { Body, Controller, Get, Param, ParseIntPipe, Post, Put, Query, UseInterceptors, UploadedFile, UseGuards, RequestTimeoutException } from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import { VenuesService } from './venues.service'
import { QueryVenuesDto, CreateReviewDto, CreateVenueDto, UpdateVenueDto } from './dto'
import { JwtAuthGuard } from '../auth/auth.guard'
import { OptionalJwtAuthGuard } from '../auth/optional-jwt.guard'
import { CurrentUser } from '../auth/current-user.decorator'
import { Public } from '../auth/public.decorator'

@Controller('venues')
@UseGuards(JwtAuthGuard)
export class VenuesController {
  constructor(private readonly venuesService: VenuesService) {}

  @Public()
  @Get()
  async list(@Query() query: QueryVenuesDto) {
    return this.venuesService.search(query)
  }

  @Public()
  @UseGuards(OptionalJwtAuthGuard)
  @Post()
  async create(@Body() dto: CreateVenueDto, @CurrentUser() user?: { id: number }) {
    try {
      const result = await this.venuesService.createVenue(dto, user?.id)
      // 如果返回的是错误对象，直接返回
      if (result && (result as any).error) {
        return result
      }
      return result
    } catch (error) {
      console.error('❌ [VenuesController] Error creating venue:', error)
      let errorMessage = error instanceof Error ? error.message : '创建场地失败'
      
      // 提取列名（如果错误信息包含列名）
      if (errorMessage.includes('column') && errorMessage.includes('does not exist')) {
        const columnMatch = errorMessage.match(/column "([^"]+)" of relation "venue"/)
        if (columnMatch) {
          const columnName = columnMatch[1]
          errorMessage = `数据库列 "${columnName}" 不存在。请执行迁移脚本添加缺失的列。`
          console.error(`❌ [VenuesController] Missing column: ${columnName}`)
        }
      }
      
      return {
        error: {
          code: 'InternalServerError',
          message: errorMessage,
        },
      }
    }
  }

  @Public()
  @Get(':id')
  async detail(@Param('id', ParseIntPipe) id: number) {
    return this.venuesService.detail(id)
  }

  @Post(':id/delete')
  async deleteVenue(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    return this.venuesService.deleteVenue(id, user.id)
  }

  @Put(':id')
  async update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateVenueDto, @CurrentUser() user: any) {
    try {
      const result = await this.venuesService.updateVenue(id, dto, user.id)
      // 如果返回的是错误对象，直接返回
      if (result && (result as any).error) {
        return result
      }
      return result
    } catch (error) {
      console.error('❌ [VenuesController] Error updating venue:', error)
      let errorMessage = error instanceof Error ? error.message : '更新场地失败'
      
      // 提取列名（如果错误信息包含列名）
      if (errorMessage.includes('column') && errorMessage.includes('does not exist')) {
        const columnMatch = errorMessage.match(/column "([^"]+)" of relation "venue"/)
        if (columnMatch) {
          const columnName = columnMatch[1]
          errorMessage = `数据库列 "${columnName}" 不存在。请执行迁移脚本添加缺失的列。`
          console.error(`❌ [VenuesController] Missing column: ${columnName}`)
        }
      }
      
      return {
        error: {
          code: 'InternalServerError',
          message: errorMessage,
        },
      }
    }
  }

  @Public()
  @Get(':id/reviews')
  async listReviews(@Param('id', ParseIntPipe) id: number) {
    return this.venuesService.listReviews(id)
  }

  @Public()
  @Get(':id/images')
  async listImages(@Param('id', ParseIntPipe) id: number, @Query('userId') userId?: string) {
    return this.venuesService.listImages(id, userId)
  }

  @Post(':id/reviews')
  async createReview(@Param('id', ParseIntPipe) id: number, @Body() dto: CreateReviewDto, @CurrentUser() user: any) {
    return this.venuesService.createReview(id, dto, user.id)
  }

  @Post('upload/presign')
  async getUploadUrl(@Body() body: { mime: string; ext: string }, @CurrentUser() user: any) {
    return this.venuesService.getUploadUrl(body.mime, body.ext, user.id)
  }

  @Post(':id/images')
  async addImage(@Param('id', ParseIntPipe) id: number, @Body() body: { url: string; sort?: number }, @CurrentUser() user: any) {
    return this.venuesService.addImage(id, body.url, body.sort, user.id)
  }

  @Post(':id/images/:imageId/delete')
  async deleteImage(@Param('id', ParseIntPipe) id: number, @Param('imageId', ParseIntPipe) imageId: number, @CurrentUser() user: any) {
    return this.venuesService.deleteImage(id, imageId, user.id)
  }

  @Post(':id/upload')
  @UseInterceptors(FileInterceptor('file'))
  async uploadImage(@Param('id', ParseIntPipe) id: number, @UploadedFile() file: Express.Multer.File, @CurrentUser() user: any) {
    if (!file) return { error: { code: 'BadRequest', message: 'No file uploaded' } }
    try {
      return await this.venuesService.processAndUploadImage(file.buffer, id, file.originalname, user.id)
    } catch (error) {
      const msg = error instanceof Error ? error.message : String(error)
      if (msg.includes('timeout') || msg.includes('Upload timeout') || msg.includes('ETIMEDOUT')) {
        throw new RequestTimeoutException('上传超时：请缩小图片或压缩后重试（建议单张小于 2MB）')
      }
      if (msg.includes('foreign key') || msg.includes('violates') || msg.includes('FK_') || (error as any)?.code === '23503') {
        return {
          error: {
            code: 'BadRequest',
            message: '保存图片失败：当前场地或登录用户在该数据库中不存在。请确认：1) 前端请求的是当前后端（.env.local 中 NEXT_PUBLIC_API_BASE=http://localhost:4000）；2) 已用该后端注册或登录；3) 场地 id 在当前库中存在。',
          },
        }
      }
      return {
        error: {
          code: 'InternalServerError',
          message: msg || '图片上传失败',
        },
      }
    }
  }

  @Public()
  @Get('images/verify')
  async verifyImageToken(@Query('token') token: string) {
    return this.venuesService.verifyImageToken(token)
  }
}


