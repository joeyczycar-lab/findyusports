"use client"
import { Suspense, useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import FiltersBar, { Filters } from '@/components/FiltersBar'

// 强制动态渲染，避免静态生成问题
export const dynamic = 'force-dynamic'

function MapPageContent() {
  const searchParams = useSearchParams()
  const [items, setItems] = useState<Array<any>>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [filters, setFilters] = useState<Filters>({})
  const [sortBy, setSortBy] = useState<'city' | 'popularity' | 'name'>('popularity')
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(0)
  const pageSize = 20
  const keyword = searchParams?.get('keyword') || ''

  function toQuery(filters: Filters) {
    const p = new URLSearchParams()
    // 城市筛选：如果选择了城市，使用 cityCode 参数
    if (filters.city) p.set('cityCode', filters.city)
    if (filters.sport) p.set('sport', filters.sport)
    if (typeof filters.minPrice === 'number') p.set('minPrice', String(filters.minPrice))
    if (typeof filters.maxPrice === 'number') p.set('maxPrice', String(filters.maxPrice))
    if (typeof filters.indoor === 'boolean') p.set('indoor', String(filters.indoor))
    // 添加关键词搜索参数
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

  return (
    <main className="container-page py-12 bg-white">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-heading font-bold mb-2 tracking-tight">全部场地</h1>
          <p className="text-body text-textSecondary">
            共 {total} 个场地 · 第 {page} / {totalPages} 页
          </p>
        </div>
        <select
          value={sortBy}
          onChange={(e) => {
            setSortBy(e.target.value as 'city' | 'popularity' | 'name')
            setPage(1) // 重置到第一页
          }}
          className="px-4 py-2 border border-gray-300 rounded text-sm bg-white"
        >
          <option value="popularity">🔥 按热度</option>
          <option value="city">📍 按地区</option>
          <option value="name">🔤 按名称</option>
        </select>
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
          <div className="text-body mb-4">没有找到场地</div>
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
                          fallback.textContent = venue.sportType === 'basketball' ? '🏀' : '⚽'
                          parent.appendChild(fallback)
                        }
                      }}
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-textMuted text-4xl">
                      {venue.sportType === 'basketball' ? '🏀' : '⚽'}
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
                          {venue.sportType === 'basketball' ? '🏀 篮球' : '⚽ 足球'}
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
                      {venue.price !== undefined && venue.price > 0 && (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">¥{venue.price.toFixed(2)}/小时</span>
                        </div>
                      )}
                      {venue.price === 0 && (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">免费</span>
                        </div>
                      )}
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
