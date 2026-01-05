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
      const { ne, sw, sport, minPrice, maxPrice, indoor, page = 1, pageSize, limit, cityCode, sortBy } = query
      
      // 支持 limit 参数（兼容前端调用）
      const actualPageSize = limit || pageSize || 20

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
      } catch (error) {
        console.warn('⚠️  Error checking geom column:', error instanceof Error ? error.message : String(error))
        hasGeomColumn = false
      }
    
      const qb = this.repo.createQueryBuilder('v')
    
      // 明确指定要选择的列，排除 geom（如果不存在）
      if (!hasGeomColumn) {
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
    
      // 筛选条件
      if (sport) qb.andWhere('v.sportType = :sport', { sport })
      if (cityCode) qb.andWhere('v.cityCode = :cityCode', { cityCode })
      if (typeof indoor === 'boolean') qb.andWhere('v.indoor = :indoor', { indoor })
      if (typeof minPrice === 'number') qb.andWhere('(v.priceMin IS NULL OR v.priceMin >= :minPrice)', { minPrice })
      if (typeof maxPrice === 'number') qb.andWhere('(v.priceMax IS NULL OR v.priceMax <= :maxPrice)', { maxPrice })
      
      // 只有在提供了坐标范围时才进行坐标筛选（否则获取所有场地）
      if (ne && sw) {
        const nePair = ne.split(',').map(Number)
        const swPair = sw.split(',').map(Number)
        const neLng = nePair[0]
        const neLat = nePair[1]
        const swLng = swPair[0]
        const swLat = swPair[1]
        
        if (hasGeomColumn) {
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
      }

      // 排序逻辑
      if (sortBy === 'city') {
        // 按城市代码排序
        qb.orderBy('v.cityCode', 'ASC')
        qb.addOrderBy('v.name', 'ASC')
      } else if (sortBy === 'popularity') {
        // 按热度排序：先按名称排序，后续在前端根据评价数据重新排序
        qb.orderBy('v.name', 'ASC')
      } else {
        // 默认按名称排序
        qb.orderBy('v.name', 'ASC')
      }

      // 获取总数（在应用分页之前）
      const total = await qb.getCount()
      
      // 应用分页
      qb.take(actualPageSize).skip((page - 1) * actualPageSize)

      // 执行查询获取数据
      const rows = await qb.getMany()
    
    // 批量查询每个场地的第一张图片和评价统计
    const venueIds = rows.map(r => r.id)
    let firstImagesMap: Record<number, string | null> = {}
    let reviewStatsMap: Record<number, { count: number; avgRating: number }> = {}
    
    if (venueIds.length > 0) {
      try {
        console.log(`📸 Querying images for ${venueIds.length} venues:`, venueIds)
        
        // 先检查数据库中是否有图片数据
        const totalImages = await this.imageRepo.count()
        console.log(`📸 Total images in database: ${totalImages}`)
        
        if (totalImages === 0) {
          console.warn('⚠️  No images found in database at all')
        }
        
        // 查询每个场地的第一张图片（按sort排序，取第一个）
        // 使用多种方法尝试查询，确保兼容性
        let firstImages: any[] = []
        
        try {
          // 方法1: 直接查询外键字段，避免 JOIN venue 表（防止 geom 列问题）
          // 先尝试直接查询外键字段
          try {
            const qb = this.imageRepo
              .createQueryBuilder('img')
              .select('img.venueId', 'venueId')
              .addSelect('img.url', 'url')
              .where('img.venueId IN (:...venueIds)', { venueIds })
              .orderBy('img.sort', 'ASC')
              .addOrderBy('img.id', 'ASC')
            
            const sql = qb.getSql()
            console.log(`📸 QueryBuilder SQL (direct):`, sql)
            
            firstImages = await qb.getRawMany()
            
            console.log(`📸 QueryBuilder raw results (first 3):`, JSON.stringify(firstImages.slice(0, 3)))
            
            // 处理 QueryBuilder 返回的字段名
            firstImages = firstImages.map((img: any) => ({
              venueId: Number(img.venueId || img.venue_id || img.venueId),
              url: img.url || img.img_url || img.imgUrl,
            })).filter((img: any) => img.venueId && img.url)
            
            console.log(`📸 QueryBuilder (direct venueId) found ${firstImages.length} images`)
          } catch (directError) {
            console.warn('⚠️  Direct query failed, trying alternative field name:', directError)
            // 如果直接查询失败，尝试不同的字段名格式
            try {
              const qb = this.imageRepo
                .createQueryBuilder('img')
                .select('img.venue_id', 'venueId')
                .addSelect('img.url', 'url')
                .where('img.venue_id IN (:...venueIds)', { venueIds })
                .orderBy('img.sort', 'ASC')
                .addOrderBy('img.id', 'ASC')
              
              firstImages = await qb.getRawMany()
              
              firstImages = firstImages.map((img: any) => ({
                venueId: Number(img.venueId || img.venue_id),
                url: img.url || img.img_url || img.imgUrl,
              })).filter((img: any) => img.venueId && img.url)
              
              console.log(`📸 QueryBuilder (venue_id) found ${firstImages.length} images`)
            } catch (altError) {
              console.warn('⚠️  Alternative field name query also failed:', altError)
            }
          }
          
          // 如果直接查询没找到，尝试原生 SQL
          if (firstImages.length === 0) {
            try {
              // 先检查实际的表结构
              const tableInfo = await this.imageRepo.query(`
                SELECT column_name, data_type 
                FROM information_schema.columns 
                WHERE table_name = 'venue_image'
                ORDER BY ordinal_position
              `)
              console.log(`📸 venue_image table columns:`, tableInfo)
              
              // 尝试直接查询，不通过关系
              const directQuery = await this.imageRepo
                .createQueryBuilder('img')
                .select('img.url', 'url')
                .addSelect('img.venueId', 'venueId')
                .where('img.venueId IN (:...venueIds)', { venueIds })
                .orderBy('img.sort', 'ASC')
                .addOrderBy('img.id', 'ASC')
                .getRawMany()
              
              console.log(`📸 Direct query raw results (first 3):`, JSON.stringify(directQuery.slice(0, 3)))
              
              firstImages = directQuery.map((img: any) => ({
                venueId: Number(img.venueId || img.img_venueId || img.venue_id),
                url: img.url || img.img_url,
              })).filter((img: any) => img.venueId && img.url)
              
              console.log(`📸 QueryBuilder (direct) found ${firstImages.length} images`)
            } catch (directError) {
              console.warn('⚠️  Direct query failed:', directError)
            }
          }
        } catch (qbError) {
          console.warn('⚠️  QueryBuilder failed, trying raw SQL:', qbError)
          // 方法2: 使用原生 SQL 查询，尝试多种字段名格式
          try {
            // 先尝试通过 JOIN 查询
            firstImages = await this.imageRepo.query(
              `SELECT v.id as "venueId", img.url 
               FROM venue_image img 
               JOIN venue v ON img."venueId" = v.id OR img.venue_id = v.id
               WHERE v.id IN (${venueIds.map((_, i) => `$${i + 1}`).join(',')}) 
               ORDER BY img.sort ASC, img.id ASC`,
              venueIds
            )
            
            // 如果没找到，尝试直接查询外键
            if (firstImages.length === 0) {
              // 尝试 venueId（驼峰命名）
              firstImages = await this.imageRepo.query(
                `SELECT "venueId" as "venueId", url FROM venue_image WHERE "venueId" IN (${venueIds.map((_, i) => `$${i + 1}`).join(',')}) ORDER BY sort ASC, id ASC`,
                venueIds
              )
            }
            
            // 如果还是没找到，尝试 venue_id（下划线命名）
            if (firstImages.length === 0) {
              firstImages = await this.imageRepo.query(
                `SELECT venue_id as "venueId", url FROM venue_image WHERE venue_id IN (${venueIds.map((_, i) => `$${i + 1}`).join(',')}) ORDER BY sort ASC, id ASC`,
                venueIds
              )
            }
            
            console.log(`📸 Raw SQL found ${firstImages.length} images`)
          } catch (rawError) {
            console.error('❌ Raw SQL also failed:', rawError)
          }
        }
        
        // 为每个venueId只保留第一张图片
        const seenVenues = new Set<number>()
        firstImages.forEach((img: any) => {
          const venueId = img.venueId
          if (venueId && !seenVenues.has(venueId)) {
            firstImagesMap[venueId] = img.url
            seenVenues.add(venueId)
          }
        })
        
        console.log(`📸 Loaded ${Object.keys(firstImagesMap).length} venue images`)
        if (Object.keys(firstImagesMap).length > 0) {
          console.log(`📸 Image URLs (first 3):`, Object.entries(firstImagesMap).slice(0, 3))
        }
      } catch (imageError) {
        console.error('❌ Error loading venue images:', imageError instanceof Error ? imageError.message : String(imageError))
        if (imageError instanceof Error) {
          console.error('Error stack:', imageError.stack)
        }
      }
      
      // 查询评价统计（用于热度排序）
      try {
        const reviewStats = await this.reviewRepo
          .createQueryBuilder('r')
          .select('r.venueId', 'venueId')
          .addSelect('COUNT(r.id)', 'count')
          .addSelect('COALESCE(AVG(r.rating), 0)', 'avgRating')
          .where('r.venueId IN (:...venueIds)', { venueIds })
          .groupBy('r.venueId')
          .getRawMany()
        
        reviewStats.forEach((stat: any) => {
          reviewStatsMap[stat.venueId] = {
            count: parseInt(stat.count) || 0,
            avgRating: parseFloat(stat.avgRating) || 0,
          }
        })
      } catch (reviewError) {
        console.warn('⚠️  Error loading review stats:', reviewError instanceof Error ? reviewError.message : String(reviewError))
      }
    }
    
    // 如果按热度排序，需要在前端重新排序（因为聚合查询的复杂性）
    let sortedRows = rows
    if (sortBy === 'popularity') {
      sortedRows = [...rows].sort((a, b) => {
        const aStats = reviewStatsMap[a.id] || { count: 0, avgRating: 0 }
        const bStats = reviewStatsMap[b.id] || { count: 0, avgRating: 0 }
        // 先按评价数量，再按平均评分
        if (aStats.count !== bStats.count) {
          return bStats.count - aStats.count
        }
        return bStats.avgRating - aStats.avgRating
      })
    }
    
    const items = sortedRows.map((r) => ({
      id: String(r.id),
      name: r.name,
      sportType: r.sportType,
      cityCode: r.cityCode,
      address: r.address,
      price: r.priceMin ?? 0,
      indoor: r.indoor ?? false,
      location: [r.lng, r.lat] as LngLat,
      distanceKm: 0,
      firstImage: firstImagesMap[r.id] || null,
      reviewCount: reviewStatsMap[r.id]?.count || 0,
      avgRating: reviewStatsMap[r.id]?.avgRating || 0,
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
      // 检查数据库中是否存在 geom 列
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
      } catch (error) {
        console.warn('⚠️  Error checking geom column in detail:', error instanceof Error ? error.message : String(error))
        hasGeomColumn = false
      }

      // 使用 QueryBuilder 明确指定要选择的列
      const qb = this.repo.createQueryBuilder('v').where('v.id = :id', { id })
      
      if (!hasGeomColumn) {
        // 如果 geom 列不存在，明确指定要查询的列
        qb.select([
          'v.id',
          'v.name',
          'v.sportType',
          'v.cityCode',
          'v.districtCode',
          'v.address',
          'v.lng',
          'v.lat',
          'v.priceMin',
          'v.priceMax',
          'v.indoor',
          'v.contact',
          'v.isPublic',
        ])
      }

      const v = await qb.getOne()
      
      if (!v) return { error: { code: 'NotFound', message: 'Venue not found' } }
      
      return {
        id: String(v.id),
        name: v.name,
        sportType: v.sportType,
        cityCode: v.cityCode,
        districtCode: v.districtCode,
        address: v.address,
        priceMin: v.priceMin,
        priceMax: v.priceMax,
        indoor: v.indoor ?? false,
        contact: v.contact,
        isPublic: v.isPublic !== undefined ? v.isPublic : true,
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
      venue.districtCode = dto.districtCode
      venue.address = dto.address
      venue.lng = dto.lng
      venue.lat = dto.lat
      venue.priceMin = dto.priceMin
      venue.priceMax = dto.priceMax
      venue.indoor = dto.indoor
      venue.contact = dto.contact
      venue.isPublic = dto.isPublic !== undefined ? dto.isPublic : true // 默认为对外开放
      
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
          INSERT INTO "venue" (name, "sportType", "cityCode", district_code, address, lng, lat, "priceMin", "priceMax", indoor, contact, is_public)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          RETURNING *
        `
        const result = await this.repo.query(insertSql, [
          venue.name,
          venue.sportType,
          venue.cityCode,
          venue.districtCode || null,
          venue.address || null,
          venue.lng,
          venue.lat,
          venue.priceMin || null,
          venue.priceMax || null,
          venue.indoor !== undefined ? venue.indoor : null,
          venue.contact || null,
          venue.isPublic !== undefined ? venue.isPublic : true,
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
          districtCode: row.district_code,
          address: row.address,
          lng: row.lng,
          lat: row.lat,
          priceMin: row.priceMin,
          priceMax: row.priceMax,
          indoor: row.indoor,
          contact: row.contact,
          isPublic: row.is_public !== undefined ? row.is_public : true,
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
        districtCode: saved.districtCode,
        address: saved.address,
        priceMin: saved.priceMin,
        priceMax: saved.priceMax,
        indoor: saved.indoor ?? false,
        contact: saved.contact,
        isPublic: saved.isPublic !== undefined ? saved.isPublic : true,
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
    try {
      console.log(`📸 Listing images for venue ${venueId}`)
      
      // 先检查数据库中图片总数
      const totalImages = await this.imageRepo.count()
      console.log(`📸 Total images in database: ${totalImages}`)
      
      // 检查表结构
      const tableInfo = await this.imageRepo.query(`
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'venue_image'
        ORDER BY ordinal_position
      `)
      console.log(`📸 venue_image table columns:`, tableInfo.map((c: any) => c.column_name))
      
      // 直接使用 QueryBuilder 查询外键，避免 JOIN venue 表（防止 geom 列问题）
      let rows: any[] = []
      try {
        // 先尝试直接查询外键字段（不 JOIN venue 表）
        const directRows = await this.imageRepo
          .createQueryBuilder('img')
          .where('img.venueId = :venueId', { venueId })
          .orderBy('img.sort', 'ASC')
          .addOrderBy('img.id', 'ASC')
          .getMany()
        
        console.log(`📸 QueryBuilder (direct venueId) found ${directRows.length} images`)
        rows = directRows
        
        // 如果没找到，尝试不同的字段名格式
        if (rows.length === 0) {
          try {
            const altRows = await this.imageRepo
              .createQueryBuilder('img')
              .where('img.venue_id = :venueId', { venueId })
              .orderBy('img.sort', 'ASC')
              .addOrderBy('img.id', 'ASC')
              .getMany()
            
            console.log(`📸 QueryBuilder (venue_id) found ${altRows.length} images`)
            rows = altRows
          } catch (altError) {
            console.warn('⚠️  Alternative field name query failed:', altError)
          }
        }
      } catch (qbError) {
        console.warn('⚠️  QueryBuilder query failed, trying raw query:', qbError)
          // 如果 QueryBuilder 也失败，尝试原生 SQL 查询
          try {
            // 尝试不同的字段名格式
            const queries = [
              `SELECT * FROM venue_image WHERE "venueId" = $1 ORDER BY sort ASC, id ASC`,
              `SELECT * FROM venue_image WHERE venue_id = $1 ORDER BY sort ASC, id ASC`,
            ]
            
            for (const query of queries) {
              try {
                const rawRows = await this.imageRepo.query(query, [venueId])
                if (rawRows.length > 0) {
                  console.log(`📸 Raw SQL found ${rawRows.length} images with query: ${query.substring(0, 50)}`)
                  rows = rawRows.map((row: any) => ({
                    id: row.id,
                    venue: { id: row.venueId || row.venue_id } as any,
                    userId: row.userId || row.user_id,
                    url: row.url,
                    sort: row.sort || 0,
                  })) as any[]
                  break
                }
              } catch (queryError) {
                console.warn(`⚠️  Query failed: ${queryError}`)
              }
            }
          } catch (rawError) {
            console.error('❌ Raw SQL also failed:', rawError)
          }
        }
      
      console.log(`📸 Final result: Found ${rows.length} images for venue ${venueId}`)
      if (rows.length > 0) {
        console.log('📸 First image URL:', rows[0].url)
        console.log('📸 All image URLs:', rows.map((r: any) => r.url))
      }
      
      return { 
        items: rows.map(r => ({ 
          id: r.id, 
          url: r.url,
          // 暂时不使用防盗链保护，直接返回原始URL（OSS已设置为公共读）
          // protectedUrl: this.hotlinkProtection.generateTokenizedUrl(r.url, userId)
        })) 
      }
    } catch (error) {
      console.error('❌ Error listing images:', error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      return { items: [] }
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
        console.log(`📤 [Upload] Generating presigned URL for ${size} size, key: ${key}`)
        // 使用正确的 key 生成预签名URL
        const { uploadUrl, publicUrl } = await this.ossService.generatePresignedUrl('image/jpeg', 'jpg', key)
        
        console.log(`📤 [Upload] Uploading ${size} size to OSS, key: ${key}, uploadUrl: ${uploadUrl.substring(0, 100)}...`)
        // 直传处理后的图片
        // 将 Buffer 转换为 Uint8Array 以兼容 fetch API
        const body = new Uint8Array(imageBuffer)
        const response = await fetch(uploadUrl, {
          method: 'PUT',
          headers: { 'Content-Type': 'image/jpeg' },
          body: body
        })
        
        if (!response.ok) {
          const errorText = await response.text()
          console.error(`❌ [Upload] Failed to upload ${size} size:`, response.status, errorText)
          throw new Error(`上传${size}尺寸失败: ${response.status} ${errorText}`)
        }
        
        const finalUrl = publicUrl || `https://${process.env.OSS_BUCKET}.${process.env.OSS_REGION}.aliyuncs.com/${key}`
        console.log(`✅ [Upload] Successfully uploaded ${size} size, key: ${key}, URL: ${finalUrl}`)
        
        return {
          size,
          key,
          url: finalUrl,
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
      
      console.log(`💾 Saving processed image to database for venue ${venueId}...`)
      const saved = await this.imageRepo.save(image)
      console.log(`✅ Processed image saved: id=${saved.id}, venueId=${venueId}, url=${saved.url}`)
      
      // 验证保存是否成功
      const verify = await this.imageRepo.findOne({ where: { id: saved.id } })
      if (verify) {
        console.log(`✅ Verified processed image exists: id=${verify.id}`)
      } else {
        console.error(`❌ Processed image not found after save!`)
      }
      
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
    try {
      console.log(`📸 Adding image for venue ${venueId}, URL: ${url}`)
      
      const venue = await this.repo.findOne({ where: { id: venueId } })
      if (!venue) {
        console.error(`❌ Venue ${venueId} not found`)
        return { error: { code: 'NotFound', message: 'Venue not found' } }
      }
      
      const image = new VenueImageEntity()
      image.venue = venue as any
      image.user = { id: userId } as any
      image.url = url
      image.sort = sort ?? 0
      
      console.log(`💾 Saving image to database...`)
      const saved = await this.imageRepo.save(image)
      console.log(`✅ Image saved successfully: id=${saved.id}, venueId=${venueId}, url=${saved.url}`)
      
      // 验证保存是否成功
      const verify = await this.imageRepo.findOne({ where: { id: saved.id } })
      if (verify) {
        console.log(`✅ Verified image exists in database: id=${verify.id}`)
      } else {
        console.error(`❌ Image not found after save!`)
      }
      
      return { id: saved.id, url: saved.url }
    } catch (error) {
      console.error('❌ Error adding image:', error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      throw error
    }
  }

  async deleteImage(venueId: number, imageId: number, userId: number) {
    try {
      console.log(`🗑️ [Delete Image] Starting deletion for image ${imageId} of venue ${venueId} by user ${userId}`)
      
      // 使用 QueryBuilder 直接查询，避免加载 venue 关系（防止 geom 列问题）
      let image = await this.imageRepo
        .createQueryBuilder('img')
        .where('img.id = :imageId', { imageId })
        .andWhere('img.venueId = :venueId', { venueId })
        .getOne()
      
      // 如果上面的查询失败，尝试不同的字段名格式
      if (!image) {
        image = await this.imageRepo
          .createQueryBuilder('img')
          .where('img.id = :imageId', { imageId })
          .andWhere('img.venue_id = :venueId', { venueId })
          .getOne()
        
        if (image) {
          console.log(`✅ [Delete Image] Found image using alternative field name`)
        }
      }
      if (!image) {
        console.log(`❌ [Delete Image] Image ${imageId} not found for venue ${venueId}`)
        return { error: { code: 'NotFound', message: 'Image not found' } }
      }
      
      // 从OSS删除文件 - 从完整URL中提取key（venues/xxx.jpg格式）
      try {
        const url = image.url
        if (!url) {
          console.warn(`⚠️ [Delete Image] Image ${imageId} has no URL, skipping OSS deletion`)
        } else {
          // URL格式: https://venues-images.oss-cn-hangzhou.aliyuncs.com/venues/xxx.jpg
          // 提取 key: venues/xxx.jpg
          const urlObj = new URL(url)
          const key = urlObj.pathname.substring(1) // 去掉开头的 '/'
          if (key) {
            console.log(`🗑️ [Delete Image] Deleting OSS object: ${key}`)
            await this.ossService.deleteObject(key)
            console.log(`✅ [Delete Image] Successfully deleted OSS object: ${key}`)
          }
        }
      } catch (error) {
        console.error('❌ [Delete Image] Failed to delete from OSS:', error)
        // 即使OSS删除失败，也继续删除数据库记录
      }
      
      try {
        await this.imageRepo.remove(image)
        console.log(`✅ [Delete Image] Successfully deleted image ${imageId}`)
      } catch (error) {
        console.error(`❌ [Delete Image] Failed to remove image from database:`, error)
        throw error
      }
      
      return { success: true }
    } catch (error) {
      console.error(`❌ [Delete Image] Unexpected error deleting image ${imageId}:`, error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      return { 
        error: { 
          code: 'InternalServerError', 
          message: error instanceof Error ? error.message : '删除图片时发生错误' 
        } 
      }
    }
  }

  async deleteVenue(venueId: number, userId: number) {
    try {
      console.log(`🗑️ [Delete Venue] Starting deletion for venue ${venueId} by user ${userId}`)
      
      // 检查场地是否存在（使用原生 SQL，避免 TypeORM 访问 geom 列）
      const venueCheck = await this.repo.query(
        'SELECT id FROM venue WHERE id = $1',
        [venueId]
      )
      if (!venueCheck || venueCheck.length === 0) {
        console.log(`❌ [Delete Venue] Venue ${venueId} not found`)
        return { error: { code: 'NotFound', message: 'Venue not found' } }
      }

      // 删除所有关联的图片（从OSS和数据库）
      // 使用原生 SQL 查询，先检查实际的外键列名
      const columnInfo = await this.imageRepo.query(`
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = 'venue_image' 
        AND (column_name = 'venueId' OR column_name = 'venue_id' OR column_name LIKE '%venue%')
        ORDER BY column_name
      `)
      console.log(`🗑️ [Delete Venue] venue_image table columns:`, columnInfo.map((c: any) => c.column_name))
      
      // 查找实际的外键列名
      const venueColumn = columnInfo.find((c: any) => 
        c.column_name === 'venueId' || 
        c.column_name === 'venue_id' || 
        c.column_name.toLowerCase().includes('venue')
      )
      
      let images: any[] = []
      if (venueColumn) {
        const colName = venueColumn.column_name
        console.log(`🗑️ [Delete Venue] Using column: ${colName}`)
        try {
          // 使用找到的列名查询
          const result = await this.imageRepo.query(
            `SELECT id, url FROM venue_image WHERE "${colName}" = $1`,
            [venueId]
          )
          images = result || []
          console.log(`✅ [Delete Venue] Found ${images.length} images using column: ${colName}`)
        } catch (sqlError) {
          console.error(`❌ [Delete Venue] Error querying with column ${colName}:`, sqlError)
          // 尝试不使用引号
          try {
            const result = await this.imageRepo.query(
              `SELECT id, url FROM venue_image WHERE ${colName} = $1`,
              [venueId]
            )
            images = result || []
            console.log(`✅ [Delete Venue] Found ${images.length} images (without quotes)`)
          } catch (sqlError2) {
            console.error(`❌ [Delete Venue] Error querying without quotes:`, sqlError2)
          }
        }
      } else {
        console.warn(`⚠️ [Delete Venue] Could not find venue foreign key column, trying all possible names`)
        // 尝试所有可能的列名
        const possibleColumns = ['venueId', 'venue_id']
        for (const colName of possibleColumns) {
          try {
            const result = await this.imageRepo.query(
              `SELECT id, url FROM venue_image WHERE ${colName} = $1`,
              [venueId]
            )
            if (result && result.length > 0) {
              images = result
              console.log(`✅ [Delete Venue] Found ${images.length} images using column: ${colName}`)
              break
            }
          } catch (colError) {
            // 继续尝试下一个
            continue
          }
        }
      }
      
      console.log(`🗑️ [Delete Venue] Found ${images.length} images to delete for venue ${venueId}`)
      
      // 尝试从OSS删除所有图片，但即使失败也继续
      for (const image of images) {
        try {
          // 从OSS删除文件
          const url = image.url
          if (!url) {
            console.warn(`⚠️ [Delete Venue] Image ${image.id} has no URL, skipping OSS deletion`)
            continue
          }
          
          const urlObj = new URL(url)
          const key = urlObj.pathname.substring(1)
          if (key) {
            console.log(`🗑️ [Delete Venue] Deleting OSS object: ${key}`)
            await this.ossService.deleteObject(key)
            console.log(`✅ [Delete Venue] Successfully deleted OSS object: ${key}`)
          }
        } catch (error) {
          console.error(`❌ [Delete Venue] Failed to delete image ${image.id} from OSS:`, error)
          // 继续删除其他图片，即使OSS删除失败
        }
      }

      // 删除所有图片记录（使用原生 SQL，避免列名问题）
      if (images.length > 0) {
        try {
          // 使用原生 SQL 删除图片记录
          const imageIds = images.map(img => img.id)
          if (imageIds.length > 0) {
            await this.imageRepo.query(
              `DELETE FROM venue_image WHERE id = ANY($1::int[])`,
              [imageIds]
            )
            console.log(`✅ [Delete Venue] Successfully removed ${images.length} image records from database`)
          }
        } catch (error) {
          console.error(`❌ [Delete Venue] Failed to remove image records:`, error)
          // 继续删除场地
        }
      }
      
      // 删除场地（使用原生 SQL，避免 TypeORM 访问 geom 列）
      // CASCADE 会自动删除关联的 reviews 和 images
      try {
        // 使用原生 SQL 删除，避免 TypeORM 尝试访问 geom 列
        const deleteResult = await this.repo.query(
          'DELETE FROM venue WHERE id = $1',
          [venueId]
        )
        console.log(`✅ [Delete Venue] Successfully deleted venue ${venueId}`, deleteResult)
      } catch (error) {
        console.error(`❌ [Delete Venue] Failed to delete venue from database:`, error)
        throw error
      }
      
      return { success: true }
    } catch (error) {
      console.error(`❌ [Delete Venue] Unexpected error deleting venue ${venueId}:`, error)
      if (error instanceof Error) {
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      return { 
        error: { 
          code: 'InternalServerError', 
          message: error instanceof Error ? error.message : '删除场地时发生错误' 
        } 
      }
    }
  }

  async verifyImageToken(token: string) {
    return this.hotlinkProtection.verifyToken(token)
  }
}


