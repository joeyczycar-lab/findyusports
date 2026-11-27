'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { getAuthState } from '@/lib/auth'
import { useState, useEffect } from 'react'

export default function AdminNav() {
  const pathname = usePathname()
  const [mounted, setMounted] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())

  useEffect(() => {
    setMounted(true)
    setAuthState(getAuthState())
  }, [])

  if (!mounted) {
    return null
  }

  // 检查是否为管理员
  const isAdmin = authState.isAuthenticated && authState.user?.role === 'admin'

  if (!isAdmin) {
    return null
  }

  const navItems = [
    { href: '/admin/venues', label: '📋 场地管理', icon: '📋' },
    { href: '/admin/duplicates', label: '🔁 查重去重', icon: '🔁' },
    { href: '/admin/add-venue', label: '➕ 添加场地', icon: '➕' },
    { href: '/admin/analytics', label: '📊 数据分析', icon: '📊' },
    { href: '/admin/data', label: '📈 数据统计', icon: '📈' },
  ]

  return (
    <nav className="bg-gray-100 border-b border-gray-300 mb-6">
      <div className="container-page py-4">
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-body-sm font-bold text-gray-700 mr-2">管理导航：</span>
          {navItems.map((item) => {
            const isActive = pathname === item.href || pathname?.startsWith(item.href + '/')
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`px-4 py-2 text-sm font-bold uppercase tracking-wider transition-colors ${
                  isActive
                    ? 'bg-black text-white'
                    : 'bg-white text-black hover:bg-gray-200'
                }`}
                style={{ borderRadius: '4px' }}
              >
                {item.label}
              </Link>
            )
          })}
        </div>
      </div>
    </nav>
  )
}
