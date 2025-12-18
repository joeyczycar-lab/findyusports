"use client"
import { useEffect, useRef, useState } from 'react'
import { loadAMap } from '@/lib/amapLoader'

type Props = {
  className?: string
  position: [number, number]
  name?: string
  zoom?: number
}

export default function MapPreview({ className, position, name, zoom = 15 }: Props) {
  const containerRef = useRef<HTMLDivElement | null>(null)
  const [error, setError] = useState<string | null>(null)
  const mapRef = useRef<any>(null)
  const markerRef = useRef<any>(null)

  useEffect(() => {
    let map: any
    let marker: any
    let disposed = false

    loadAMap()
      .then((AMap) => {
        if (!containerRef.current || disposed) return
        // @ts-ignore - AMap is loaded dynamically
        map = new window.AMap.Map(containerRef.current, {
          viewMode: '2D',
          zoom,
          center: position,
          mapStyle: 'amap://styles/normal',
        })
        mapRef.current = map

        // @ts-ignore - AMap is loaded dynamically
        marker = new window.AMap.Marker({
          position,
          // @ts-ignore
          offset: new window.AMap.Pixel(-13, -30),
          content: `<div style="transform:translateZ(0);display:flex;align-items:center;justify-content:center;width:26px;height:26px;border-radius:13px;background:#2563EB;color:#fff;font-size:12px;box-shadow:0 2px 6px rgba(0,0,0,.2)">📍</div>`,
        })
        marker.setMap(map)
        markerRef.current = marker

        // 如果有名称，显示信息窗口
        if (name) {
          // @ts-ignore
          const infoWindow = new window.AMap.InfoWindow({
            // @ts-ignore
            offset: new window.AMap.Pixel(0, -20),
            content: `<div style="min-width:120px;padding:4px;">${name}</div>`,
          })
          infoWindow.open(map, position)
        }
      })
      .catch((e) => setError(e.message || String(e)))

    return () => {
      disposed = true
      try {
        if (marker) marker.setMap(null)
        if (map) map.destroy()
      } catch {}
      mapRef.current = null
      markerRef.current = null
    }
  }, [position, name, zoom])

  if (error) {
    const isMissingKey = error.includes('NEXT_PUBLIC_AMAP_KEY')
    return (
      <div className={`flex flex-col items-center justify-center text-center text-red-600 border border-border p-4 ${className || ''}`} style={{ borderRadius: '4px' }}>
        <div className="text-sm font-semibold mb-1">地图加载失败</div>
        {isMissingKey ? (
          <div className="text-xs text-gray-600">
            请配置高德地图 API Key
          </div>
        ) : (
          <div className="text-xs text-gray-600">{error}</div>
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



