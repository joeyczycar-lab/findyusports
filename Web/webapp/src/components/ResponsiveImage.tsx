"use client"
import Image from 'next/image'
import { useState } from 'react'

type Props = {
  src: string
  alt: string
  className?: string
  sizes?: string
  priority?: boolean
}

export default function ResponsiveImage({ src, alt, className, sizes, priority = false }: Props) {
  const [error, setError] = useState(false)
  const [imgError, setImgError] = useState(false)
  
  // 如果是 OSS 图片，直接使用 img 标签避免 Next.js Image 优化问题
  const isOssImage = src?.includes('aliyuncs.com')
  
  if (error || imgError) {
    return (
      <div className={`bg-gray-100 flex items-center justify-center text-gray-400 ${className}`}>
        图片加载失败
      </div>
    )
  }

  // 对于 OSS 图片，使用普通 img 标签
  if (isOssImage) {
    return (
      <img
        src={src}
        alt={alt}
        className={className}
        style={{ 
          objectFit: 'cover',
          width: '100%',
          height: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0
        }}
        onError={() => {
          console.error('❌ Image load error:', src)
          setImgError(true)
        }}
        loading={priority ? 'eager' : 'lazy'}
      />
    )
  }

  // 对于其他图片，使用 Next.js Image 组件
  return (
    <Image
      src={src}
      alt={alt}
      fill
      className={className}
      style={{ objectFit: 'cover' }}
      sizes={sizes || '(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw'}
      priority={priority}
      onError={() => {
        console.error('❌ Next.js Image load error:', src)
        setError(true)
      }}
    />
  )
}
