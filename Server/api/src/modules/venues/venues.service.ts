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
    const { ne, sw, sport, minPrice, maxPrice, indoor, page = 1, pageSize = 20 } = query

    // mock 数据（后续可接 DB + 空间索引）
    const nePair = ne?.split(',').map(Number)
    const swPair = sw?.split(',').map(Number)
    const neLng = nePair?.[0] ?? 116.55
    const neLat = nePair?.[1] ?? 39.98
    const swLng = swPair?.[0] ?? 116.30
    const swLat = swPair?.[1] ?? 39.84

    const randomIn = (min: number, max: number) => Math.random() * (max - min) + min

    const qb = this.repo.createQueryBuilder('v')
    if (sport) qb.andWhere('v.sportType = :sport', { sport })
    if (typeof indoor === 'boolean') qb.andWhere('v.indoor = :indoor', { indoor })
    if (typeof minPrice === 'number') qb.andWhere('(v.priceMin IS NULL OR v.priceMin >= :minPrice)', { minPrice })
    if (typeof maxPrice === 'number') qb.andWhere('(v.priceMax IS NULL OR v.priceMax <= :maxPrice)', { maxPrice })
    // 优先使用 PostGIS 空间查询（fallback 到经纬度范围）
    if (this.repo.metadata.columns.find(c => c.propertyName === 'geom')) {
      // 先做 bbox 粗过滤以充分利用索引，再走 ST_Intersects 精确判定
      qb.andWhere('(v.lng BETWEEN :swLng AND :neLng) AND (v.lat BETWEEN :swLat AND :neLat)', { swLng, neLat, neLng, swLat })
      qb.andWhere(`(
        v.geom IS NOT NULL AND ST_Intersects(
          v.geom,
          ST_SetSRID(ST_MakeEnvelope(:swLng2, :swLat2, :neLng2, :neLat2), 4326)
        )
      )`, { swLng2: swLng, swLat2: swLat, neLng2: neLng, neLat2: neLat })
    } else {
      qb.andWhere('v.lng BETWEEN :swLng AND :neLng', { swLng, neLng })
      qb.andWhere('v.lat BETWEEN :swLat AND :neLat', { swLat, neLat })
    }

    qb.take(pageSize).skip((page - 1) * pageSize)

    const [rows, total] = await qb.getManyAndCount()
    const items = rows.map((r) => ({
      id: String(r.id),
      name: r.name,
      sportType: r.sportType,
      price: r.priceMin ?? 0,
      indoor: r.indoor ?? false,
      location: [r.lng, r.lat] as LngLat,
      distanceKm: 0,
    }))
    return { items, page, pageSize, total }
  }

  async detail(id: number) {
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
  }

  async createVenue(dto: CreateVenueDto) {
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
    // 创建 PostGIS geometry point
    venue.geom = { type: 'Point', coordinates: [dto.lng, dto.lat] } as any
    
    const saved = await this.repo.save(venue)
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


