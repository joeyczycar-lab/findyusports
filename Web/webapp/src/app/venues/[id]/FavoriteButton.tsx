'use client'

import { useState, useEffect } from 'react'
import { isFavorite, toggleFavorite } from '@/lib/userData'

interface Props {
  venueId: string
  name: string
  sportType?: 'basketball' | 'football'
  className?: string
}

export default function FavoriteButton({ venueId, name, sportType, className = 'btn-secondary w-full' }: Props) {
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

  if (!mounted) return <button type="button" className={className} disabled>收藏</button>

  return (
    <button type="button" onClick={handleClick} className={className}>
      {fav ? '已收藏' : '收藏'}
    </button>
  )
}
