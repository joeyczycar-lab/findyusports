import { Body, Controller, Get, Param, ParseIntPipe, Post, Query, UseInterceptors, UploadedFile, UseGuards } from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import { VenuesService } from './venues.service'
import { QueryVenuesDto, CreateReviewDto, CreateVenueDto } from './dto'
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
    try {
      const result = await this.venuesService.search(query)
      // 如果服务返回了错误，返回 200 但包含错误信息（前端会处理）
      if (result && 'error' in result) {
        return result
      }
      return result
    } catch (error) {
      console.error('❌ Error listing venues:', error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      // 返回 200 状态码，但包含错误信息（避免前端收到 500）
      return {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '获取场地列表失败',
        },
        items: [],
        page: 1,
        pageSize: 20,
        total: 0,
      }
    }
  }

  @Public()
  @Post()
  async create(@Body() dto: CreateVenueDto) {
    try {
      return await this.venuesService.createVenue(dto)
    } catch (error) {
      console.error('❌ Error creating venue:', error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      return {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '创建场地失败',
        },
      }
    }
  }

  @Public()
  @Get(':id')
  async detail(@Param('id', ParseIntPipe) id: number) {
    try {
      return await this.venuesService.detail(id)
    } catch (error) {
      console.error('❌ Error getting venue detail:', error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      return {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '获取场地详情失败',
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
    try {
      const result = await this.venuesService.deleteImage(id, imageId, user.id)
      // 如果服务返回了错误，直接返回
      if (result && 'error' in result) {
        return result
      }
      return result
    } catch (error) {
      console.error('❌ Error deleting image:', error)
      return {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '删除图片失败',
        },
      }
    }
  }

  @Post(':id/delete')
  async deleteVenue(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    try {
      const result = await this.venuesService.deleteVenue(id, user.id)
      // 如果服务返回了错误，直接返回
      if (result && 'error' in result) {
        return result
      }
      return result
    } catch (error) {
      console.error('❌ Error deleting venue:', error)
      return {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '删除场地失败',
        },
      }
    }
  }

  @Post(':id/upload')
  @UseInterceptors(FileInterceptor('file'))
  async uploadImage(@Param('id', ParseIntPipe) id: number, @UploadedFile() file: Express.Multer.File, @CurrentUser() user: any) {
    console.log('📤 [Upload] Received upload request for venue:', id)
    console.log('📤 [Upload] User:', user ? { id: user.id, phone: user.phone, role: user.role } : 'null')
    console.log('📤 [Upload] File:', file ? { originalname: file.originalname, size: file.size, mimetype: file.mimetype } : 'null')
    
    if (!file) {
      console.error('❌ [Upload] No file uploaded')
      return { error: { code: 'BadRequest', message: 'No file uploaded' } }
    }
    
    if (!user) {
      console.error('❌ [Upload] No user found (authentication failed)')
      return { 
        error: { 
          code: 'Unauthorized', 
          message: '请先登录后再上传图片' 
        } 
      }
    }
    
    try {
      console.log('📤 [Upload] Processing image upload...')
      const result = await this.venuesService.processAndUploadImage(file.buffer, id, file.originalname, user.id)
      console.log('✅ [Upload] Image uploaded successfully:', result.url || result.id)
      return result
    } catch (error) {
      console.error('❌ [Upload] Error processing image:', error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
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


