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
  
  if (error) {
    return (
      <div className={`bg-gray-100 flex items-center justify-center text-gray-400 ${className}`}>
        图片加载失败
      </div>
    )
  }

  return (
    <Image
      src={src}
      alt={alt}
      fill
      className={className}
      style={{ objectFit: 'cover' }}
      sizes={sizes || '(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw'}
      priority={priority}
      onError={() => setError(true)}
    />
  )
}
