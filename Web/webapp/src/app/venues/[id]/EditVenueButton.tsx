'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { getAuthState } from '@/lib/auth'

export default function EditVenueButton({ venueId }: { venueId: string }) {
  const [isAdmin, setIsAdmin] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    const authState = getAuthState()
    setIsAdmin(authState.isAuthenticated && authState.user?.role === 'admin')
  }, [])

  if (!mounted || !isAdmin) {
    return null
  }

  return (
    <Link
      href={`/admin/edit-venue/${venueId}`}
      className="bg-blue-500 text-white px-4 py-2 text-sm font-bold uppercase tracking-wider hover:bg-blue-600 transition-colors inline-block"
      style={{ borderRadius: '4px' }}
    >
      ✏️ 编辑场地
    </Link>
  )
}
