"use client"
import Image from 'next/image'
import { useState, useEffect } from 'react'
import ImageUpload from './ImageUpload'
import ResponsiveImage from './ResponsiveImage'

type Props = {
  urls: string[]
  venueId?: string
  onImageAdded?: (url: string) => void
}

export default function Gallery({ urls, venueId, onImageAdded }: Props) {
  const [active, setActive] = useState(0)
  const [mounted, setMounted] = useState(false)
  const [imageUrls, setImageUrls] = useState<string[]>(urls || [])

  useEffect(() => {
    setMounted(true)
  }, [])

  // 当 urls prop 变化时，更新本地状态
  useEffect(() => {
    setImageUrls(urls || [])
  }, [urls])

  // 处理新图片添加
  const handleImageAdded = (newUrl: string) => {
    console.log('🖼️ [Gallery] New image added:', newUrl)
    setImageUrls(prev => [...prev, newUrl])
    setActive(imageUrls.length) // 切换到新添加的图片
    onImageAdded?.(newUrl)
    // 刷新页面以重新加载图片列表
    setTimeout(() => {
      window.location.reload()
    }, 1000)
  }

  // 在客户端挂载之前，返回一个简单的占位符，避免 hydration 错误
  if (!mounted) {
    return (
      <div className="space-y-4">
        <div className="h-64 bg-gray-100 flex items-center justify-center text-textMuted" style={{ borderRadius: '4px' }}>
          加载中...
        </div>
      </div>
    )
  }
  
  if (!imageUrls || imageUrls.length === 0) {
    return (
      <div className="space-y-4">
        <div className="h-64 bg-gray-100 flex items-center justify-center text-textMuted" style={{ borderRadius: '4px' }}>
          暂无图片
        </div>
        {venueId && (
          <div className="mt-4">
            <ImageUpload venueId={venueId} onSuccess={handleImageAdded} />
          </div>
        )}
      </div>
    )
  }
  
  return (
    <div className="space-y-4">
      <div className="relative h-64 overflow-hidden bg-gray-50" style={{ borderRadius: '4px', position: 'relative', minHeight: '256px' }}>
        {imageUrls[active] && (
          <ResponsiveImage 
            src={imageUrls[active]} 
            alt="场地图片" 
            sizes="(max-width: 768px) 100vw, 50vw"
            priority={active === 0}
          />
        )}
      </div>
      
      <div className="flex gap-2 overflow-x-auto">
        {imageUrls.map((u, i) => (
          <button key={i} onClick={()=>setActive(i)} className={`relative w-24 h-16 overflow-hidden border flex-shrink-0 ${active===i? 'border-brandBlue' : 'border-border'}`} style={{ borderRadius: '4px' }}>
            <ResponsiveImage 
              src={u} 
              alt="缩略图" 
              sizes="96px"
            />
          </button>
        ))}
      </div>
      
        {venueId && (
          <div className="mt-4">
            <ImageUpload venueId={venueId} onSuccess={handleImageAdded} />
          </div>
        )}
    </div>
  )
}


