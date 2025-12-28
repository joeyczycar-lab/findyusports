"use client"
import { Suspense, useEffect, useMemo, useRef, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import MapView from '@/components/MapView'
import MobileDrawer from '@/components/MobileDrawer'
import { fetchJson } from '@/lib/api'
import FiltersBar, { Filters } from '@/components/FiltersBar'
import { useDebouncedValue } from '@/lib/hooks'

// 强制动态渲染，避免静态生成问题
export const dynamic = 'force-dynamic'

function MapPageContent() {
  const [drawerOpen, setDrawerOpen] = useState(false)
  const [lastQuery, setLastQuery] = useState<any>(null)
  const [items, setItems] = useState<Array<any>>([])
  const [activeId, setActiveId] = useState<string | null>(null)
  const [filters, setFilters] = useState<Filters>({})
  const [sortBy, setSortBy] = useState<'city' | 'popularity' | 'name'>('popularity')
  const debouncedActiveId = useDebouncedValue(activeId, 120)
  const desktopItemRefs = useRef<Record<string, HTMLDivElement | null>>({})
  const mobileItemRefs = useRef<Record<string, HTMLDivElement | null>>({})
  const desktopContainerRef = useRef<HTMLDivElement | null>(null)
  const mobileContainerRef = useRef<HTMLDivElement | null>(null)
  const userScrollDesktopRef = useRef(false)
  const userScrollMobileRef = useRef(false)
  const userScrollResetTimerRef = useRef<number | null>(null)
  const lastAutoScrollAtRef = useRef<number>(0)
  const searchParams = useSearchParams()
  const throttleMsRef = useRef<number>(Number(process.env.NEXT_PUBLIC_SCROLL_THROTTLE_MS || 300))
  const suppressMsRef = useRef<number>(Number(process.env.NEXT_PUBLIC_SCROLL_SUPPRESS_MS || 800))
  const [throttleMs, setThrottleMs] = useState<number>(throttleMsRef.current)
  const [suppressMs, setSuppressMs] = useState<number>(suppressMsRef.current)
  const [followEnabled, setFollowEnabled] = useState(true)

  // 初始化阈值与跟随开关（支持 URL 参数覆盖）
  useEffect(() => {
    const t = Number(searchParams.get('scrollThrottleMs') || '')
    const s = Number(searchParams.get('userSuppressMs') || '')
    const f = searchParams.get('follow')
    // 本地存储
    const lsFollow = typeof window !== 'undefined' ? window.localStorage.getItem('map_follow') : null
    const lsT = typeof window !== 'undefined' ? window.localStorage.getItem('map_scrollThrottleMs') : null
    const lsS = typeof window !== 'undefined' ? window.localStorage.getItem('map_scrollSuppressMs') : null
    if (!Number.isNaN(t) && t > 0) throttleMsRef.current = t
    else if (lsT && !Number.isNaN(Number(lsT))) throttleMsRef.current = Number(lsT)
    if (!Number.isNaN(s) && s > 0) suppressMsRef.current = s
    else if (lsS && !Number.isNaN(Number(lsS))) suppressMsRef.current = Number(lsS)
    setThrottleMs(throttleMsRef.current)
    setSuppressMs(suppressMsRef.current)
    if (f === '0') setFollowEnabled(false)
    else if (f === '1') setFollowEnabled(true)
    else if (lsFollow !== null) setFollowEnabled(lsFollow === '1')
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  // 持久化跟随开关
  useEffect(() => {
    if (typeof window === 'undefined') return
    try { window.localStorage.setItem('map_follow', followEnabled ? '1' : '0') } catch {}
  }, [followEnabled])

  function onChangeThrottle(next: number) {
    throttleMsRef.current = next
    setThrottleMs(next)
    try { window.localStorage.setItem('map_scrollThrottleMs', String(next)) } catch {}
  }

  function onChangeSuppress(next: number) {
    suppressMsRef.current = next
    setSuppressMs(next)
    try { window.localStorage.setItem('map_scrollSuppressMs', String(next)) } catch {}
  }

  const markers = useMemo(() => items.map((it) => ({
    id: it.id,
    name: it.name,
    position: it.location as [number, number],
    active: it.id === activeId,
  })), [items, activeId])

  function toQuery(filters: Filters) {
    const p = new URLSearchParams()
    if (filters.city) p.set('city', filters.city)
    if (filters.sport) p.set('sport', filters.sport)
    if (typeof filters.minPrice === 'number') p.set('minPrice', String(filters.minPrice))
    if (typeof filters.maxPrice === 'number') p.set('maxPrice', String(filters.maxPrice))
    if (typeof filters.indoor === 'boolean') p.set('indoor', String(filters.indoor))
    // 添加排序参数，不传坐标参数
    p.set('sortBy', sortBy)
    return p
  }

  async function fetchVenues() {
    const p = toQuery(filters)
    const qs = p.toString()
    const json = await fetchJson(`/venues${qs ? `?${qs}` : ''}`)
    setItems(json.items || [])
    if (json.items && json.items.length > 0) {
      setActiveId(json.items[0].id)
    }
  }

  useEffect(() => { fetchVenues() }, [])
  useEffect(() => { fetchVenues() }, [sortBy, filters])
  useEffect(() => {
    if (items.length > 0 && !activeId) setActiveId(items[0].id)
  }, [items, activeId])

  // 当激活项变化时，将对应列表项滚动到可视区域（桌面与移动）
  useEffect(() => {
    if (!debouncedActiveId) return
    if (!followEnabled) return
    const now = Date.now()
    if (now - lastAutoScrollAtRef.current < throttleMsRef.current) return
    const elDesktop = desktopItemRefs.current[debouncedActiveId]
    if (elDesktop && !userScrollDesktopRef.current) {
      elDesktop.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
    const elMobile = mobileItemRefs.current[debouncedActiveId]
    if (elMobile && !userScrollMobileRef.current) {
      elMobile.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
    lastAutoScrollAtRef.current = now
  }, [debouncedActiveId, followEnabled])

  function onDesktopScroll() {
    userScrollDesktopRef.current = true
    if (userScrollResetTimerRef.current) window.clearTimeout(userScrollResetTimerRef.current)
    userScrollResetTimerRef.current = window.setTimeout(() => {
      userScrollDesktopRef.current = false
    }, suppressMsRef.current)
  }

  function onMobileScroll() {
    userScrollMobileRef.current = true
    if (userScrollResetTimerRef.current) window.clearTimeout(userScrollResetTimerRef.current)
    userScrollResetTimerRef.current = window.setTimeout(() => {
      userScrollMobileRef.current = false
    }, suppressMsRef.current)
  }
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
          onSearchHere={(payload) => { setLastQuery(payload); fetchVenues() }}
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
          onSearchHere={(payload) => { setLastQuery(payload); fetchVenues(); setDrawerOpen(true); }}
        />
        <div className="mt-4 text-caption text-textSecondary uppercase tracking-wide">最近查询：{lastQuery ? `${lastQuery.center[0].toFixed(4)}, ${lastQuery.center[1].toFixed(4)} (z${lastQuery.zoom})` : '无'}</div>
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
