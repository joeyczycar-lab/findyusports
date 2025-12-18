"use client"
import { useEffect, useRef, useState } from 'react'
import { loadAMap } from '@/lib/amapLoader'

type Props = {
  className?: string
  onLocationSelect: (lng: number, lat: number) => void
  initialPosition?: [number, number]
}

export default function LocationPicker({ className, onLocationSelect, initialPosition }: Props) {
  const containerRef = useRef<HTMLDivElement | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [selectedPosition, setSelectedPosition] = useState<[number, number] | null>(initialPosition || null)
  const [mounted, setMounted] = useState(false)
  const mapRef = useRef<any>(null)
  const markerRef = useRef<any>(null)

  // 确保只在客户端渲染
  useEffect(() => {
    setMounted(true)
  }, [])

  useEffect(() => {
    // 只在客户端挂载后执行
    if (!mounted) return

    let map: any
    let marker: any
    let disposed = false

    loadAMap()
      .then((AMap) => {
        if (!containerRef.current || disposed) return
        
        const center = initialPosition || [116.397428, 39.90923]
        
        // @ts-ignore - AMap is loaded dynamically
        map = new window.AMap.Map(containerRef.current, {
          viewMode: '2D',
          zoom: 13,
          center: center,
          mapStyle: 'amap://styles/normal',
        })
        mapRef.current = map

        // 如果有初始位置，创建标记
        if (initialPosition) {
          // @ts-ignore
          marker = new window.AMap.Marker({
            position: initialPosition,
            // @ts-ignore
            offset: new window.AMap.Pixel(-13, -30),
            content: `<div style="transform:translateZ(0);display:flex;align-items:center;justify-content:center;width:26px;height:26px;border-radius:13px;background:#2563EB;color:#fff;font-size:12px;box-shadow:0 2px 6px rgba(0,0,0,.2)">📍</div>`,
          })
          marker.setMap(map)
          markerRef.current = marker
        }

        // 地图点击事件
        map.on('click', (e: any) => {
          const lng = e.lnglat.getLng()
          const lat = e.lnglat.getLat()
          const position: [number, number] = [lng, lat]
          
          setSelectedPosition(position)
          onLocationSelect(lng, lat)

          // 移除旧标记，创建新标记
          if (marker) {
            marker.setMap(null)
          }
          
          // @ts-ignore
          marker = new window.AMap.Marker({
            position: position,
            // @ts-ignore
            offset: new window.AMap.Pixel(-13, -30),
            content: `<div style="transform:translateZ(0);display:flex;align-items:center;justify-content:center;width:26px;height:26px;border-radius:13px;background:#2563EB;color:#fff;font-size:12px;box-shadow:0 2px 6px rgba(0,0,0,.2)">📍</div>`,
          })
          marker.setMap(map)
          markerRef.current = marker
        })

        // 添加工具栏
        // @ts-ignore
        const toolbar = new window.AMap.ToolBar()
        map.addControl(toolbar)
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
  }, [mounted, onLocationSelect, initialPosition])

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

  // 在服务器端或未挂载时显示占位符
  if (!mounted) {
    return (
      <div className={`relative ${className || ''}`}>
        <div className="absolute inset-0 bg-gray-100 flex items-center justify-center">
          <div className="text-gray-500">加载地图中...</div>
        </div>
      </div>
    )
  }

  return (
    <div className={`relative ${className || ''}`}>
      <div ref={containerRef} className="absolute inset-0 overflow-hidden" style={{ borderRadius: '4px' }} />
      {selectedPosition && (
        <div className="absolute top-2 left-2 bg-white px-3 py-2 rounded shadow-md text-sm z-10">
          <div className="font-semibold">已选择位置</div>
          <div className="text-xs text-gray-600">
            经度: {selectedPosition[0].toFixed(6)}, 纬度: {selectedPosition[1].toFixed(6)}
          </div>
        </div>
      )}
      <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-white px-4 py-2 rounded shadow-md text-sm pointer-events-none z-10">
        点击地图选择场地位置
      </div>
    </div>
  )
}

