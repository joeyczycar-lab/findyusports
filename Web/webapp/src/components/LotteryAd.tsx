'use client'

import { useState, useEffect } from 'react'

type Props = {
  className?: string
}

export default function LotteryAd({ className = '' }: Props) {
  const [imageError, setImageError] = useState(false)
  const [lightboxOpen, setLightboxOpen] = useState(false)

  // 键盘事件处理
  useEffect(() => {
    if (!lightboxOpen) return

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        closeLightbox()
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [lightboxOpen])

  const openLightbox = () => {
    setLightboxOpen(true)
    document.body.style.overflow = 'hidden'
  }

  const closeLightbox = () => {
    setLightboxOpen(false)
    document.body.style.overflow = ''
  }

  return (
    <>
      <div className={`bg-white border border-border p-6 ${className}`} style={{ borderRadius: '4px' }}>
        <div className="text-center">
          <h3 className="text-heading-sm font-bold mb-2 text-primary">体彩竞彩打票</h3>
          <p className="text-body-sm text-textSecondary mb-4">实体店在线打票，安全快速</p>
          
          <div className="flex justify-center mb-4">
            <div 
              className="relative w-48 h-48 bg-gray-50 border border-border overflow-hidden flex items-center justify-center cursor-pointer hover:opacity-90 transition-opacity" 
              style={{ borderRadius: '4px' }}
              onClick={openLightbox}
            >
              {!imageError ? (
                <>
                  <img
                    src="/wechat-qrcode.jpg"
                    alt="微信二维码"
                    className="w-full h-full object-contain"
                    onError={() => setImageError(true)}
                  />
                  {/* 点击提示 */}
                  <div className="absolute bottom-2 left-2 right-2 bg-black bg-opacity-50 text-white text-xs px-2 py-1 rounded text-center">
                    🔍 点击查看大图
                  </div>
                </>
              ) : (
                <div className="w-full h-full flex flex-col items-center justify-center text-textMuted text-sm p-4">
                  <div className="mb-2 text-4xl">📱</div>
                  <div className="text-center">请上传微信二维码<br />到 public/wechat-qrcode.jpg</div>
                </div>
              )}
            </div>
          </div>
          
          <p className="text-xs text-textMuted">扫码添加微信，在线打票</p>
        </div>
      </div>

      {/* 大图预览模态框 */}
      {lightboxOpen && !imageError && (
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

          {/* 图片容器 */}
          <div
            className="relative max-w-[90vw] max-h-[90vh] flex items-center justify-center"
            onClick={(e) => e.stopPropagation()}
          >
            <img
              src="/wechat-qrcode.jpg"
              alt="微信二维码"
              className="max-w-full max-h-[90vh] object-contain"
              style={{ borderRadius: '4px' }}
            />
          </div>

          {/* 提示文字 */}
          <div
            className="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-black bg-opacity-50 text-white px-4 py-2 rounded text-sm"
            style={{ zIndex: 1000000 }}
          >
            按 ESC 键或点击背景关闭
          </div>
        </div>
      )}
    </>
  )
}
