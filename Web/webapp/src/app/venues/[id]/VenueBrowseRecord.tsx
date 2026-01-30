'use client'

import { useEffect } from 'react'
import { addBrowseHistory } from '@/lib/userData'

interface Props {
  venueId: string
  name: string
  sportType?: 'basketball' | 'football'
}

export default function VenueBrowseRecord({ venueId, name, sportType }: Props) {
  useEffect(() => {
    if (venueId && name) {
      addBrowseHistory({ id: venueId, name, sportType })
    }
  }, [venueId, name, sportType])
  return null
}
