import { Body, Controller, Get, Param, ParseIntPipe, Post, Put, Query, UseInterceptors, UploadedFile, UseGuards } from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import { VenuesService } from './venues.service'
import { QueryVenuesDto, CreateReviewDto, CreateVenueDto, UpdateVenueDto } from './dto'
import { JwtAuthGuard } from '../auth/auth.guard'
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
  @Post()
  async create(@Body() dto: CreateVenueDto) {
    try {
      const result = await this.venuesService.createVenue(dto)
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
      return { 
        error: { 
          code: 'InternalServerError', 
          message: error instanceof Error ? error.message : '图片上传失败' 
        } 
      }
    }
  }

  @Public()
  @Get('images/verify')
  async verifyImageToken(@Query('token') token: string) {
    return this.venuesService.verifyImageToken(token)
  }
}


