"use client"
import { Suspense, useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import FiltersBar, { Filters } from '@/components/FiltersBar'

// 强制动态渲染，避免静态生成问题
export const dynamic = 'force-dynamic'

function MapPageContent() {
  const [items, setItems] = useState<Array<any>>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [filters, setFilters] = useState<Filters>({})
  const [sortBy, setSortBy] = useState<'city' | 'popularity' | 'name'>('popularity')
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(0)
  const pageSize = 20
  const searchParams = useSearchParams()


  function toQuery(filters: Filters) {
    const p = new URLSearchParams()
    // 城市筛选：如果选择了城市，使用 cityCode 参数
    if (filters.city) p.set('cityCode', filters.city)
    if (filters.sport) p.set('sport', filters.sport)
    if (typeof filters.minPrice === 'number') p.set('minPrice', String(filters.minPrice))
    if (typeof filters.maxPrice === 'number') p.set('maxPrice', String(filters.maxPrice))
    if (typeof filters.indoor === 'boolean') p.set('indoor', String(filters.indoor))
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
      const json = await fetchJson(`/venues${qs ? `?${qs}` : ''}`)
      
      if (json.error) {
        throw new Error(json.error.message || '获取场地列表失败')
      }
      
      setItems(json.items || [])
      setTotal(json.total || 0)
    } catch (err: any) {
      setError(err.message || '加载场地失败')
      setItems([])
      setTotal(0)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => { 
    setPage(1) // 筛选条件变化时重置到第一页
    fetchVenues() 
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sortBy, filters])
  
  useEffect(() => { 
    fetchVenues() 
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page])
  
  const totalPages = Math.ceil(total / pageSize) || 1
  return (
    <main className="container-page py-12 bg-white">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-heading font-bold tracking-tight">地图探索</h1>
        <select
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value as 'city' | 'popularity' | 'name')}
          className="px-4 py-2 border border-gray-300 rounded text-sm bg-white"
        >
          <option value="popularity">🔥 按热度</option>
          <option value="city">📍 按地区</option>
          <option value="name">🔤 按名称</option>
        </select>
      </div>
      <FiltersBar value={filters} onChange={(f) => setFilters(f)} />
      <div className="flex items-center justify-between mb-6 gap-3">
        <div className="flex items-center gap-6 text-caption text-textSecondary uppercase tracking-wide">
          <div className="flex items-center gap-2">
            <span className="whitespace-nowrap">节流 {throttleMs}ms</span>
            <input
              type="range"
              min={0}
              max={2000}
              step={50}
              value={throttleMs}
              onChange={(e)=>onChangeThrottle(Math.max(0, Math.min(2000, Number(e.target.value)||0)))}
              className="w-44 accent-black"
            />
          </div>
          <div className="flex items-center gap-2">
            <span className="whitespace-nowrap">抑制 {suppressMs}ms</span>
            <input
              type="range"
              min={0}
              max={3000}
              step={50}
              value={suppressMs}
              onChange={(e)=>onChangeSuppress(Math.max(0, Math.min(3000, Number(e.target.value)||0)))}
              className="w-44 accent-black"
            />
          </div>
        </div>
        <label className="flex items-center gap-2 text-body-sm uppercase tracking-wide">
          <input type="checkbox" checked={followEnabled} onChange={(e)=>setFollowEnabled(e.target.checked)} className="accent-black" /> 跟随滚动
        </label>
      </div>

      <div className="hidden lg:grid grid-cols-[360px_1fr] gap-8">
        <div ref={desktopContainerRef} onScroll={onDesktopScroll} className="space-y-4 overflow-y-auto max-h-[600px] pr-2">
          {items.map((it) => (
            <div
              key={it.id}
              className={`card-nike p-4 cursor-pointer ${activeId===it.id? 'border-black border-2' : ''}`}
              onClick={() => setActiveId(it.id)}
              onMouseEnter={() => setActiveId(it.id)}
              ref={(el) => { desktopItemRefs.current[it.id] = el }}
            >
              <a href={`/venues/${it.id}`} className="font-bold text-heading-sm mb-2 block hover:underline">{it.name}</a>
              <div className="text-body-sm text-textSecondary space-y-1">
                {it.address && (
                  <div className="text-xs">📍 {it.address}</div>
                )}
                <div className="flex items-center gap-3 text-xs">
                  {it.price !== undefined && it.price > 0 && (
                    <span>💰 ¥{it.price}/小时</span>
                  )}
                  {it.price === 0 && (
                    <span>💰 免费</span>
                  )}
                  {it.reviewCount > 0 && (
                    <span>⭐ {it.avgRating?.toFixed(1) || 0} ({it.reviewCount})</span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
        <MapView
          className="h-[600px] w-full border border-border"
          markers={markers}
          activeId={debouncedActiveId}
          onMarkerClick={(id) => setActiveId(id)}
        />
      </div>

      <div className="lg:hidden">
        <div className="flex items-center justify-between mb-4 gap-3">
          <div className="flex items-center gap-6 text-caption text-textSecondary uppercase tracking-wide w-full">
            <div className="flex items-center gap-2 flex-1">
              <span className="whitespace-nowrap">节流 {throttleMs}ms</span>
              <input
                type="range"
                min={0}
                max={2000}
                step={50}
                value={throttleMs}
                onChange={(e)=>onChangeThrottle(Math.max(0, Math.min(2000, Number(e.target.value)||0)))}
                className="w-full accent-black"
              />
            </div>
            <div className="flex items-center gap-2 flex-1">
              <span className="whitespace-nowrap">抑制 {suppressMs}ms</span>
              <input
                type="range"
                min={0}
                max={3000}
                step={50}
                value={suppressMs}
                onChange={(e)=>onChangeSuppress(Math.max(0, Math.min(3000, Number(e.target.value)||0)))}
                className="w-full accent-black"
              />
            </div>
          </div>
          <label className="flex items-center gap-2 text-body-sm uppercase tracking-wide">
            <input type="checkbox" checked={followEnabled} onChange={(e)=>setFollowEnabled(e.target.checked)} className="accent-black" /> 跟随滚动
          </label>
        </div>
        <MapView
          className="h-[70vh] w-full border border-border"
          markers={markers}
          activeId={debouncedActiveId}
          onMarkerClick={(id) => { setActiveId(id); setDrawerOpen(true) }}
        />
        <button className="btn-secondary w-full mt-4" onClick={() => setDrawerOpen(true)} style={{ borderRadius: '4px' }}>打开列表</button>
      </div>

      <MobileDrawer open={drawerOpen} onClose={() => setDrawerOpen(false)}>
        <div ref={mobileContainerRef} onScroll={onMobileScroll} className="space-y-4 max-h-[50vh] overflow-y-auto pr-2">
          {items.map((it) => (
            <div
              key={it.id}
              className={`card-nike p-4 cursor-pointer ${activeId===it.id? 'border-black border-2' : ''}`}
              onClick={() => setActiveId(it.id)}
              onMouseEnter={() => setActiveId(it.id)}
              ref={(el) => { mobileItemRefs.current[it.id] = el }}
            >
              <a href={`/venues/${it.id}`} className="font-bold text-heading-sm mb-2 block hover:underline">{it.name}</a>
              <div className="text-body-sm text-textSecondary space-y-1">
                {it.address && (
                  <div className="text-xs">📍 {it.address}</div>
                )}
                <div className="flex items-center gap-3 text-xs">
                  {it.price !== undefined && it.price > 0 && (
                    <span>💰 ¥{it.price}/小时</span>
                  )}
                  {it.price === 0 && (
                    <span>💰 免费</span>
                  )}
                  {it.reviewCount > 0 && (
                    <span>⭐ {it.avgRating?.toFixed(1) || 0} ({it.reviewCount})</span>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </MobileDrawer>
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
