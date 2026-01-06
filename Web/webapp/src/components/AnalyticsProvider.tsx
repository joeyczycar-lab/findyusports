'use client'

import { useEffect } from 'react'
import { usePathname } from 'next/navigation'
import { recordPageView, getPageType } from '@/lib/analytics'

export default function AnalyticsProvider() {
  const pathname = usePathname()

  useEffect(() => {
    if (pathname) {
      const pageType = getPageType(pathname)
      recordPageView(pathname, pageType)
    }
  }, [pathname])

  return null // 这个组件不渲染任何内容
}


