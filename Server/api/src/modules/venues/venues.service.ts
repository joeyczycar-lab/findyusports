import { Injectable } from '@nestjs/common'
import { QueryVenuesDto, CreateReviewDto, CreateVenueDto, UpdateVenueDto } from './dto'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import * as https from 'https'
import * as http from 'http'
import { URL } from 'url'
import { VenueEntity } from './venue.entity'
import { ReviewEntity } from './review.entity'
import { VenueImageEntity } from './image.entity'
import { UserEntity } from '../auth/user.entity'
import { OssService } from '../oss/oss.service'
import { ImageProcessingService } from '../image/image-processing.service'
import { HotlinkProtectionService } from '../oss/hotlink-protection.service'

type LngLat = [number, number]

/** 数据库 venue 表字符串列限制（与 varchar 一致，超长会报错）。保存前截断避免 "value too long for type character varying(120)" */
const VENUE_STRING_MAX = 120
function truncateVenueStr(value: string | null | undefined, max: number = VENUE_STRING_MAX): string | undefined {
  if (value == null || value === '') return undefined
  return value.length <= max ? value : value.slice(0, max)
}

/** 仅展示该用户（或 NULL 历史数据）的场地；未设置则展示全部 */
function getTrustedUserIds(): number[] | null {
  const raw = process.env.TRUSTED_USER_ID ?? process.env.TRUSTED_USER_IDS ?? ''
  if (!raw.trim()) return null
  const ids = raw.split(',').map((s) => parseInt(s.trim(), 10)).filter((n) => !Number.isNaN(n))
  return ids.length > 0 ? ids : null
}

/** Railway → 阿里云 OSS 用 fetch 易被 undici 默认超时打断，改用 Node 原生 https 并设 90s 总超时 */
function putToUrlWithTimeout(uploadUrl: string, body: Buffer, timeoutMs: number): Promise<{ ok: boolean; statusCode: number }> {
  return new Promise((resolve, reject) => {
    const u = new URL(uploadUrl)
    const isHttps = u.protocol === 'https:'
    const mod = isHttps ? https : http
    const req = mod.request(
      {
        hostname: u.hostname,
        port: u.port || (isHttps ? 443 : 80),
        path: u.pathname + u.search,
        method: 'PUT',
        headers: { 'Content-Type': 'image/jpeg', 'Content-Length': body.length },
      },
      (res) => {
        clearTimeout(timer)
        res.resume()
        resolve({
          ok: (res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) < 300,
          statusCode: res.statusCode ?? 0,
        })
      }
    )
    const timer = setTimeout(() => {
      req.destroy()
      reject(new Error('Upload timeout'))
    }, timeoutMs)
    req.on('error', (err) => {
      clearTimeout(timer)
      reject(err)
    })
    req.write(body)
    req.end()
  })
}

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
    @InjectRepository(UserEntity)
    private readonly userRepo: Repository<UserEntity>,
    private readonly ossService: OssService,
    private readonly imageProcessing: ImageProcessingService,
    private readonly hotlinkProtection: HotlinkProtectionService
  ) {}

  async search(query: QueryVenuesDto) {
    try {
      const { ne, sw, sport, minPrice, maxPrice, indoor, page = 1, pageSize, limit, cityCode, districtCode, sortBy, keyword } = query
      
      // 支持 limit 参数（兼容前端调用）
      const actualPageSize = limit || pageSize || 20

      // 先检查数据库中是否实际存在 geom 列和新设施字段（在构建查询之前）
      const tableName = this.repo.metadata.tableName
      let hasGeomColumn = false
      let hasPriceDisplay = false
      let hasShower = false
      let hasLocker = false
      let hasShop = false
      let hasCreatedByUserId = false
      
      try {
        const columnCheck = await this.repo.query(`
          SELECT column_name 
          FROM information_schema.columns 
          WHERE table_name = $1 
          AND column_name IN ('geom', 'price_display', 'has_shower', 'has_locker', 'has_shop', 'created_by_user_id')
        `, [tableName])
        const existingColumns = columnCheck.map((row: any) => row.column_name)
        hasGeomColumn = existingColumns.includes('geom')
        hasPriceDisplay = existingColumns.includes('price_display')
        hasShower = existingColumns.includes('has_shower')
        hasLocker = existingColumns.includes('has_locker')
        hasShop = existingColumns.includes('has_shop')
        hasCreatedByUserId = existingColumns.includes('created_by_user_id')
      } catch (error) {
        console.warn('⚠️  Error checking columns:', error instanceof Error ? error.message : String(error))
        hasGeomColumn = false
      }
    
      const qb = this.repo.createQueryBuilder('v')
    
      // 明确指定要选择的列，排除不存在的列
      const selectColumns = [
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
      ]
      
      // 只添加存在的列
      if (hasPriceDisplay) selectColumns.push('v.priceDisplay')
      if (hasShower) selectColumns.push('v.hasShower')
      if (hasLocker) selectColumns.push('v.hasLocker')
      if (hasShop) selectColumns.push('v.hasShop')
      
      qb.select(selectColumns)

      // 仅展示“信任账号”或历史数据（created_by_user_id 为 NULL）的场地
      const trustedIds = getTrustedUserIds()
      if (trustedIds && hasCreatedByUserId) {
        qb.andWhere('(v.created_by_user_id IS NULL OR v.created_by_user_id IN (:...trustedIds))', { trustedIds })
      }
    
      // 筛选条件
      if (sport) qb.andWhere('v.sportType = :sport', { sport })
      if (cityCode) qb.andWhere('v.cityCode = :cityCode', { cityCode })
      if (districtCode && districtCode.trim()) qb.andWhere('v.districtCode = :districtCode', { districtCode: districtCode.trim() })
      if (typeof indoor === 'boolean') qb.andWhere('v.indoor = :indoor', { indoor })
      if (typeof minPrice === 'number') qb.andWhere('(v.priceMin IS NULL OR v.priceMin >= :minPrice)', { minPrice })
      if (typeof maxPrice === 'number') qb.andWhere('(v.priceMax IS NULL OR v.priceMax <= :maxPrice)', { maxPrice })
      // 关键词搜索（按名称或地址）
      if (keyword && keyword.trim()) {
        const searchKeyword = `%${keyword.trim()}%`
        qb.andWhere('(v.name ILIKE :keyword OR v.address ILIKE :keyword)', { keyword: searchKeyword })
      }
      
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
        qb.orderBy('v.cityCode', 'ASC')
        qb.addOrderBy('v.name', 'ASC')
      } else if (sortBy === 'newest') {
        // 按添加先后：id 递增即添加顺序，降序=最新添加在前
        qb.orderBy('v.id', 'DESC')
      } else if (sortBy === 'popularity') {
        qb.orderBy('v.name', 'ASC')
      } else {
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
          // 方法1: 直接查询外键字段（优先 venue_id，兼容阿里云等 snake_case 列名）
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
              venueId: Number(img.venueId ?? img.venue_id),
              url: img.url || img.img_url || img.imgUrl,
            })).filter((img: any) => img.venueId && img.url)
            if (firstImages.length > 0) {
              console.log(`📸 QueryBuilder (venue_id) found ${firstImages.length} images`)
            }
          } catch (_) {}
          if (firstImages.length === 0) {
            try {
              const qb = this.imageRepo
                .createQueryBuilder('img')
                .select('img.venueId', 'venueId')
                .addSelect('img.url', 'url')
                .where('img.venueId IN (:...venueIds)', { venueIds })
                .orderBy('img.sort', 'ASC')
                .addOrderBy('img.id', 'ASC')
              firstImages = await qb.getRawMany()
              firstImages = firstImages.map((img: any) => ({
                venueId: Number(img.venueId || img.venue_id),
                url: img.url || img.img_url || img.imgUrl,
              })).filter((img: any) => img.venueId && img.url)
              if (firstImages.length > 0) console.log(`📸 QueryBuilder (venueId) found ${firstImages.length} images`)
            } catch (_) {}
          }
          
          // 如果直接查询没找到，尝试原生 SQL（优先 venue_id）
          if (firstImages.length === 0) {
            try {
              const rawWithVenueId = await this.imageRepo.query(
                `SELECT venue_id as "venueId", url FROM venue_image WHERE venue_id IN (${venueIds.map((_, i) => `$${i + 1}`).join(',')}) ORDER BY sort ASC, id ASC`,
                venueIds
              )
              if (rawWithVenueId.length > 0) {
                firstImages = rawWithVenueId.map((img: any) => ({
                  venueId: Number(img.venueId ?? img.venue_id),
                  url: img.url,
                })).filter((img: any) => img.venueId && img.url)
                console.log(`📸 Raw SQL (venue_id) found ${firstImages.length} images`)
              }
            } catch (_) {}
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
            
            // 如果没找到，尝试直接查询外键（优先 venue_id）
            if (firstImages.length === 0) {
              firstImages = await this.imageRepo.query(
                `SELECT venue_id as "venueId", url FROM venue_image WHERE venue_id IN (${venueIds.map((_, i) => `$${i + 1}`).join(',')}) ORDER BY sort ASC, id ASC`,
                venueIds
              )
            }
            if (firstImages.length === 0) {
              firstImages = await this.imageRepo.query(
                `SELECT "venueId" as "venueId", url FROM venue_image WHERE "venueId" IN (${venueIds.map((_, i) => `$${i + 1}`).join(',')}) ORDER BY sort ASC, id ASC`,
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
      priceDisplay: (r as any).priceDisplay ?? undefined,
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

      // 检查新设施字段是否存在
      const tableName = this.repo.metadata.tableName
      let hasPriceDisplay = false
      let hasWalkInPriceDisplay = false
      let hasFullCourtPriceDisplay = false
      let hasShower = false
      let hasLocker = false
      let hasShop = false
      let hasRestArea = false
      let hasFence = false
      let hasRequiresReservation = false
      let hasReservationMethod = false
      let hasPlayersPerSide = false
      let hasSupportsWalkIn = false
      let hasSupportsFullCourt = false
      let hasWalkInPriceMin = false
      let hasWalkInPriceMax = false
      let hasFullCourtPriceMin = false
      let hasFullCourtPriceMax = false
      let hasCreatedByUserId = false
      try {
        const columnCheck = await this.repo.query(`
          SELECT column_name 
          FROM information_schema.columns 
          WHERE table_name = $1 
          AND column_name IN ('price_display', 'walk_in_price_display', 'full_court_price_display', 'has_shower', 'has_locker', 'has_shop', 'has_rest_area', 'has_fence', 'supports_walk_in', 'supports_full_court', 'walk_in_price_min', 'walk_in_price_max', 'full_court_price_min', 'full_court_price_max', 'requires_reservation', 'reservation_method', 'players_per_side', 'created_by_user_id')
        `, [tableName])
        const existingColumns = columnCheck.map((row: any) => row.column_name)
        hasPriceDisplay = existingColumns.includes('price_display')
        hasWalkInPriceDisplay = existingColumns.includes('walk_in_price_display')
        hasFullCourtPriceDisplay = existingColumns.includes('full_court_price_display')
        hasShower = existingColumns.includes('has_shower')
        hasLocker = existingColumns.includes('has_locker')
        hasShop = existingColumns.includes('has_shop')
        hasRestArea = existingColumns.includes('has_rest_area')
        hasFence = existingColumns.includes('has_fence')
        hasRequiresReservation = existingColumns.includes('requires_reservation')
        hasReservationMethod = existingColumns.includes('reservation_method')
        hasPlayersPerSide = existingColumns.includes('players_per_side')
        hasSupportsWalkIn = existingColumns.includes('supports_walk_in')
        hasSupportsFullCourt = existingColumns.includes('supports_full_court')
        hasWalkInPriceMin = existingColumns.includes('walk_in_price_min')
        hasWalkInPriceMax = existingColumns.includes('walk_in_price_max')
        hasFullCourtPriceMin = existingColumns.includes('full_court_price_min')
        hasFullCourtPriceMax = existingColumns.includes('full_court_price_max')
        hasCreatedByUserId = existingColumns.includes('created_by_user_id')
      } catch (error) {
        console.warn('⚠️ Error checking facility columns in detail:', error instanceof Error ? error.message : String(error))
      }

      // 使用 QueryBuilder 明确指定要选择的列
      const qb = this.repo.createQueryBuilder('v').where('v.id = :id', { id })
      
      if (!hasGeomColumn) {
        // 如果 geom 列不存在，明确指定要查询的列
        const selectColumns = [
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
          'v.courtCount',
          'v.floorType',
          'v.openHours',
          'v.hasLighting',
          'v.hasAirConditioning',
          'v.hasParking',
        ]
        
        // 只添加存在的列
        if (hasPriceDisplay) selectColumns.push('v.priceDisplay')
        if (hasRestArea) selectColumns.push('v.hasRestArea')
        if (hasFence) selectColumns.push('v.hasFence')
        if (hasShower) selectColumns.push('v.hasShower')
        if (hasLocker) selectColumns.push('v.hasLocker')
        if (hasShop) selectColumns.push('v.hasShop')
        if (hasRequiresReservation) selectColumns.push('v.requiresReservation')
        if (hasReservationMethod) selectColumns.push('v.reservationMethod')
        if (hasPlayersPerSide) selectColumns.push('v.playersPerSide')
        if (hasSupportsWalkIn) selectColumns.push('v.supportsWalkIn')
        if (hasWalkInPriceMin) selectColumns.push('v.walkInPriceMin')
        if (hasWalkInPriceMax) selectColumns.push('v.walkInPriceMax')
        if (hasWalkInPriceDisplay) selectColumns.push('v.walkInPriceDisplay')
        if (hasSupportsFullCourt) selectColumns.push('v.supportsFullCourt')
        if (hasFullCourtPriceMin) selectColumns.push('v.fullCourtPriceMin')
        if (hasFullCourtPriceMax) selectColumns.push('v.fullCourtPriceMax')
        if (hasFullCourtPriceDisplay) selectColumns.push('v.fullCourtPriceDisplay')
        if (hasCreatedByUserId) selectColumns.push('v.createdByUserId')
        
        qb.select(selectColumns)
      }

      const v = await qb.getOne()
      
      if (!v) return { error: { code: 'NotFound', message: 'Venue not found' } }

      // 仅展示“信任账号”或历史数据（created_by_user_id 为 NULL）的场地
      const trustedIds = getTrustedUserIds()
      if (trustedIds && hasCreatedByUserId) {
        const createdBy = (v as any).createdByUserId
        if (createdBy != null && !trustedIds.includes(Number(createdBy))) {
          return { error: { code: 'NotFound', message: 'Venue not found' } }
        }
      }
      
      const result: any = {
        id: String(v.id),
        name: v.name,
        sportType: v.sportType,
        cityCode: v.cityCode,
        districtCode: v.districtCode,
        address: v.address,
        priceMin: v.priceMin,
        priceMax: v.priceMax,
        priceDisplay: hasPriceDisplay ? (v as any).priceDisplay : undefined,
        indoor: v.indoor ?? false,
        contact: v.contact,
        isPublic: v.isPublic !== undefined ? v.isPublic : true,
        courtCount: v.courtCount,
        floorType: v.floorType,
        openHours: v.openHours,
        hasLighting: v.hasLighting,
        hasAirConditioning: v.hasAirConditioning,
        hasParking: v.hasParking,
        location: [v.lng, v.lat] as [number, number],
      }
      
      // 只添加存在的列
      if (hasRestArea) result.hasRestArea = v.hasRestArea
      if (hasFence) result.hasFence = v.hasFence
      if (hasShower) result.hasShower = v.hasShower
      if (hasLocker) result.hasLocker = v.hasLocker
      if (hasShop) result.hasShop = v.hasShop
      if (hasRequiresReservation) result.requiresReservation = v.requiresReservation
      if (hasReservationMethod) result.reservationMethod = v.reservationMethod
      if (hasPlayersPerSide) result.playersPerSide = v.playersPerSide
      if (hasSupportsWalkIn) result.supportsWalkIn = v.supportsWalkIn
      if (hasWalkInPriceMin) result.walkInPriceMin = v.walkInPriceMin
      if (hasWalkInPriceMax) result.walkInPriceMax = v.walkInPriceMax
      if (hasWalkInPriceDisplay) result.walkInPriceDisplay = (v as any).walkInPriceDisplay
      if (hasSupportsFullCourt) result.supportsFullCourt = v.supportsFullCourt
      if (hasFullCourtPriceMin) result.fullCourtPriceMin = v.fullCourtPriceMin
      if (hasFullCourtPriceMax) result.fullCourtPriceMax = v.fullCourtPriceMax
      if (hasFullCourtPriceDisplay) result.fullCourtPriceDisplay = (v as any).fullCourtPriceDisplay
      
      return result
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

  async createVenue(dto: CreateVenueDto, userId?: number) {
    try {
      console.log('📝 Creating venue:', { name: dto.name, sportType: dto.sportType, cityCode: dto.cityCode, createdByUserId: userId ?? null })
      
      const venue = new VenueEntity()
      venue.name = (dto.name && dto.name.length > VENUE_STRING_MAX) ? dto.name.slice(0, VENUE_STRING_MAX) : (dto.name ?? '')
      if (userId !== undefined && userId !== null) (venue as any).createdByUserId = userId
      venue.sportType = dto.sportType
      venue.cityCode = dto.cityCode
      venue.districtCode = truncateVenueStr(dto.districtCode, 6) ?? dto.districtCode
      venue.address = (dto.address && dto.address.length > 200) ? dto.address.slice(0, 200) : dto.address
      venue.lng = dto.lng
      venue.lat = dto.lat
      venue.priceMin = dto.priceMin
      venue.priceMax = dto.priceMax
      venue.priceDisplay = truncateVenueStr(dto.priceDisplay)
      
      // 检查哪些新字段存在（在设置字段值之前）
      const tableName = this.repo.metadata.tableName
      let hasPriceDisplay = false
      let hasWalkInPriceDisplay = false
      let hasFullCourtPriceDisplay = false
      let hasCourtCount = false
      let hasFloorType = false
      let hasOpenHours = false
      let hasLighting = false
      let hasAirConditioning = false
      let hasParking = false
      let hasFence = false
      let hasSupportsWalkIn = false
      let hasSupportsFullCourt = false
      let hasWalkInPriceMin = false
      let hasWalkInPriceMax = false
      let hasFullCourtPriceMin = false
      let hasFullCourtPriceMax = false
      let hasRestArea = false
      let hasRequiresReservation = false
      let hasReservationMethod = false
      let hasPlayersPerSide = false
      let hasShower = false
      let hasLocker = false
      let hasShop = false
      let hasCreatedByUserId = false
      
      try {
        const columnCheck = await this.repo.query(`
          SELECT column_name 
          FROM information_schema.columns 
          WHERE table_name = $1 
          AND column_name IN ('price_display', 'walk_in_price_display', 'full_court_price_display', 'court_count', 'floor_type', 'open_hours', 'has_lighting', 'has_air_conditioning', 'has_parking', 'has_rest_area', 'has_fence', 'supports_walk_in', 'supports_full_court', 'walk_in_price_min', 'walk_in_price_max', 'full_court_price_min', 'full_court_price_max', 'has_shower', 'has_locker', 'has_shop', 'requires_reservation', 'reservation_method', 'players_per_side', 'created_by_user_id')
        `, [tableName])
        
        const existingColumns = columnCheck.map((row: any) => row.column_name)
        hasCreatedByUserId = existingColumns.includes('created_by_user_id')
        hasPriceDisplay = existingColumns.includes('price_display')
        hasWalkInPriceDisplay = existingColumns.includes('walk_in_price_display')
        hasFullCourtPriceDisplay = existingColumns.includes('full_court_price_display')
        hasCourtCount = existingColumns.includes('court_count')
        hasFloorType = existingColumns.includes('floor_type')
        hasOpenHours = existingColumns.includes('open_hours')
        hasLighting = existingColumns.includes('has_lighting')
        hasAirConditioning = existingColumns.includes('has_air_conditioning')
        hasParking = existingColumns.includes('has_parking')
        hasFence = existingColumns.includes('has_fence')
        hasSupportsWalkIn = existingColumns.includes('supports_walk_in')
        hasSupportsFullCourt = existingColumns.includes('supports_full_court')
        hasWalkInPriceMin = existingColumns.includes('walk_in_price_min')
        hasWalkInPriceMax = existingColumns.includes('walk_in_price_max')
        hasFullCourtPriceMin = existingColumns.includes('full_court_price_min')
        hasFullCourtPriceMax = existingColumns.includes('full_court_price_max')
        hasRestArea = existingColumns.includes('has_rest_area')
        hasRequiresReservation = existingColumns.includes('requires_reservation')
        hasReservationMethod = existingColumns.includes('reservation_method')
        hasPlayersPerSide = existingColumns.includes('players_per_side')
        hasShower = existingColumns.includes('has_shower')
        hasLocker = existingColumns.includes('has_locker')
        hasShop = existingColumns.includes('has_shop')
      } catch (error) {
        console.warn('⚠️ [createVenue] Error checking columns:', error instanceof Error ? error.message : String(error))
      }
      
      // 只设置存在的列
      if (hasSupportsWalkIn) venue.supportsWalkIn = dto.supportsWalkIn
      if (hasWalkInPriceMin) venue.walkInPriceMin = dto.walkInPriceMin
      if (hasWalkInPriceMax) venue.walkInPriceMax = dto.walkInPriceMax
      if (hasWalkInPriceDisplay) venue.walkInPriceDisplay = truncateVenueStr(dto.walkInPriceDisplay)
      if (hasSupportsFullCourt) venue.supportsFullCourt = dto.supportsFullCourt
      if (hasFullCourtPriceMin) venue.fullCourtPriceMin = dto.fullCourtPriceMin
      if (hasFullCourtPriceMax) venue.fullCourtPriceMax = dto.fullCourtPriceMax
      if (hasFullCourtPriceDisplay) venue.fullCourtPriceDisplay = truncateVenueStr(dto.fullCourtPriceDisplay)
      venue.indoor = dto.indoor !== null && dto.indoor !== undefined ? dto.indoor : undefined
      venue.contact = (dto.contact && dto.contact.length > 100) ? dto.contact.slice(0, 100) : dto.contact
      venue.requiresReservation = dto.requiresReservation
      venue.reservationMethod = (dto.reservationMethod && dto.reservationMethod.length > 200) ? dto.reservationMethod.slice(0, 200) : dto.reservationMethod
      venue.playersPerSide = truncateVenueStr(dto.playersPerSide)
      venue.isPublic = dto.isPublic !== undefined ? dto.isPublic : true // 默认为对外开放
      venue.courtCount = dto.courtCount
      venue.floorType = dto.floorType
      venue.openHours = dto.openHours
      venue.hasLighting = dto.hasLighting
      venue.hasAirConditioning = dto.hasAirConditioning
      venue.hasParking = dto.hasParking
      venue.hasFence = dto.hasFence
      venue.hasRestArea = dto.hasRestArea
      venue.hasShower = dto.hasShower
      venue.hasLocker = dto.hasLocker
      venue.hasShop = dto.hasShop
      
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
      
      // 始终使用原生 SQL INSERT 语句，明确指定要插入的列，避免访问不存在的列
      let saved: VenueEntity
      {
        
        // 构建动态的 INSERT 语句
        const baseColumns = ['name', '"sportType"', '"cityCode"', 'district_code', 'address', 'lng', 'lat', '"priceMin"', '"priceMax"', 'indoor', 'contact', 'is_public']
        const baseValues = [
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
        ]
        
        let paramIndex = baseValues.length + 1
        const columns = [...baseColumns]
        const values = [...baseValues]
        
        if (hasPriceDisplay) {
          columns.push('price_display')
          values.push(venue.priceDisplay ?? null)
          paramIndex++
        }
        if (hasCourtCount) {
          columns.push('court_count')
          values.push(venue.courtCount || null)
          paramIndex++
        }
        if (hasFloorType) {
          columns.push('floor_type')
          values.push(venue.floorType || null)
          paramIndex++
        }
        if (hasOpenHours) {
          columns.push('open_hours')
          values.push(venue.openHours || null)
          paramIndex++
        }
        if (hasLighting) {
          columns.push('has_lighting')
          values.push(venue.hasLighting !== undefined ? venue.hasLighting : null)
          paramIndex++
        }
        if (hasAirConditioning) {
          columns.push('has_air_conditioning')
          values.push(venue.hasAirConditioning !== undefined ? venue.hasAirConditioning : null)
          paramIndex++
        }
        if (hasParking) {
          columns.push('has_parking')
          values.push(venue.hasParking !== undefined ? venue.hasParking : null)
          paramIndex++
        }
        if (hasFence) {
          columns.push('has_fence')
          values.push(venue.hasFence !== undefined ? venue.hasFence : null)
          paramIndex++
        }
        if (hasSupportsWalkIn) {
          columns.push('supports_walk_in')
          values.push(venue.supportsWalkIn !== undefined ? venue.supportsWalkIn : null)
          paramIndex++
        }
        if (hasSupportsFullCourt) {
          columns.push('supports_full_court')
          values.push(venue.supportsFullCourt !== undefined ? venue.supportsFullCourt : null)
          paramIndex++
        }
        if (hasWalkInPriceMin) {
          columns.push('walk_in_price_min')
          values.push(venue.walkInPriceMin !== undefined ? venue.walkInPriceMin : null)
          paramIndex++
        }
        if (hasWalkInPriceMax) {
          columns.push('walk_in_price_max')
          values.push(venue.walkInPriceMax !== undefined ? venue.walkInPriceMax : null)
          paramIndex++
        }
        if (hasFullCourtPriceMin) {
          columns.push('full_court_price_min')
          values.push(venue.fullCourtPriceMin !== undefined ? venue.fullCourtPriceMin : null)
          paramIndex++
        }
        if (hasFullCourtPriceMax) {
          columns.push('full_court_price_max')
          values.push(venue.fullCourtPriceMax !== undefined ? venue.fullCourtPriceMax : null)
          paramIndex++
        }
        if (hasWalkInPriceDisplay) {
          columns.push('walk_in_price_display')
          values.push(venue.walkInPriceDisplay ?? null)
          paramIndex++
        }
        if (hasFullCourtPriceDisplay) {
          columns.push('full_court_price_display')
          values.push(venue.fullCourtPriceDisplay ?? null)
          paramIndex++
        }
        if (hasRestArea) {
          columns.push('has_rest_area')
          values.push(venue.hasRestArea !== undefined ? venue.hasRestArea : null)
          paramIndex++
        }
        if (hasRequiresReservation) {
          columns.push('requires_reservation')
          values.push(venue.requiresReservation !== undefined ? venue.requiresReservation : null)
          paramIndex++
        }
        if (hasReservationMethod) {
          columns.push('reservation_method')
          values.push(venue.reservationMethod || null)
          paramIndex++
        }
        if (hasPlayersPerSide) {
          columns.push('players_per_side')
          values.push(venue.playersPerSide || null)
          paramIndex++
        }
        if (hasShower) {
          columns.push('has_shower')
          values.push(venue.hasShower !== undefined ? venue.hasShower : null)
          paramIndex++
        }
        if (hasLocker) {
          columns.push('has_locker')
          values.push(venue.hasLocker !== undefined ? venue.hasLocker : null)
          paramIndex++
        }
        if (hasShop) {
          columns.push('has_shop')
          values.push(venue.hasShop !== undefined ? venue.hasShop : null)
          paramIndex++
        }
        if (hasCreatedByUserId) {
          columns.push('created_by_user_id')
          values.push((venue as any).createdByUserId ?? null)
          paramIndex++
        }
        
        // 添加 geom 列（如果存在）
        if (hasGeomColumn && venue.lng && venue.lat) {
          columns.push('geom')
          values.push(`POINT(${venue.lng} ${venue.lat})`)
          paramIndex++
        }
        
        const placeholders = values.map((_, i) => `$${i + 1}`).join(', ')
        const insertSql = `
          INSERT INTO "venue" (${columns.join(', ')})
          VALUES (${placeholders})
          RETURNING *
        `
        
        const result = await this.repo.query(insertSql, values)
        
        if (!result || result.length === 0) {
          throw new Error('Failed to insert venue')
        }
        
        // 将结果转换为实体对象（支持下划线和驼峰两种格式）
        const row = result[0]
        saved = {
          id: row.id,
          name: row.name,
          sportType: row.sportType || row.sport_type,
          cityCode: row.cityCode || row.city_code,
          districtCode: row.districtCode || row.district_code,
          address: row.address,
          lng: row.lng,
          lat: row.lat,
          priceMin: row.priceMin !== undefined ? row.priceMin : row.price_min,
          priceMax: row.priceMax !== undefined ? row.priceMax : row.price_max,
          priceDisplay: hasPriceDisplay ? (row.priceDisplay ?? row.price_display) : undefined,
          indoor: row.indoor,
          contact: row.contact,
          isPublic: row.isPublic !== undefined ? row.isPublic : (row.is_public !== undefined ? row.is_public : true),
          courtCount: hasCourtCount ? (row.courtCount !== undefined ? row.courtCount : row.court_count) : undefined,
          floorType: hasFloorType ? (row.floorType || row.floor_type) : undefined,
          openHours: hasOpenHours ? (row.openHours || row.open_hours) : undefined,
          hasLighting: hasLighting ? (row.hasLighting !== undefined ? row.hasLighting : row.has_lighting) : undefined,
          hasAirConditioning: hasAirConditioning ? (row.hasAirConditioning !== undefined ? row.hasAirConditioning : row.has_air_conditioning) : undefined,
          hasParking: hasParking ? (row.hasParking !== undefined ? row.hasParking : row.has_parking) : undefined,
          hasFence: hasFence ? (row.hasFence !== undefined ? row.hasFence : row.has_fence) : undefined,
          hasRestArea: hasRestArea ? (row.hasRestArea !== undefined ? row.hasRestArea : row.has_rest_area) : undefined,
          hasShower: hasShower ? (row.hasShower !== undefined ? row.hasShower : row.has_shower) : undefined,
          hasLocker: hasLocker ? (row.hasLocker !== undefined ? row.hasLocker : row.has_locker) : undefined,
          hasShop: hasShop ? (row.hasShop !== undefined ? row.hasShop : row.has_shop) : undefined,
          supportsWalkIn: hasSupportsWalkIn ? (row.supportsWalkIn !== undefined ? row.supportsWalkIn : row.supports_walk_in) : undefined,
          supportsFullCourt: hasSupportsFullCourt ? (row.supportsFullCourt !== undefined ? row.supportsFullCourt : row.supports_full_court) : undefined,
          walkInPriceMin: hasWalkInPriceMin ? (row.walkInPriceMin !== undefined ? row.walkInPriceMin : row.walk_in_price_min) : undefined,
          walkInPriceMax: hasWalkInPriceMax ? (row.walkInPriceMax !== undefined ? row.walkInPriceMax : row.walk_in_price_max) : undefined,
          walkInPriceDisplay: hasWalkInPriceDisplay ? (row.walkInPriceDisplay ?? row.walk_in_price_display) : undefined,
          fullCourtPriceMin: hasFullCourtPriceMin ? (row.fullCourtPriceMin !== undefined ? row.fullCourtPriceMin : row.full_court_price_min) : undefined,
          fullCourtPriceMax: hasFullCourtPriceMax ? (row.fullCourtPriceMax !== undefined ? row.fullCourtPriceMax : row.full_court_price_max) : undefined,
          fullCourtPriceDisplay: hasFullCourtPriceDisplay ? (row.fullCourtPriceDisplay ?? row.full_court_price_display) : undefined,
          requiresReservation: hasRequiresReservation ? (row.requiresReservation !== undefined ? row.requiresReservation : row.requires_reservation) : undefined,
          reservationMethod: hasReservationMethod ? (row.reservationMethod || row.reservation_method) : undefined,
          playersPerSide: hasPlayersPerSide ? (row.playersPerSide || row.players_per_side) : undefined,
        } as VenueEntity
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
        priceDisplay: hasPriceDisplay ? saved.priceDisplay : undefined,
        supportsWalkIn: hasSupportsWalkIn ? saved.supportsWalkIn : undefined,
        supportsFullCourt: hasSupportsFullCourt ? saved.supportsFullCourt : undefined,
        indoor: saved.indoor ?? false,
        contact: saved.contact,
        requiresReservation: hasRequiresReservation ? saved.requiresReservation : undefined,
        reservationMethod: hasReservationMethod ? saved.reservationMethod : undefined,
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

  async updateVenue(venueId: number, dto: UpdateVenueDto, userId: number) {
    try {
      console.log('📝 Updating venue:', venueId, dto)
      
      // 检查 geom 列和其他新字段是否存在
      const tableName = this.repo.metadata.tableName
      let hasGeomColumn = false
      let hasPriceDisplay = false
      let hasWalkInPriceDisplay = false
      let hasFullCourtPriceDisplay = false
      let hasSupportsWalkIn = false
      let hasSupportsFullCourt = false
      let hasWalkInPriceMin = false
      let hasWalkInPriceMax = false
      let hasFullCourtPriceMin = false
      let hasFullCourtPriceMax = false
      let hasRequiresReservation = false
      let hasReservationMethod = false
      let hasPlayersPerSide = false
      let hasRestArea = false
      let hasFence = false
      let hasShower = false
      let hasLocker = false
      let hasShop = false
      
      try {
        const columnCheck = await this.repo.query(`
          SELECT column_name 
          FROM information_schema.columns 
          WHERE table_name = $1 
          AND column_name IN ('geom', 'price_display', 'walk_in_price_display', 'full_court_price_display', 'supports_walk_in', 'supports_full_court', 'walk_in_price_min', 'walk_in_price_max', 'full_court_price_min', 'full_court_price_max', 'requires_reservation', 'reservation_method', 'players_per_side', 'has_rest_area', 'has_fence', 'has_shower', 'has_locker', 'has_shop')
        `, [tableName])
        const existingColumns = columnCheck.map((row: any) => row.column_name)
        hasGeomColumn = existingColumns.includes('geom')
        hasPriceDisplay = existingColumns.includes('price_display')
        hasWalkInPriceDisplay = existingColumns.includes('walk_in_price_display')
        hasFullCourtPriceDisplay = existingColumns.includes('full_court_price_display')
        hasSupportsWalkIn = existingColumns.includes('supports_walk_in')
        hasSupportsFullCourt = existingColumns.includes('supports_full_court')
        hasWalkInPriceMin = existingColumns.includes('walk_in_price_min')
        hasWalkInPriceMax = existingColumns.includes('walk_in_price_max')
        hasFullCourtPriceMin = existingColumns.includes('full_court_price_min')
        hasFullCourtPriceMax = existingColumns.includes('full_court_price_max')
        hasRequiresReservation = existingColumns.includes('requires_reservation')
        hasReservationMethod = existingColumns.includes('reservation_method')
        hasPlayersPerSide = existingColumns.includes('players_per_side')
        hasRestArea = existingColumns.includes('has_rest_area')
        hasFence = existingColumns.includes('has_fence')
        hasShower = existingColumns.includes('has_shower')
        hasLocker = existingColumns.includes('has_locker')
        hasShop = existingColumns.includes('has_shop')
        console.log('🔍 [updateVenue] Column check:', {
          hasGeomColumn,
          hasSupportsWalkIn,
          hasSupportsFullCourt,
          hasWalkInPriceMin,
          hasWalkInPriceMax,
          hasFullCourtPriceMin,
          hasFullCourtPriceMax,
          hasRequiresReservation,
          hasReservationMethod,
          hasPlayersPerSide,
          hasRestArea,
          hasFence,
          hasShower,
          hasLocker,
          hasShop
        })
      } catch (columnError) {
        console.warn('⚠️ [updateVenue] Error checking columns:', columnError instanceof Error ? columnError.message : String(columnError))
        hasGeomColumn = false
      }
      
      // 检查场地是否存在
      let venue: VenueEntity | null
      if (!hasGeomColumn) {
        // 如果 geom 列不存在，使用 QueryBuilder 明确指定要查询的列，排除 geom
        venue = await this.repo
          .createQueryBuilder('venue')
          .where('venue.id = :id', { id: venueId })
          .getOne()
      } else {
        venue = await this.repo.findOne({ where: { id: venueId } })
      }
      
      if (!venue) {
        return { error: { code: 'NotFound', message: '场地不存在' } }
      }

      // 检查用户权限：只有管理员可以更新所有场地
      // 这里假设管理员role为'admin'，可以根据实际情况调整
      // 注意：这里需要从user对象获取role，但当前方法签名只有userId
      // 如果需要更严格的权限控制，可以传入user对象
      
      // 更新字段（只更新存在的列）；长字符串按 DB 限制截断，避免 "value too long for type character varying(120)"
      if (dto.name !== undefined) venue.name = dto.name.length > VENUE_STRING_MAX ? dto.name.slice(0, VENUE_STRING_MAX) : dto.name
      if (dto.sportType !== undefined) venue.sportType = dto.sportType
      if (dto.cityCode !== undefined) venue.cityCode = dto.cityCode
      if (dto.districtCode !== undefined) venue.districtCode = (dto.districtCode && dto.districtCode.length > 6) ? dto.districtCode.slice(0, 6) : dto.districtCode
      if (dto.address !== undefined) venue.address = (dto.address && dto.address.length > 200) ? dto.address.slice(0, 200) : dto.address
      if (dto.lng !== undefined) venue.lng = dto.lng
      if (dto.lat !== undefined) venue.lat = dto.lat
      if (dto.priceMin !== undefined) venue.priceMin = dto.priceMin
      if (dto.priceMax !== undefined) venue.priceMax = dto.priceMax
      if (dto.priceDisplay !== undefined && hasPriceDisplay) venue.priceDisplay = truncateVenueStr(dto.priceDisplay)
      // 只更新存在的列
      if (dto.supportsWalkIn !== undefined && hasSupportsWalkIn) venue.supportsWalkIn = dto.supportsWalkIn
      if (dto.walkInPriceMin !== undefined && hasWalkInPriceMin) venue.walkInPriceMin = dto.walkInPriceMin
      if (dto.walkInPriceMax !== undefined && hasWalkInPriceMax) venue.walkInPriceMax = dto.walkInPriceMax
      if (dto.walkInPriceDisplay !== undefined && hasWalkInPriceDisplay) venue.walkInPriceDisplay = truncateVenueStr(dto.walkInPriceDisplay)
      if (dto.supportsFullCourt !== undefined && hasSupportsFullCourt) venue.supportsFullCourt = dto.supportsFullCourt
      if (dto.fullCourtPriceMin !== undefined && hasFullCourtPriceMin) venue.fullCourtPriceMin = dto.fullCourtPriceMin
      if (dto.fullCourtPriceMax !== undefined && hasFullCourtPriceMax) venue.fullCourtPriceMax = dto.fullCourtPriceMax
      if (dto.fullCourtPriceDisplay !== undefined && hasFullCourtPriceDisplay) venue.fullCourtPriceDisplay = truncateVenueStr(dto.fullCourtPriceDisplay)
      if (dto.indoor !== undefined && dto.indoor !== null) venue.indoor = dto.indoor
      if (dto.contact !== undefined) venue.contact = (dto.contact && dto.contact.length > 100) ? dto.contact.slice(0, 100) : dto.contact
      if (dto.requiresReservation !== undefined && hasRequiresReservation) venue.requiresReservation = dto.requiresReservation
      if (dto.reservationMethod !== undefined && hasReservationMethod) venue.reservationMethod = (dto.reservationMethod && dto.reservationMethod.length > 200) ? dto.reservationMethod.slice(0, 200) : dto.reservationMethod
      if (dto.playersPerSide !== undefined && hasPlayersPerSide) venue.playersPerSide = truncateVenueStr(dto.playersPerSide)
      if (dto.isPublic !== undefined) venue.isPublic = dto.isPublic
      if (dto.courtCount !== undefined) venue.courtCount = dto.courtCount
      if (dto.floorType !== undefined) venue.floorType = dto.floorType
      if (dto.openHours !== undefined) venue.openHours = dto.openHours
      if (dto.hasLighting !== undefined) venue.hasLighting = dto.hasLighting
      if (dto.hasAirConditioning !== undefined) venue.hasAirConditioning = dto.hasAirConditioning
      if (dto.hasParking !== undefined) venue.hasParking = dto.hasParking
      if (dto.hasFence !== undefined && hasFence) venue.hasFence = dto.hasFence
      if (dto.hasShower !== undefined && hasShower) venue.hasShower = dto.hasShower
      if (dto.hasLocker !== undefined && hasLocker) venue.hasLocker = dto.hasLocker
      if (dto.hasShop !== undefined && hasShop) venue.hasShop = dto.hasShop
      if (dto.hasRestArea !== undefined && hasRestArea) venue.hasRestArea = dto.hasRestArea
      
      // 始终使用原生 SQL UPDATE 语句，明确指定要更新的列，避免更新不存在的列
      // 这样可以确保只更新存在的列，即使某些新列还没有添加到数据库
      let saved: VenueEntity
      {
        console.log('📝 [updateVenue] Using native SQL UPDATE to ensure only existing columns are updated')
        // 构建 UPDATE 语句，排除 geom 列
        const updates: string[] = []
        const values: any[] = []
        let paramIndex = 1
        
        if (dto.name !== undefined) {
          updates.push(`name = $${paramIndex++}`)
          values.push(dto.name.length > VENUE_STRING_MAX ? dto.name.slice(0, VENUE_STRING_MAX) : dto.name)
        }
        if (dto.sportType !== undefined) {
          updates.push(`"sportType" = $${paramIndex++}`)
          values.push(dto.sportType)
        }
        if (dto.cityCode !== undefined) {
          updates.push(`"cityCode" = $${paramIndex++}`)
          values.push(dto.cityCode)
        }
        if (dto.districtCode !== undefined) {
          updates.push(`district_code = $${paramIndex++}`)
          values.push(dto.districtCode)
        }
        if (dto.address !== undefined) {
          updates.push(`address = $${paramIndex++}`)
          values.push((dto.address && dto.address.length > 200) ? dto.address.slice(0, 200) : dto.address)
        }
        if (dto.lng !== undefined) {
          updates.push(`lng = $${paramIndex++}`)
          values.push(dto.lng)
        }
        if (dto.lat !== undefined) {
          updates.push(`lat = $${paramIndex++}`)
          values.push(dto.lat)
        }
        if (dto.priceMin !== undefined) {
          updates.push(`"priceMin" = $${paramIndex++}`)
          values.push(dto.priceMin)
        }
        if (dto.priceMax !== undefined) {
          updates.push(`"priceMax" = $${paramIndex++}`)
          values.push(dto.priceMax)
        }
        if (dto.priceDisplay !== undefined && hasPriceDisplay) {
          updates.push(`price_display = $${paramIndex++}`)
          values.push(truncateVenueStr(dto.priceDisplay))
        }
        if (dto.indoor !== undefined && dto.indoor !== null) {
          updates.push(`indoor = $${paramIndex++}`)
          values.push(dto.indoor)
        }
        if (dto.contact !== undefined) {
          updates.push(`contact = $${paramIndex++}`)
          values.push((dto.contact && dto.contact.length > 100) ? dto.contact.slice(0, 100) : dto.contact)
        }
        if (dto.isPublic !== undefined) {
          updates.push(`is_public = $${paramIndex++}`)
          values.push(dto.isPublic)
        }
        if (dto.courtCount !== undefined) {
          updates.push(`court_count = $${paramIndex++}`)
          values.push(dto.courtCount)
        }
        if (dto.floorType !== undefined) {
          updates.push(`floor_type = $${paramIndex++}`)
          values.push(dto.floorType)
        }
        if (dto.openHours !== undefined) {
          updates.push(`open_hours = $${paramIndex++}`)
          values.push(dto.openHours)
        }
        if (dto.hasLighting !== undefined) {
          updates.push(`has_lighting = $${paramIndex++}`)
          values.push(dto.hasLighting)
        }
        if (dto.hasAirConditioning !== undefined) {
          updates.push(`has_air_conditioning = $${paramIndex++}`)
          values.push(dto.hasAirConditioning)
        }
        if (dto.hasParking !== undefined) {
          updates.push(`has_parking = $${paramIndex++}`)
          values.push(dto.hasParking)
        }
        if (dto.hasFence !== undefined && hasFence) {
          updates.push(`has_fence = $${paramIndex++}`)
          values.push(dto.hasFence)
        }
        if (dto.hasRestArea !== undefined && hasRestArea) {
          updates.push(`has_rest_area = $${paramIndex++}`)
          values.push(dto.hasRestArea)
        }
        if (dto.hasShower !== undefined && hasShower) {
          updates.push(`has_shower = $${paramIndex++}`)
          values.push(dto.hasShower)
        }
        if (dto.hasLocker !== undefined && hasLocker) {
          updates.push(`has_locker = $${paramIndex++}`)
          values.push(dto.hasLocker)
        }
        if (dto.hasShop !== undefined && hasShop) {
          updates.push(`has_shop = $${paramIndex++}`)
          values.push(dto.hasShop)
        }
        if (dto.supportsWalkIn !== undefined && hasSupportsWalkIn) {
          updates.push(`supports_walk_in = $${paramIndex++}`)
          values.push(dto.supportsWalkIn)
        }
        if (dto.walkInPriceMin !== undefined && hasWalkInPriceMin) {
          updates.push(`walk_in_price_min = $${paramIndex++}`)
          values.push(dto.walkInPriceMin)
        }
        if (dto.walkInPriceMax !== undefined && hasWalkInPriceMax) {
          updates.push(`walk_in_price_max = $${paramIndex++}`)
          values.push(dto.walkInPriceMax)
        }
        if (dto.walkInPriceDisplay !== undefined && hasWalkInPriceDisplay) {
          updates.push(`walk_in_price_display = $${paramIndex++}`)
          values.push(truncateVenueStr(dto.walkInPriceDisplay))
        }
        if (dto.supportsFullCourt !== undefined && hasSupportsFullCourt) {
          updates.push(`supports_full_court = $${paramIndex++}`)
          values.push(dto.supportsFullCourt)
        }
        if (dto.fullCourtPriceMin !== undefined && hasFullCourtPriceMin) {
          updates.push(`full_court_price_min = $${paramIndex++}`)
          values.push(dto.fullCourtPriceMin)
        }
        if (dto.fullCourtPriceMax !== undefined && hasFullCourtPriceMax) {
          updates.push(`full_court_price_max = $${paramIndex++}`)
          values.push(dto.fullCourtPriceMax)
        }
        if (dto.fullCourtPriceDisplay !== undefined && hasFullCourtPriceDisplay) {
          updates.push(`full_court_price_display = $${paramIndex++}`)
          values.push(truncateVenueStr(dto.fullCourtPriceDisplay))
        }
        if (dto.requiresReservation !== undefined && hasRequiresReservation) {
          updates.push(`requires_reservation = $${paramIndex++}`)
          values.push(dto.requiresReservation)
        }
        if (dto.reservationMethod !== undefined && hasReservationMethod) {
          updates.push(`reservation_method = $${paramIndex++}`)
          values.push((dto.reservationMethod && dto.reservationMethod.length > 200) ? dto.reservationMethod.slice(0, 200) : dto.reservationMethod)
        }
        if (dto.playersPerSide !== undefined && hasPlayersPerSide) {
          updates.push(`players_per_side = $${paramIndex++}`)
          values.push(truncateVenueStr(dto.playersPerSide))
        }
        
        if (updates.length > 0) {
          values.push(venueId)
          const sql = `UPDATE venue SET ${updates.join(', ')} WHERE id = $${paramIndex} RETURNING *`
          console.log('📝 [updateVenue] Executing SQL:', sql.substring(0, 200) + '...')
          const result = await this.repo.query(sql, values)
          const row = result[0]
          // 将 SQL 返回的下划线格式字段名映射到驼峰格式
          saved = {
            id: row.id,
            name: row.name,
            sportType: row.sportType || row.sport_type,
            cityCode: row.cityCode || row.city_code,
            districtCode: row.districtCode || row.district_code,
            address: row.address,
            lng: row.lng,
            lat: row.lat,
            priceMin: row.priceMin || row.price_min,
            priceMax: row.priceMax || row.price_max,
            priceDisplay: hasPriceDisplay ? (row.priceDisplay ?? row.price_display) : undefined,
            indoor: row.indoor,
            contact: row.contact,
            isPublic: row.isPublic !== undefined ? row.isPublic : (row.is_public !== undefined ? row.is_public : true),
            courtCount: row.courtCount || row.court_count,
            floorType: row.floorType || row.floor_type,
            openHours: row.openHours || row.open_hours,
            hasLighting: row.hasLighting !== undefined ? row.hasLighting : row.has_lighting,
            hasAirConditioning: row.hasAirConditioning !== undefined ? row.hasAirConditioning : row.has_air_conditioning,
            hasParking: row.hasParking !== undefined ? row.hasParking : row.has_parking,
            hasFence: row.hasFence !== undefined ? row.hasFence : row.has_fence,
            hasRestArea: row.hasRestArea !== undefined ? row.hasRestArea : row.has_rest_area,
            hasShower: row.hasShower !== undefined ? row.hasShower : row.has_shower,
            hasLocker: row.hasLocker !== undefined ? row.hasLocker : row.has_locker,
            hasShop: row.hasShop !== undefined ? row.hasShop : row.has_shop,
            supportsWalkIn: hasSupportsWalkIn ? (row.supportsWalkIn !== undefined ? row.supportsWalkIn : row.supports_walk_in) : undefined,
            supportsFullCourt: hasSupportsFullCourt ? (row.supportsFullCourt !== undefined ? row.supportsFullCourt : row.supports_full_court) : undefined,
            walkInPriceMin: hasWalkInPriceMin ? (row.walkInPriceMin !== undefined ? row.walkInPriceMin : row.walk_in_price_min) : undefined,
            walkInPriceMax: hasWalkInPriceMax ? (row.walkInPriceMax !== undefined ? row.walkInPriceMax : row.walk_in_price_max) : undefined,
            walkInPriceDisplay: hasWalkInPriceDisplay ? (row.walkInPriceDisplay ?? row.walk_in_price_display) : undefined,
            fullCourtPriceMin: hasFullCourtPriceMin ? (row.fullCourtPriceMin !== undefined ? row.fullCourtPriceMin : row.full_court_price_min) : undefined,
            fullCourtPriceMax: hasFullCourtPriceMax ? (row.fullCourtPriceMax !== undefined ? row.fullCourtPriceMax : row.full_court_price_max) : undefined,
            fullCourtPriceDisplay: hasFullCourtPriceDisplay ? (row.fullCourtPriceDisplay ?? row.full_court_price_display) : undefined,
            requiresReservation: hasRequiresReservation ? (row.requiresReservation !== undefined ? row.requiresReservation : row.requires_reservation) : undefined,
            reservationMethod: hasReservationMethod ? (row.reservationMethod || row.reservation_method) : undefined,
            playersPerSide: hasPlayersPerSide ? (row.playersPerSide || row.players_per_side) : undefined,
          } as VenueEntity
        } else {
          // 没有需要更新的字段，直接返回原对象
          saved = venue
        }
      }
      
      console.log('✅ Venue updated successfully:', saved.id)
      
      return {
        id: String(saved.id),
        name: saved.name,
        sportType: saved.sportType,
        cityCode: saved.cityCode,
        districtCode: saved.districtCode,
        address: saved.address,
        priceMin: saved.priceMin,
        priceMax: saved.priceMax,
        priceDisplay: hasPriceDisplay ? saved.priceDisplay : undefined,
        indoor: saved.indoor ?? false,
        contact: saved.contact,
        isPublic: saved.isPublic !== undefined ? saved.isPublic : true,
        location: [saved.lng, saved.lat] as [number, number],
      }
    } catch (error) {
      console.error('❌ Error in updateVenue:', error)
      if (error instanceof Error) {
        console.error('Error name:', error.name)
        console.error('Error message:', error.message)
        console.error('Error stack:', error.stack)
      }
      throw error
    }
  }

  async listReviews(venueId: number) {
    const rows = await this.reviewRepo.find({
      where: { venue: { id: venueId } as any },
      relations: ['user'],
      order: { createdAt: 'DESC' },
      take: 20,
    })
    return {
      items: rows.map(r => ({
        id: r.id,
        rating: r.rating,
        content: r.content,
        createdAt: r.createdAt,
        user: r.user ? {
          id: r.user.id,
          nickname: r.user.nickname || (r.user.phone ? `${r.user.phone.slice(0, 3)}****${r.user.phone.slice(-4)}` : '匿名用户'),
          avatar: r.user.avatar || null,
        } : null,
      })),
    }
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
      
      // 直接使用 QueryBuilder 查询外键（表列名为 venue_id）
      let rows: any[] = []
      try {
        // 优先用 venue_id，兼容阿里云 RDS 等 snake_case 列名
        const byVenueId = await this.imageRepo
          .createQueryBuilder('img')
          .where('img.venue_id = :venueId', { venueId })
          .orderBy('img.sort', 'ASC')
          .addOrderBy('img.id', 'ASC')
          .getMany()
        if (byVenueId.length > 0) {
          rows = byVenueId
          console.log(`📸 QueryBuilder (venue_id) found ${rows.length} images`)
        }
        if (rows.length === 0) {
          const directRows = await this.imageRepo
            .createQueryBuilder('img')
            .where('img.venueId = :venueId', { venueId })
            .orderBy('img.sort', 'ASC')
            .addOrderBy('img.id', 'ASC')
            .getMany()
          rows = directRows
          console.log(`📸 QueryBuilder (venueId) found ${directRows.length} images`)
        }
      } catch (qbError) {
        console.warn('⚠️  QueryBuilder query failed, trying raw query:', qbError)
          // 如果 QueryBuilder 也失败，尝试原生 SQL 查询
          try {
            // 尝试不同的字段名格式
            const queries = [
              `SELECT * FROM venue_image WHERE venue_id = $1 ORDER BY sort ASC, id ASC`,
              `SELECT * FROM venue_image WHERE "venueId" = $1 ORDER BY sort ASC, id ASC`,
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
      console.log('📤 [Upload] 开始上传图片到 OSS...')
      console.log('📤 [Upload] OSS 服务状态检查...')
      // Vercel 代理 55s 即断开，后端需在此前完成所有 OSS 上传（约 4 个尺寸串行），单次 13s × 4 ≈ 52s
      const OSS_UPLOAD_TIMEOUT_MS = 13000
      const MAX_ATTEMPTS = 2
      const uploadWithTimeout = async (uploadUrl: string, body: Buffer, attempt = 1): Promise<{ ok: boolean; statusCode: number }> => {
        try {
          return await putToUrlWithTimeout(uploadUrl, body, OSS_UPLOAD_TIMEOUT_MS)
        } catch (e: any) {
          const code = e?.code ?? e?.cause?.code
          const isRetryable =
            e?.message?.includes('timeout') ||
            e?.message?.includes('fetch failed') ||
            e?.message?.includes('ETIMEDOUT') ||
            e?.message?.includes('Upload timeout') ||
            code === 'UND_ERR_CONNECT_TIMEOUT' ||
            code === 'UND_ERR_HEADERS_TIMEOUT' ||
            code === 'UND_ERR_SOCKET' ||
            code === 'ETIMEDOUT' ||
            code === 'ECONNRESET'
          if (isRetryable && attempt < MAX_ATTEMPTS) {
            console.warn(`⚠️ [Upload] OSS 请求超时/失败 (${code || e?.message}), 重试 (${attempt}/${MAX_ATTEMPTS})...`)
            return uploadWithTimeout(uploadUrl, body, attempt + 1)
          }
          throw e
        }
      }

      const uploadResults: Array<{ size: string; key: string; url: string; sizeBytes: number }> = []
      const order = ['thumbnail', 'medium', 'large', 'original'].filter((s) => processedImages[s as keyof typeof processedImages])
      for (const size of order) {
        const imageBuffer = processedImages[size as keyof typeof processedImages]
        if (!imageBuffer) continue
        const key = keys[size as keyof typeof keys]
        console.log(`📤 [Upload] Generating presigned URL for ${size} size, key: ${key}`)
        try {
          const { uploadUrl, publicUrl } = await this.ossService.generatePresignedUrl('image/jpeg', 'jpg', key)
          console.log(`📤 [Upload] Uploading ${size} size to OSS, key: ${key}, uploadUrl: ${uploadUrl.substring(0, 100)}...`)
          const result = await uploadWithTimeout(uploadUrl, imageBuffer)
          if (!result.ok) {
            console.error(`❌ [Upload] Failed to upload ${size} size:`, result.statusCode)
            throw new Error(`上传${size}尺寸失败: ${result.statusCode}`)
          }
          const finalUrl = publicUrl || `https://${process.env.OSS_BUCKET}.${process.env.OSS_REGION}.aliyuncs.com/${key}`
          console.log(`✅ [Upload] Successfully uploaded ${size} size, key: ${key}, URL: ${finalUrl}`)
          uploadResults.push({ size, key, url: finalUrl, sizeBytes: imageBuffer.length })
        } catch (error) {
          console.error(`❌ [Upload] Error uploading ${size} size:`, error)
          throw error
        }
      }
      
      // 3. 保存到数据库（以large尺寸为主图）
      const mainImage = uploadResults.find(r => r.size === 'large')
      if (!mainImage) throw new Error('主图上传失败')
      
      const venue = await this.repo.findOne({ where: { id: venueId } })
      if (!venue) {
        throw new Error(`场地不存在（id=${venueId}）。请确认该场地在当前数据库中存在。`)
      }
      const user = await this.userRepo.findOne({ where: { id: userId } })
      if (!user) {
        throw new Error(
          `当前登录用户（id=${userId}）在该数据库中不存在，无法保存图片。请在前端退出登录后，用「注册」或「登录」重新登录（确保前端请求的是当前后端），再试上传。`
        )
      }
      
      const image = new VenueImageEntity()
      image.venue = venue as any
      image.user = user
      image.userId = userId
      image.url = mainImage.url
      image.sort = 0
      
      console.log(`💾 Saving processed image to database for venue ${venueId}...`)
      let saved: VenueImageEntity
      try {
        saved = await this.imageRepo.save(image)
      } catch (saveErr: any) {
        const msg = saveErr?.message || ''
        if (msg.includes('foreign key') || msg.includes('violates foreign key') || saveErr?.code === '23503') {
          throw new Error(
            '保存图片失败：当前场地或登录用户在该数据库中不存在。请确认：1) 场地详情页的场地 ID 与数据库一致；2) 当前登录用户已在该库的 user 表中。'
          )
        }
        throw saveErr
      }
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
      
      // 使用 QueryBuilder 直接查询（优先 venueId，兼容驼峰表）
      let image = await this.imageRepo
        .createQueryBuilder('img')
        .where('img.id = :imageId', { imageId })
        .andWhere('img.venueId = :venueId', { venueId })
        .getOne()
      if (!image) {
        try {
          image = await this.imageRepo
            .createQueryBuilder('img')
            .where('img.id = :imageId', { imageId })
            .andWhere('img.venue_id = :venueId', { venueId })
            .getOne()
        } catch {
          // 表无 venue_id 列时忽略
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


