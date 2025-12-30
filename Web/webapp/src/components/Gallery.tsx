"use client"
import Image from 'next/image'
import { useState, useEffect } from 'react'
import ImageUpload from './ImageUpload'
import ResponsiveImage from './ResponsiveImage'
import { fetchJson } from '@/lib/api'
import { getAuthState } from '@/lib/auth'

type ImageItem = {
  id?: number
  url: string
}

type Props = {
  urls: string[] | ImageItem[]
  venueId?: string
  onImageAdded?: (url: string) => void
}

export default function Gallery({ urls, venueId, onImageAdded }: Props) {
  const [active, setActive] = useState(0)
  const [mounted, setMounted] = useState(false)
  // 将 urls 转换为 ImageItem 格式
  const [imageItems, setImageItems] = useState<ImageItem[]>(() => {
    if (!urls || urls.length === 0) return []
    // 如果 urls 是字符串数组，转换为 ImageItem 数组
    if (typeof urls[0] === 'string') {
      return (urls as string[]).map(url => ({ url }))
    }
    return urls as ImageItem[]
  })
  const [deletingImageId, setDeletingImageId] = useState<number | null>(null)
  const authState = getAuthState()

  useEffect(() => {
    setMounted(true)
  }, [])

  // 当 urls prop 变化时，更新本地状态
  useEffect(() => {
    if (!urls || urls.length === 0) {
      setImageItems([])
      return
    }
    // 如果 urls 是字符串数组，转换为 ImageItem 数组
    if (typeof urls[0] === 'string') {
      setImageItems((urls as string[]).map(url => ({ url })))
    } else {
      setImageItems(urls as ImageItem[])
    }
  }, [urls])

  // 处理新图片添加
  const handleImageAdded = (newUrl: string) => {
    console.log('🖼️ [Gallery] New image added:', newUrl)
    setImageItems(prev => [...prev, { url: newUrl }])
    setActive(imageItems.length) // 切换到新添加的图片
    onImageAdded?.(newUrl)
    // 刷新页面以重新加载图片列表
    setTimeout(() => {
      window.location.reload()
    }, 1000)
  }

  // 处理删除图片
  const handleDeleteImage = async (imageId: number, index: number) => {
    if (!venueId || !imageId) {
      console.error('❌ [Gallery] Cannot delete image: missing venueId or imageId')
      return
    }

    if (!confirm('确定要删除这张图片吗？此操作不可撤销。')) {
      return
    }

    try {
      setDeletingImageId(imageId)
      const result = await fetchJson(`/venues/${venueId}/images/${imageId}/delete`, {
        method: 'POST',
      })

      if (result.error) {
        throw new Error(result.error.message || '删除图片失败')
      }

      // 从本地状态中移除图片
      setImageItems(prev => prev.filter((_, i) => i !== index))
      
      // 如果删除的是当前激活的图片，切换到第一张
      if (active === index) {
        setActive(0)
      } else if (active > index) {
        setActive(active - 1)
      }

      // 刷新页面以重新加载图片列表
      setTimeout(() => {
        window.location.reload()
      }, 500)
    } catch (error: any) {
      console.error('❌ [Gallery] Failed to delete image:', error)
      alert(error.message || '删除图片失败，请稍后重试')
    } finally {
      setDeletingImageId(null)
    }
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
  
  if (!imageItems || imageItems.length === 0) {
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
  
  const isAdmin = authState.isAuthenticated && authState.user?.role === 'admin'
  
  return (
    <div className="space-y-4">
      <div className="relative h-64 overflow-hidden bg-gray-50" style={{ borderRadius: '4px', position: 'relative', minHeight: '256px' }}>
        {imageItems[active] && (
          <>
            <ResponsiveImage 
              src={imageItems[active].url} 
              alt="场地图片" 
              sizes="(max-width: 768px) 100vw, 50vw"
              priority={active === 0}
            />
            {isAdmin && imageItems[active].id && (
              <button
                onClick={() => handleDeleteImage(imageItems[active].id!, active)}
                disabled={deletingImageId === imageItems[active].id}
                className="absolute top-2 right-2 bg-red-500 text-white px-3 py-1 text-xs font-bold rounded hover:bg-red-600 disabled:opacity-50 disabled:cursor-not-allowed"
                style={{ zIndex: 10 }}
              >
                {deletingImageId === imageItems[active].id ? '删除中...' : '🗑️ 删除'}
              </button>
            )}
          </>
        )}
      </div>
      
      <div className="flex gap-2 overflow-x-auto">
        {imageItems.map((item, i) => (
          <div key={i} className="relative flex-shrink-0">
            <button 
              onClick={()=>setActive(i)} 
              className={`relative w-24 h-16 overflow-hidden border ${active===i? 'border-brandBlue' : 'border-border'}`} 
              style={{ borderRadius: '4px' }}
            >
              <ResponsiveImage 
                src={item.url} 
                alt="缩略图" 
                sizes="96px"
              />
            </button>
            {isAdmin && item.id && (
              <button
                onClick={(e) => {
                  e.stopPropagation()
                  handleDeleteImage(item.id!, i)
                }}
                disabled={deletingImageId === item.id}
                className="absolute top-0 right-0 bg-red-500 text-white text-xs px-1 py-0.5 rounded hover:bg-red-600 disabled:opacity-50 disabled:cursor-not-allowed"
                style={{ fontSize: '10px', zIndex: 10 }}
              >
                ×
              </button>
            )}
          </div>
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


