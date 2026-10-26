"use client"
import { Suspense, useEffect, useRef, useState } from 'react'
import { usePathname, useRouter, useSearchParams } from 'next/navigation'
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

const SORT_VALUES = ['city', 'popularity', 'name', 'newest'] as const
type SortByValue = (typeof SORT_VALUES)[number]

// 上线闸：仅展示「有具体地址 + 有场地图片」的场馆（电话留作后续补全项）
function isPublicReady(v: any): boolean {
  return !!v && typeof v.address === 'string' && v.address.trim().length >= 4 && !!v.firstImage
}

function MapPageContent() {
  const searchParams = useSearchParams()
  const pathname = usePathname()
  const router = useRouter()
  const [items, setItems] = useState<Array<any>>([])
  const [totalLoaded, setTotalLoaded] = useState(0)
  const [loading, setLoading] = useState(true)
  const [loadingMore, setLoadingMore] = useState(false)
  const [error, setError] = useState<string | null>(null)
  // 默认展示全部（篮球+足球），用户可通过顶部按钮切换
  const [filters, setFilters] = useState<Filters>({ sport: undefined })
  const [sortBy, setSortBy] = useState<SortByValue>('popularity')
  const [visible, setVisible] = useState(20)
  const [allLoaded, setAllLoaded] = useState(false)

  // 已加载的合格场馆缓冲（有地址+有图），跨"加载更多"累积
  const loadedRef = useRef<Array<any>>([])
  const rawPageRef = useRef(1)
  const doneRef = useRef(false)
  const loadingRef = useRef(false)

  // 从 URL 取 keyword：首帧从 window 读（整页跳转后 useSearchParams 可能滞后），再用 effect 同步
  const paramsKeyword = (searchParams?.get('keyword') || '').trim()
  const [urlKeyword, setUrlKeyword] = useState(() =>
    typeof window !== 'undefined' ? getKeywordFromUrl() : ''
  )
  const keyword = (paramsKeyword || urlKeyword).trim()
  // 支持 URL 参数 sport、cityCode，便于直达「上海足球」等
  const urlSport = searchParams?.get('sport') as 'basketball' | 'football' | null
  const urlCity = searchParams?.get('cityCode') || undefined
  const urlSortBy = searchParams?.get('sortBy') || undefined

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
    if (urlSortBy && (SORT_VALUES as readonly string[]).includes(urlSortBy)) {
      setSortBy(urlSortBy as SortByValue)
    }
  }, [urlSport, urlCity, urlSortBy])

  function toQuery(f: Filters, sb: SortByValue, kw: string, page: number, pageSize: number) {
    const p = new URLSearchParams()
    if (f.city) p.set('cityCode', f.city)
    if (f.districtCode) p.set('districtCode', f.districtCode)
    if (f.sport) p.set('sport', f.sport)
    // 价格：免费 = minPrice=0&maxPrice=0，收费 = minPrice=1
    if (f.priceType === 'free') {
      p.set('minPrice', '0')
      p.set('maxPrice', '0')
    } else if (f.priceType === 'paid') {
      p.set('minPrice', '1')
    }
    if (typeof f.indoor === 'boolean') p.set('indoor', String(f.indoor))
    if (kw.trim()) p.set('keyword', kw.trim())
    p.set('sortBy', sb)
    p.set('page', String(page))
    p.set('pageSize', String(pageSize))
    return p
  }

  // 拉取合格场馆直到缓冲不少于 target 条（或已扫完所有页）
  async function loadMore(target: number) {
    if (loadingRef.current || doneRef.current) return
    loadingRef.current = true
    setLoadingMore(true)
    if (loadedRef.current.length === 0) setLoading(true)

    const acc: Array<any> = []
    let page = rawPageRef.current
    let guard = 0
    try {
      while (loadedRef.current.length + acc.length < target && !doneRef.current && guard < 700) {
        const qs = toQuery(filters, sortBy, keyword, page, 100).toString()
        const json = await fetchJson(`/venues${qs ? `?${qs}` : ''}`)
        if (json.error) throw new Error(json.error.message || '获取场地列表失败')
        const pageItems: Array<any> = json.items || []
        for (const v of pageItems) {
          if (isPublicReady(v)) acc.push(v)
        }
        if (pageItems.length < 100) doneRef.current = true
        page++
        guard++
      }
    } catch (err: any) {
      setError(err.message || '加载场地失败')
    }

    rawPageRef.current = page
    loadedRef.current = [...loadedRef.current, ...acc]
    setTotalLoaded(loadedRef.current.length)
    setItems(loadedRef.current.slice(0, Math.min(target, loadedRef.current.length)))
    if (doneRef.current) setAllLoaded(true)
    setLoading(false)
    setLoadingMore(false)
    loadingRef.current = false
  }

  // 筛选/排序/关键词变化时重置并重新加载
  function resetAndLoad() {
    loadedRef.current = []
    rawPageRef.current = 1
    doneRef.current = false
    setItems([])
    setTotalLoaded(0)
    setAllLoaded(false)
    setError(null)
    setVisible(20)
    loadMore(20)
  }

  useEffect(() => {
    resetAndLoad()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sortBy, filters, keyword])

  const currentSport = filters.sport === undefined ? 'all' : filters.sport

  function setSortByWithUrl(next: SortByValue) {
    setSortBy(next)
    const params = new URLSearchParams(searchParams?.toString() || '')
    if (next === 'popularity') {
      params.delete('sortBy')
    } else {
      params.set('sortBy', next)
    }
    const qs = params.toString()
    router.replace(qs ? `${pathname}?${qs}` : pathname)
  }

  function handleLoadMore() {
    const next = visible + 20
    setVisible(next)
    loadMore(next)
  }

  return (
    <main className="container-page py-12 bg-white">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-heading font-bold mb-2 tracking-tight">
            {keyword ? `搜索「${keyword}」` : '全部场地'}
          </h1>
          <p className="text-body text-textSecondary">
            {allLoaded
              ? `共 ${totalLoaded} 个场地`
              : `已加载 ${totalLoaded} 个场地`}
            {' · '}仅展示含具体地址与场地图片的场馆
          </p>
        </div>
        <select
          value={sortBy}
          onChange={(e) => {
            setSortByWithUrl(e.target.value as SortByValue)
          }}
          className="px-4 py-2 border border-gray-300 rounded text-sm bg-white"
          aria-label="场地排序方式"
        >
          <option value="popularity">🔥 按热度</option>
          <option value="city">📍 按地区</option>
          <option value="name">🔤 按名称</option>
          <option value="newest">📋 按添加顺序（最新在前）</option>
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

      {!loading && !error && items.length === 0 && allLoaded && (
        <div className="text-center py-16 text-textSecondary">
          <div className="text-4xl mb-4">📭</div>
          <div className="text-body mb-4">
            {keyword ? `没有找到与「${keyword}」相关的场地` : '没有找到符合条件的场地'}
          </div>
          <p className="text-sm mb-6">
            目前仅展示「含具体地址 + 场地图片」的场馆，其余正在完善中。
          </p>
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
            显示 {items.length} 个场地
            {allLoaded ? `（共 ${totalLoaded} 个）` : '（继续加载更多）'}
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

          {/* 加载更多 */}
          {!allLoaded && (
            <div className="flex items-center justify-center">
              <button
                onClick={handleLoadMore}
                disabled={loadingMore}
                className="px-6 py-3 bg-black text-white rounded hover:bg-gray-900 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loadingMore ? '加载中...' : '加载更多场地'}
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
