'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Map, PlusCircle, User } from 'lucide-react'

const tabs = [
  { href: '/', label: '首页', icon: Home },
  { href: '/map', label: '探索', icon: Map },
  { href: '/admin/add-venue', label: '添加', icon: PlusCircle },
  { href: '/user', label: '我的', icon: User },
]

export default function BottomNav() {
  const pathname = usePathname() ?? ''

  return (
    <nav
      className="fixed bottom-0 left-0 right-0 z-[9999] bg-white border-t border-gray-200 md:hidden"
      style={{
        paddingBottom: 'max(env(safe-area-inset-bottom, 0px), 8px)',
        paddingTop: '8px',
        boxShadow: '0 -1px 0 0 rgba(0,0,0,0.06)',
      }}
    >
      <div className="flex items-center justify-around h-12">
        {tabs.map(({ href, label, icon: Icon }) => {
          const isActive =
            href === '/'
              ? pathname === '/'
              : href === '/map'
                ? pathname.startsWith('/map')
                : href === '/user'
                  ? pathname.startsWith('/user')
                  : pathname.startsWith(href)
          return (
            <Link
              key={href}
              href={href}
              className="flex flex-col items-center justify-center flex-1 h-full min-w-0 gap-1 text-[10px] transition-colors"
              style={{
                color: isActive ? '#111' : '#9ca3af',
                textDecoration: 'none',
              }}
            >
              <Icon
                className="shrink-0"
                size={20}
                strokeWidth={isActive ? 2.5 : 2}
              />
              <span className="truncate max-w-full">{label}</span>
            </Link>
          )
        })}
      </div>
    </nav>
  )
}
