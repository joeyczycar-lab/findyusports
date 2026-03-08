'use client'

import { useState, useEffect } from 'react'
import { isFavorite, toggleFavorite } from '@/lib/userData'

interface Props {
  venueId: string
  name: string
  sportType?: 'basketball' | 'football'
  className?: string
  /** 仅显示图标（用于顶栏） */
  iconOnly?: boolean
  /** 图标在上、文字在下（用于底栏） */
  iconWithLabel?: boolean
}

export default function FavoriteButton({ venueId, name, sportType, className = 'btn-secondary w-full', iconOnly, iconWithLabel }: Props) {
  const [fav, setFav] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    setFav(isFavorite(venueId))
  }, [venueId])

  const handleClick = () => {
    if (!mounted) return
    const next = toggleFavorite(venueId, name, sportType)
    setFav(next)
  }

  if (!mounted) return (
    <button type="button" className={className} disabled>
      {iconOnly ? '♥' : iconWithLabel ? (<><span className="text-lg">♥</span><span className="text-xs">收藏</span></>) : '收藏'}
    </button>
  )

  return (
    <button type="button" onClick={handleClick} className={className} style={iconWithLabel ? { display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2 } : undefined}>
      {iconOnly ? (fav ? '❤' : '♥') : iconWithLabel ? (
        <>
          <span className="text-lg leading-none">{fav ? '❤' : '♥'}</span>
          <span className="text-xs">{fav ? '已收藏' : '收藏'}</span>
        </>
      ) : (fav ? '已收藏' : '收藏')}
    </button>
  )
}
