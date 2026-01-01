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
  const [lightboxOpen, setLightboxOpen] = useState(false)
  const [lightboxIndex, setLightboxIndex] = useState(0)
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

  // 打开大图预览
  const openLightbox = (index: number) => {
    setLightboxIndex(index)
    setLightboxOpen(true)
    // 阻止背景滚动
    document.body.style.overflow = 'hidden'
  }

  // 关闭大图预览
  const closeLightbox = () => {
    setLightboxOpen(false)
    document.body.style.overflow = ''
  }

  // 切换上一张/下一张图片
  const navigateLightbox = (direction: 'prev' | 'next') => {
    if (direction === 'prev') {
      setLightboxIndex(prev => (prev > 0 ? prev - 1 : imageItems.length - 1))
    } else {
      setLightboxIndex(prev => (prev < imageItems.length - 1 ? prev + 1 : 0))
    }
  }

  // 键盘事件处理
  useEffect(() => {
    if (!lightboxOpen) return

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        closeLightbox()
      } else if (e.key === 'ArrowLeft') {
        navigateLightbox('prev')
      } else if (e.key === 'ArrowRight') {
        navigateLightbox('next')
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [lightboxOpen, imageItems.length])

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
      <div 
        className="relative h-64 overflow-hidden bg-gray-50 cursor-pointer" 
        style={{ borderRadius: '4px', position: 'relative', minHeight: '256px' }}
        onClick={() => openLightbox(active)}
      >
        {imageItems[active] && (
          <>
            <ResponsiveImage 
              src={imageItems[active].url} 
              alt="场地图片" 
              sizes="(max-width: 768px) 100vw, 50vw"
              priority={active === 0}
            />
            {/* 点击提示 */}
            <div className="absolute bottom-2 left-2 bg-black bg-opacity-50 text-white px-2 py-1 text-xs rounded">
              🔍 点击查看大图
            </div>
            {isAdmin && imageItems[active].id && (
              <button
                onClick={(e) => {
                  e.stopPropagation()
                  handleDeleteImage(imageItems[active].id!, active)
                }}
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
              onClick={() => {
                setActive(i)
                openLightbox(i)
              }}
              className={`relative w-24 h-16 overflow-hidden border ${active===i? 'border-brandBlue' : 'border-border'} cursor-pointer`} 
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

      {/* 大图预览模态框 */}
      {lightboxOpen && imageItems[lightboxIndex] && (
        <div
          className="fixed inset-0 bg-black bg-opacity-90 z-[999999] flex items-center justify-center"
          onClick={closeLightbox}
          style={{ zIndex: 999999 }}
        >
          {/* 关闭按钮 */}
          <button
            onClick={closeLightbox}
            className="absolute top-4 right-4 text-white text-3xl font-bold hover:text-gray-300 z-10"
            style={{ zIndex: 1000000 }}
          >
            ×
          </button>

          {/* 上一张按钮 */}
          {imageItems.length > 1 && (
            <button
              onClick={(e) => {
                e.stopPropagation()
                navigateLightbox('prev')
              }}
              className="absolute left-4 text-white text-4xl font-bold hover:text-gray-300 z-10"
              style={{ zIndex: 1000000 }}
            >
              ‹
            </button>
          )}

          {/* 下一张按钮 */}
          {imageItems.length > 1 && (
            <button
              onClick={(e) => {
                e.stopPropagation()
                navigateLightbox('next')
              }}
              className="absolute right-4 text-white text-4xl font-bold hover:text-gray-300 z-10"
              style={{ zIndex: 1000000 }}
            >
              ›
            </button>
          )}

          {/* 图片容器 */}
          <div
            className="relative max-w-[90vw] max-h-[90vh] flex items-center justify-center"
            onClick={(e) => e.stopPropagation()}
          >
            <img
              src={imageItems[lightboxIndex].url}
              alt={`场地图片 ${lightboxIndex + 1}`}
              className="max-w-full max-h-[90vh] object-contain"
              style={{ borderRadius: '4px' }}
            />
          </div>

          {/* 图片索引指示器 */}
          {imageItems.length > 1 && (
            <div
              className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-black bg-opacity-50 text-white px-4 py-2 rounded text-sm"
              style={{ zIndex: 1000000 }}
            >
              {lightboxIndex + 1} / {imageItems.length}
            </div>
          )}
        </div>
      )}
    </div>
  )
}


