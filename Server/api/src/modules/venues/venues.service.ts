import { Injectable } from '@nestjs/common'
import { QueryVenuesDto, CreateReviewDto, CreateVenueDto } from './dto'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { VenueEntity } from './venue.entity'
import { ReviewEntity } from './review.entity'
import { VenueImageEntity } from './image.entity'
import { OssService } from '../oss/oss.service'
import { ImageProcessingService } from '../image/image-processing.service'
import { HotlinkProtectionService } from '../oss/hotlink-protection.service'

type LngLat = [number, number]

function parseLngLatPair(v?: string): { northeast: LngLat; southwest: LngLat } | null {
  if (!v) return null
  return null
}

@Injectable()
export class VenuesService {
  constructor(
    @InjectRepository(VenueEntity)
    private readonly repo: Repository<VenueEntity>,
    @InjectRepository(ReviewEntity)
    private readonly reviewRepo: Repository<ReviewEntity>,
    @InjectRepository(VenueImageEntity)
    private readonly imageRepo: Repository<VenueImageEntity>,
    private readonly ossService: OssService,
    private readonly imageProcessing: ImageProcessingService,
    private readonly hotlinkProtection: HotlinkProtectionService
  ) {}

  async search(query: QueryVenuesDto) {
    try {
      const { ne, sw, sport, minPrice, maxPrice, indoor, page = 1, pageSize, limit } = query
      
      // 支持 limit 参数（兼容前端调用）
      const actualPageSize = limit || pageSize || 20

      // 解析边界参数
      const nePair = ne?.split(',').map(Number)
      const swPair = sw?.split(',').map(Number)
      const neLng = nePair?.[0] ?? 116.55
      const neLat = nePair?.[1] ?? 39.98
      const swLng = swPair?.[0] ?? 116.30
      const swLat = swPair?.[1] ?? 39.84

      // 先检查数据库中是否实际存在 geom 列（在构建查询之前）
    let hasGeomColumn = false
    try {
      const tableName = this.repo.metadata.tableName
      const columnCheck = await this.repo.query(`
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = $1 AND column_name = 'geom'
        LIMIT 1
      `, [tableName])
      hasGeomColumn = Array.isArray(columnCheck) && columnCheck.length > 0 && columnCheck[0]?.column_name === 'geom'
      console.log(`🔍 Geom column check: ${hasGeomColumn ? 'found' : 'not found'}`)
    } catch (error) {
      console.warn('⚠️  Error checking geom column:', error instanceof Error ? error.message : String(error))
      hasGeomColumn = false
    }
    
    const qb = this.repo.createQueryBuilder('v')
    
    // 明确指定要选择的列，排除 geom（如果不存在）
    if (!hasGeomColumn) {
      // 如果 geom 列不存在，明确指定要查询的列
      qb.select([
        'v.id',
        'v.name',
        'v.sportType',
        'v.cityCode',
        'v.address',
        'v.lng',
        'v.lat',
        'v.priceMin',
        'v.priceMax',
        'v.indoor',
      ])
    }
    
    if (sport) qb.andWhere('v.sportType = :sport', { sport })
    if (typeof indoor === 'boolean') qb.andWhere('v.indoor = :indoor', { indoor })
    if (typeof minPrice === 'number') qb.andWhere('(v.priceMin IS NULL OR v.priceMin >= :minPrice)', { minPrice })
    if (typeof maxPrice === 'number') qb.andWhere('(v.priceMax IS NULL OR v.priceMax <= :maxPrice)', { maxPrice })
    
    // 优先使用 PostGIS 空间查询（fallback 到经纬度范围）
    // 只有在确认 geom 列存在时才使用 PostGIS 查询
    if (hasGeomColumn) {
      // 先做 bbox 粗过滤以充分利用索引，再走 ST_Intersects 精确判定
      qb.andWhere('(v.lng BETWEEN :swLng AND :neLng) AND (v.lat BETWEEN :swLat AND :neLat)', { swLng, neLat, neLng, swLat })
      qb.andWhere(`(
        v.geom IS NOT NULL AND ST_Intersects(
          v.geom,
          ST_SetSRID(ST_MakeEnvelope(:swLng2, :swLat2, :neLng2, :neLat2), 4326)
        )
      )`, { swLng2: swLng, swLat2: swLat, neLng2: neLng, neLat2: neLat })
    } else {
      // 使用经纬度范围查询（不依赖 PostGIS）
      // 这是默认方式，适用于没有 PostGIS 的数据库
      qb.andWhere('v.lng BETWEEN :swLng AND :neLng', { swLng, neLng })
      qb.andWhere('v.lat BETWEEN :swLat AND :neLat', { swLat, neLat })
    }

    qb.take(actualPageSize).skip((page - 1) * actualPageSize)

    const [rows, total] = await qb.getManyAndCount()
    
    // 批量查询每个场地的第一张图片
    const venueIds = rows.map(r => r.id)
    let firstImagesMap: Record<number, string | null> = {}
    
    if (venueIds.length > 0) {
      try {
        // 查询每个场地的第一张图片（按sort排序，取第一个）
        const firstImages = await this.imageRepo
          .createQueryBuilder('img')
          .select(['img.venueId', 'img.url'])
          .where('img.venueId IN (:...venueIds)', { venueIds })
          .orderBy('img.sort', 'ASC')
          .addOrderBy('img.id', 'ASC')
          .getRawMany()
        
        // 为每个venueId只保留第一张图片
        const seenVenues = new Set<number>()
        firstImages.forEach((img: any) => {
          const venueId = img.img_venueId
          if (!seenVenues.has(venueId)) {
            firstImagesMap[venueId] = img.img_url
            seenVenues.add(venueId)
          }
        })
      } catch (imageError) {
        console.warn('⚠️  Error loading venue images:', imageError instanceof Error ? imageError.message : String(imageError))
        // 继续执行，只是没有图片
      }
    }
    
    const items = rows.map((r) => ({
      id: String(r.id),
      name: r.name,
      sportType: r.sportType,
      price: r.priceMin ?? 0,
      indoor: r.indoor ?? false,
      location: [r.lng, r.lat] as LngLat,
      distanceKm: 0,
      firstImage: firstImagesMap[r.id] || null, // 添加第一张图片URL
    }))
    return { items, page, pageSize: actualPageSize, total }
    } catch (error) {
      console.error('❌ Error in search:', error)
      if (error instanceof Error) {
        console.error('Error name:', error.name)
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      throw error // 重新抛出，让控制器处理
    }
  }

  async detail(id: number) {
    try {
      const v = await this.repo.findOne({ where: { id } })
      if (!v) return { error: { code: 'NotFound', message: 'Venue not found' } }
      return {
        id: String(v.id),
        name: v.name,
        sportType: v.sportType,
        cityCode: v.cityCode,
        address: v.address,
        priceMin: v.priceMin,
        priceMax: v.priceMax,
        indoor: v.indoor ?? false,
        location: [v.lng, v.lat] as [number, number],
      }
    } catch (error) {
      console.error('❌ Error in detail:', error)
      if (error instanceof Error) {
        console.error('Error name:', error.name)
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      throw error // 重新抛出，让控制器处理
    }
  }

  async createVenue(dto: CreateVenueDto) {
    try {
      console.log('📝 Creating venue:', { name: dto.name, sportType: dto.sportType, cityCode: dto.cityCode })
      
      const venue = new VenueEntity()
      venue.name = dto.name
      venue.sportType = dto.sportType
      venue.cityCode = dto.cityCode
      venue.address = dto.address
      venue.lng = dto.lng
      venue.lat = dto.lat
      venue.priceMin = dto.priceMin
      venue.priceMax = dto.priceMax
      venue.indoor = dto.indoor
      
      // 检查数据库中是否存在 geom 列
      // 如果 PostGIS 不可用（如 Railway 默认 PostgreSQL），则跳过 geom 字段
      let hasGeomColumn = false
      try {
        // 检查数据库表中是否实际存在 geom 列
        const tableName = this.repo.metadata.tableName
        const columnCheck = await this.repo.query(`
          SELECT column_name 
          FROM information_schema.columns 
          WHERE table_name = $1 AND column_name = 'geom'
        `, [tableName])
        
        hasGeomColumn = columnCheck && columnCheck.length > 0
        
        if (hasGeomColumn) {
          console.log('✅ PostGIS geom column found in database, setting geometry point')
          venue.geom = { type: 'Point', coordinates: [dto.lng, dto.lat] } as any
        } else {
          console.log('⚠️  PostGIS geom column not found in database, using QueryBuilder to exclude it')
        }
      } catch (geomError) {
        console.warn('⚠️  Error checking geom column:', geomError instanceof Error ? geomError.message : String(geomError))
        hasGeomColumn = false
      }
      
      console.log('💾 Saving venue to database...')
      
      // 如果 geom 列不存在，使用原生 SQL INSERT 语句，明确指定要插入的列，排除 geom
      let saved: VenueEntity
      if (!hasGeomColumn) {
        // 使用原生 SQL INSERT，完全控制要插入的列
        const insertSql = `
          INSERT INTO "venue" (name, "sportType", "cityCode", address, lng, lat, "priceMin", "priceMax", indoor)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
          RETURNING *
        `
        const result = await this.repo.query(insertSql, [
          venue.name,
          venue.sportType,
          venue.cityCode,
          venue.address || null,
          venue.lng,
          venue.lat,
          venue.priceMin || null,
          venue.priceMax || null,
          venue.indoor !== undefined ? venue.indoor : null,
        ])
        
        if (!result || result.length === 0) {
          throw new Error('Failed to insert venue')
        }
        
        // 将结果转换为实体对象
        const row = result[0]
        saved = {
          id: row.id,
          name: row.name,
          sportType: row.sportType,
          cityCode: row.cityCode,
          address: row.address,
          lng: row.lng,
          lat: row.lat,
          priceMin: row.priceMin,
          priceMax: row.priceMax,
          indoor: row.indoor,
        } as VenueEntity
      } else {
        // geom 列存在，使用正常的 save 方法
        saved = await this.repo.save(venue)
      }
      
      console.log('✅ Venue saved successfully:', saved.id)
      
      return {
        id: String(saved.id),
        name: saved.name,
        sportType: saved.sportType,
        cityCode: saved.cityCode,
        address: saved.address,
        priceMin: saved.priceMin,
        priceMax: saved.priceMax,
        indoor: saved.indoor ?? false,
        location: [saved.lng, saved.lat] as [number, number],
      }
    } catch (error) {
      console.error('❌ Error in createVenue:', error)
      if (error instanceof Error) {
        console.error('Error name:', error.name)
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      throw error // 重新抛出，让控制器处理
    }
  }

  async listReviews(venueId: number) {
    const rows = await this.reviewRepo.find({ where: { venue: { id: venueId } as any }, order: { createdAt: 'DESC' }, take: 20 })
    return { items: rows.map(r => ({ id: r.id, rating: r.rating, content: r.content, createdAt: r.createdAt })) }
  }

  async listImages(venueId: number, userId?: string) {
    const rows = await this.imageRepo.find({ where: { venue: { id: venueId } as any }, order: { sort: 'ASC' } })
    return { 
      items: rows.map(r => ({ 
        id: r.id, 
        url: r.url,
        // 生成带防盗链保护的URL
        protectedUrl: this.hotlinkProtection.generateTokenizedUrl(r.url, userId)
      })) 
    }
  }

  async createReview(venueId: number, dto: CreateReviewDto, userId: number) {
    const venue = await this.repo.findOne({ where: { id: venueId } })
    if (!venue) return { error: { code: 'NotFound', message: 'Venue not found' } }
    
    const review = new ReviewEntity()
    review.venue = venue as any
    review.user = { id: userId } as any
    review.rating = dto.rating
    review.content = dto.content
    const saved = await this.reviewRepo.save(review)
    return { id: saved.id, rating: saved.rating, content: saved.content, createdAt: saved.createdAt }
  }

  async getUploadUrl(mime: string, ext: string, userId: number) {
    return this.ossService.generatePresignedUrl(mime, ext)
  }

  async processAndUploadImage(buffer: Buffer, venueId: number, originalName: string, userId: number) {
    try {
      // 1. 处理图片生成多尺寸
      const baseKey = `venues/${Date.now()}-${Math.random().toString(36).substr(2, 9)}.jpg`
      const processedImages = await this.imageProcessing.processImage(buffer, baseKey)
      const keys = this.imageProcessing.generateKeys(baseKey)
      
      // 2. 上传所有尺寸到OSS
      const uploadPromises = Object.entries(processedImages).map(async ([size, imageBuffer]) => {
        const key = keys[size]
        const { uploadUrl } = await this.ossService.generatePresignedUrl('image/jpeg', 'jpg')
        
        // 直传处理后的图片
        const response = await fetch(uploadUrl, {
          method: 'PUT',
          headers: { 'Content-Type': 'image/jpeg' },
          body: imageBuffer
        })
        
        if (!response.ok) throw new Error(`上传${size}尺寸失败`)
        
        return {
          size,
          key,
          url: `https://${process.env.OSS_BUCKET}.${process.env.OSS_REGION}.aliyuncs.com/${key}`,
          sizeBytes: imageBuffer.length
        }
      })
      
      const uploadResults = await Promise.all(uploadPromises)
      
      // 3. 保存到数据库（以large尺寸为主图）
      const mainImage = uploadResults.find(r => r.size === 'large')
      if (!mainImage) throw new Error('主图上传失败')
      
      const image = new VenueImageEntity()
      image.venue = { id: venueId } as any
      image.user = { id: userId } as any
      image.url = mainImage.url
      image.sort = 0
      const saved = await this.imageRepo.save(image)
      
      return {
        id: saved.id,
        url: saved.url,
        sizes: uploadResults.reduce((acc, r) => {
          acc[r.size] = r.url
          return acc
        }, {} as Record<string, string>),
        info: await this.imageProcessing.getImageInfo(buffer)
      }
    } catch (error) {
      throw new Error(`图片处理上传失败: ${error instanceof Error ? error.message : String(error)}`)
    }
  }

  async addImage(venueId: number, url: string, sort: number | undefined, userId: number) {
    const venue = await this.repo.findOne({ where: { id: venueId } })
    if (!venue) return { error: { code: 'NotFound', message: 'Venue not found' } }
    
    const image = new VenueImageEntity()
    image.venue = venue as any
    image.user = { id: userId } as any
    image.url = url
    image.sort = sort ?? 0
    const saved = await this.imageRepo.save(image)
    return { id: saved.id, url: saved.url }
  }

  async deleteImage(venueId: number, imageId: number, userId: number) {
    const image = await this.imageRepo.findOne({ 
      where: { id: imageId, venue: { id: venueId } as any },
      relations: ['venue']
    })
    if (!image) return { error: { code: 'NotFound', message: 'Image not found' } }
    
    // 从OSS删除文件
    const key = image.url.split('/').pop()
    if (key) {
      await this.ossService.deleteObject(key)
    }
    
    await this.imageRepo.remove(image)
    return { success: true }
  }

  async verifyImageToken(token: string) {
    return this.hotlinkProtection.verifyToken(token)
  }
}


