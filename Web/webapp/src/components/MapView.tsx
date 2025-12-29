"use client"
import { useEffect, useRef, useState } from 'react'
import { loadAMap } from '@/lib/amapLoader'

type Props = {
  className?: string
  markers?: Array<{
    id: string
    name: string
    position: [number, number]
    active?: boolean
  }>
  onMarkerClick?: (id: string) => void
  activeId?: string | null
}

export default function MapView({ className, markers, onMarkerClick, activeId }: Props) {
  const containerRef = useRef<HTMLDivElement | null>(null)
  const [error, setError] = useState<string | null>(null)
  const mapRef = useRef<any>(null)
  const infoRef = useRef<any>(null)
  const clusterRef = useRef<any>(null)

  useEffect(() => {
    let map: any
    let toolbar: any
    let disposed = false

    loadAMap()
      .then((AMap) => {
        if (!containerRef.current || disposed) return
        map = new AMap.Map(containerRef.current, {
          viewMode: '3D',
          zoom: 11,
          center: [116.397428, 39.90923],
        })
        mapRef.current = map

        toolbar = new AMap.ToolBar()
        map.addControl(toolbar)
      })
      .catch((e) => setError(e.message || String(e)))

    return () => {
      disposed = true
      try { toolbar && toolbar.destroy && toolbar.destroy() } catch {}
      try { map && map.destroy && map.destroy() } catch {}
      mapRef.current = null
    }
  }, [])

  // markers render
  useEffect(() => {
    const map = mapRef.current
    // @ts-ignore - AMap is loaded dynamically
    if (!map || !window.AMap) return
    // 清理旧聚合
    if (clusterRef.current) {
      clusterRef.current.setMap(null)
      clusterRef.current = null
    }
    if (!markers || markers.length === 0) return

    // @ts-ignore - AMap is loaded dynamically
    const points = markers.map((mk) => new window.AMap.Marker({
      position: mk.position,
      // @ts-ignore
      offset: new window.AMap.Pixel(-13, -30),
      content: `<div style="transform:translateZ(0);display:flex;align-items:center;justify-content:center;width:26px;height:26px;border-radius:13px;background:${mk.active ? '#2563EB' : '#16A34A'};color:#fff;font-size:12px;box-shadow:0 2px 6px rgba(0,0,0,.2)">•</div>`
    }))
    points.forEach((marker, idx) => {
      const id = markers[idx].id
      marker.on('click', () => onMarkerClick?.(id))
    })
    // @ts-ignore
    const cluster = new window.AMap.MarkerCluster(map, points, { gridSize: 60 })
    clusterRef.current = cluster
  }, [markers, onMarkerClick])

  // activeId -> open InfoWindow
  useEffect(() => {
    const map = mapRef.current
    // @ts-ignore - AMap is loaded dynamically
    if (!map || !window.AMap || !markers || !activeId) return
    const target = markers.find(m => m.id === activeId)
    if (!target) return
    // @ts-ignore
    if (!infoRef.current) infoRef.current = new window.AMap.InfoWindow({ 
      // @ts-ignore
      offset: new window.AMap.Pixel(0, -20) 
    })
    infoRef.current.setContent(`<div style="min-width:160px;">${target.name}</div>`)
    infoRef.current.open(map, target.position)
    map.setCenter(target.position)
  }, [activeId, markers])

  if (error) {
    const isMissingKey = error.includes('NEXT_PUBLIC_AMAP_KEY')
    return (
      <div className="flex flex-col items-center justify-center text-center text-red-600 border border-border p-6" style={{ borderRadius: '4px' }}>
        <div className="font-semibold mb-2">地图加载失败</div>
        {isMissingKey ? (
          <div className="text-sm text-gray-600">
            请配置高德地图 API Key（NEXT_PUBLIC_AMAP_KEY）
          </div>
        ) : (
          <div className="text-sm text-gray-600">{error}</div>
        )}
      </div>
    )
  }

  return (
    <div className={`relative ${className || ''}`}>
      <div ref={containerRef} className="absolute inset-0 overflow-hidden" style={{ borderRadius: '4px' }} />
    </div>
  )
}


