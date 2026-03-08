"use client"
import { Suspense, useEffect, useRef, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import FiltersBar, { Filters } from '@/components/FiltersBar'

// 强制动态渲染，避免静态生成问题
export const dynamic = 'force-dynamic'

// 从当前 URL 读取 keyword（整页刷新时 useSearchParams 可能尚未就绪）
function getKeywordFromUrl(): string {
  if (typeof window === 'undefined') return ''
  return (new URLSearchParams(window.location.search).get('keyword') || '').trim()
}

function MapPageContent() {
  const searchParams = useSearchParams()
  const [items, setItems] = useState<Array<any>>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [filters, setFilters] = useState<Filters>({ sport: 'basketball' })
  const [sortBy, setSortBy] = useState<'city' | 'popularity' | 'name' | 'newest'>('popularity')
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(0)
  const pageSize = 20
  // 从 URL 取 keyword：首帧从 window 读（整页跳转后 useSearchParams 可能滞后），再用 effect 同步
  const paramsKeyword = (searchParams?.get('keyword') || '').trim()
  const [urlKeyword, setUrlKeyword] = useState(() =>
    typeof window !== 'undefined' ? getKeywordFromUrl() : ''
  )
  const keyword = (paramsKeyword || urlKeyword).trim()
  // 支持 URL 参数 sport、cityCode，便于直达「上海足球」等
  const urlSport = searchParams?.get('sport') as 'basketball' | 'football' | null
  const urlCity = searchParams?.get('cityCode') || undefined

  useEffect(() => {
    const fromUrl = getKeywordFromUrl()
    if (fromUrl) setUrlKeyword(fromUrl)
    if (paramsKeyword) setUrlKeyword(paramsKeyword)
  }, [paramsKeyword])

  // 有搜索关键词时默认显示「全部」（篮球+足球），并同步筛选状态
  useEffect(() => {
    if (keyword.trim()) {
      setFilters((prev) => ({ ...prev, sport: undefined }))
    }
  }, [keyword])

  // 仅首次加载时用 URL 的 sport、cityCode 初始化筛选（如 /map?sport=football&cityCode=310000 直达上海足球）
  const urlSynced = useRef(false)
  useEffect(() => {
    if (urlSynced.current) return
    urlSynced.current = true
    if (urlSport === 'football' || urlSport === 'basketball' || urlCity) {
      setFilters((prev) => ({
        ...prev,
        ...(urlSport === 'football' || urlSport === 'basketball' ? { sport: urlSport } : {}),
        ...(urlCity ? { city: urlCity } : {}),
      }))
    }
  }, [urlSport, urlCity])

  function toQuery(filters: Filters) {
    const p = new URLSearchParams()
    if (filters.city) p.set('cityCode', filters.city)
    if (filters.districtCode) p.set('districtCode', filters.districtCode)
    if (filters.sport) p.set('sport', filters.sport)
    // 价格：免费 = minPrice=0&maxPrice=0，收费 = minPrice=1
    if (filters.priceType === 'free') {
      p.set('minPrice', '0')
      p.set('maxPrice', '0')
    } else if (filters.priceType === 'paid') {
      p.set('minPrice', '1')
    }
    if (typeof filters.indoor === 'boolean') p.set('indoor', String(filters.indoor))
    if (keyword.trim()) p.set('keyword', keyword.trim())
    // 添加排序参数和分页参数，不传坐标参数
    p.set('sortBy', sortBy)
    p.set('page', String(page))
    p.set('pageSize', String(pageSize))
    return p
  }

  async function fetchVenues() {
    try {
      setLoading(true)
      setError(null)
      const p = toQuery(filters)
      const qs = p.toString()
      console.log('🔍 [MapPage] Fetching venues with query:', qs)
      const json = await fetchJson(`/venues${qs ? `?${qs}` : ''}`)
      console.log('✅ [MapPage] Received response:', { itemsCount: json.items?.length || 0, total: json.total || 0, hasError: !!json.error })
      
      if (json.error) {
        console.error('❌ [MapPage] API returned error:', json.error)
        throw new Error(json.error.message || '获取场地列表失败')
      }
      
      setItems(json.items || [])
      setTotal(json.total || 0)
    } catch (err: any) {
      console.error('❌ [MapPage] Error fetching venues:', err)
      setError(err.message || '加载场地失败')
      setItems([])
      setTotal(0)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => { 
    setPage(1) // 筛选条件变化时重置到第一页
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sortBy, filters, keyword])
  
  useEffect(() => { 
    fetchVenues() 
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, sortBy, filters, keyword])
  
  const totalPages = Math.ceil(total / pageSize) || 1
  const currentSport = filters.sport === undefined ? 'all' : filters.sport

  return (
    <main className="container-page py-12 bg-white">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-heading font-bold mb-2 tracking-tight">
            {keyword ? `搜索「${keyword}」` : '全部场地'}
          </h1>
          <p className="text-body text-textSecondary">
            {keyword ? `共找到 ${total} 个相关场地` : `共 ${total} 个场地`} · 第 {page} / {totalPages} 页
          </p>
        </div>
        <select
          value={sortBy}
          onChange={(e) => {
            setSortBy(e.target.value as 'city' | 'popularity' | 'name' | 'newest')
            setPage(1) // 重置到第一页
          }}
          className="px-4 py-2 border border-gray-300 rounded text-sm bg-white"
        >
          <option value="popularity">🔥 按热度</option>
          <option value="city">📍 按地区</option>
          <option value="name">🔤 按名称</option>
          <option value="newest">🕐 按添加时间</option>
        </select>
      </div>
      {/* 运动类型：全部 / 篮球 / 足球；有搜索关键词时默认「全部」同时显示篮球与足球 */}
      <div className="mb-4 flex items-center gap-3">
        <span className="text-sm text-textSecondary">按运动类型：</span>
        <div className="inline-flex rounded-full bg-gray-100 p-1">
          <button
            type="button"
            className={`px-4 py-1 text-sm font-medium rounded-full transition-colors ${
              currentSport === 'all'
                ? 'bg-black text-white'
                : 'text-gray-700 hover:bg-gray-200'
            }`}
            onClick={() => {
              setFilters((prev) => ({ ...prev, sport: undefined }))
              setPage(1)
            }}
          >
            全部
          </button>
          <button
            type="button"
            className={`px-4 py-1 text-sm font-medium rounded-full transition-colors ${
              currentSport === 'basketball'
                ? 'bg-black text-white'
                : 'text-gray-700 hover:bg-gray-200'
            }`}
            onClick={() => {
              setFilters((prev) => ({ ...prev, sport: 'basketball' }))
              setPage(1)
            }}
          >
            篮球场地
          </button>
          <button
            type="button"
            className={`px-4 py-1 text-sm font-medium rounded-full transition-colors ${
              currentSport === 'football'
                ? 'bg-black text-white'
                : 'text-gray-700 hover:bg-gray-200'
            }`}
            onClick={() => {
              setFilters((prev) => ({ ...prev, sport: 'football' }))
              setPage(1)
            }}
          >
            足球场地
          </button>
        </div>
      </div>
      <FiltersBar value={filters} onChange={(f) => setFilters(f)} />

      {loading && (
        <div className="text-center py-16 text-textSecondary">
          加载中...
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-6">
          ❌ {error}
        </div>
      )}

      {!loading && !error && items.length === 0 && (
        <div className="text-center py-16 text-textSecondary">
          <div className="text-4xl mb-4">📭</div>
          <div className="text-body mb-4">
            {keyword ? `没有找到与「${keyword}」相关的场地` : '没有找到场地'}
          </div>
          <Link 
            href="/admin/add-venue" 
            className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors inline-block"
            style={{ borderRadius: '4px' }}
          >
            ➕ 添加场地
          </Link>
        </div>
      )}

      {!loading && !error && items.length > 0 && (
        <>
          <div className="mb-4 text-sm text-textSecondary">
            显示 {items.length} 个场地（共 {total} 个）
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            {items.map((venue) => (
              <Link
                key={venue.id}
                href={`/venues/${venue.id}`}
                className="card-nike hover:shadow-lg transition-shadow overflow-hidden"
              >
                {/* 图片区域 */}
                <div className="h-48 bg-gray-100 relative overflow-hidden">
                  {venue.firstImage ? (
                    <img 
                      src={venue.firstImage} 
                      alt={venue.name}
                      className="w-full h-full object-cover"
                      loading="lazy"
                      onError={(e) => {
                        const target = e.target as HTMLImageElement
                        target.style.display = 'none'
                        const parent = target.parentElement
                        if (parent && !parent.querySelector('.fallback-icon')) {
                          const fallback = document.createElement('div')
                          fallback.className = 'fallback-icon w-full h-full flex items-center justify-center text-textMuted text-4xl absolute inset-0'
                          fallback.textContent = venue.sportType === 'basketball' ? '⚽' : '⚽'
                          parent.appendChild(fallback)
                        }
                      }}
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-textMuted text-4xl">
                      {venue.sportType === 'basketball' ? '⚽' : '⚽'}
                    </div>
                  )}
                </div>
                
                {/* 内容区域 */}
                <div className="p-6">
                  <div className="flex items-start justify-between mb-3">
                    <div className="flex-1">
                      <h3 className="font-bold text-heading-sm mb-2 line-clamp-2">
                        {venue.name}
                      </h3>
                      <div className="flex items-center gap-2 mb-2">
                        <span className="text-xs px-2 py-1 bg-gray-100 rounded uppercase">
                          {venue.sportType === 'basketball' ? '⚽ 篮球' : '⚽ 足球'}
                        </span>
                        {venue.indoor && (
                          <span className="text-xs px-2 py-1 bg-blue-100 text-blue-700 rounded">
                            室内
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="text-body-sm text-textSecondary space-y-1">
                    {venue.address && (
                      <div className="flex items-center gap-2">
                        <span>📍</span>
                        <span className="text-xs line-clamp-1">{venue.address}</span>
                      </div>
                    )}
                    {venue.contact && (
                      <div className="flex items-center gap-2">
                        <span>📞</span>
                        <span className="text-xs line-clamp-1">{venue.contact}</span>
                      </div>
                    )}
                    <div className="flex items-center gap-4">
                      {(venue as any).priceDisplay?.trim() ? (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">{(venue as any).priceDisplay}</span>
                        </div>
                      ) : venue.price !== undefined && venue.price > 0 ? (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">¥{venue.price.toFixed(2)}/小时</span>
                        </div>
                      ) : venue.price === 0 ? (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">免费</span>
                        </div>
                      ) : null}
                      {venue.reviewCount > 0 && (
                        <div className="flex items-center gap-1">
                          <span>⭐</span>
                          <span className="text-xs">{venue.avgRating?.toFixed(1) || 0} ({venue.reviewCount})</span>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>

          {/* 分页 */}
          {totalPages > 1 && (
            <div className="flex items-center justify-center gap-4">
              <button
                onClick={() => setPage(p => Math.max(1, p - 1))}
                disabled={page === 1}
                className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                上一页
              </button>
              
              <span className="text-body text-textSecondary">
                第 {page} / {totalPages} 页
              </span>
              
              <button
                onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                disabled={page === totalPages}
                className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                下一页
              </button>
            </div>
          )}
        </>
      )}
    </main>
  )
}

export default function MapPage() {
  return (
    <Suspense fallback={<div className="container-page py-8">加载中...</div>}>
      <MapPageContent />
    </Suspense>
  )
}
