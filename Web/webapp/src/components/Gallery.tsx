"use client"
import Image from 'next/image'
import { useState } from 'react'
import ImageUpload from './ImageUpload'
import ResponsiveImage from './ResponsiveImage'

type Props = {
  urls: string[]
  venueId?: string
  onImageAdded?: (url: string) => void
}

export default function Gallery({ urls, venueId, onImageAdded }: Props) {
  const [active, setActive] = useState(0)
  
  if (!urls || urls.length === 0) {
    return (
      <div className="space-y-4">
        <div className="h-64 bg-gray-100 flex items-center justify-center text-textMuted" style={{ borderRadius: '2px' }}>
          暂无图片
        </div>
        {venueId && (
          <div className="mt-4">
            <ImageUpload venueId={venueId} onSuccess={onImageAdded} />
          </div>
        )}
      </div>
    )
  }
  
  return (
    <div className="space-y-4">
      <div className="relative h-64 overflow-hidden bg-gray-50" style={{ borderRadius: '2px' }}>
        <ResponsiveImage 
          src={urls[active]} 
          alt="场地图片" 
          sizes="(max-width: 768px) 100vw, 50vw"
          priority={active === 0}
        />
      </div>
      
      <div className="flex gap-2 overflow-x-auto">
        {urls.map((u, i) => (
          <button key={i} onClick={()=>setActive(i)} className={`relative w-24 h-16 overflow-hidden border flex-shrink-0 ${active===i? 'border-brandBlue' : 'border-border'}`} style={{ borderRadius: '2px' }}>
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
            <ImageUpload venueId={venueId} onSuccess={onImageAdded} />
          </div>
        )}
    </div>
  )
}


