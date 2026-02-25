'use client'

import { ReactNode, useEffect } from 'react'
import { useIsMobile } from '@/hooks/useIsMobile'
import Nav from '@/components/Nav'
import BottomNav from '@/components/BottomNav'
import MobileOnboarding from '@/components/MobileOnboarding'

const BODY_CLASS_WEB = 'layout-web'
const BODY_CLASS_MOBILE = 'layout-mobile'

/**
 * 根据视口设置 body 的 layout-web / layout-mobile，
 * 便于在 CSS 或组件中按网页端/手机端分别写样式与逻辑。
 * BottomNav 仍用 md:hidden 控制显示，避免首屏闪烁。
 */
export default function LayoutClient({ children }: { children: ReactNode }) {
  const isMobile = useIsMobile()

  useEffect(() => {
    document.body.classList.remove(BODY_CLASS_WEB, BODY_CLASS_MOBILE)
    document.body.classList.add(isMobile ? BODY_CLASS_MOBILE : BODY_CLASS_WEB)
    return () => {
      document.body.classList.remove(BODY_CLASS_WEB, BODY_CLASS_MOBILE)
    }
  }, [isMobile])

  return (
    <>
      <MobileOnboarding />
      <Nav />
      {children}
      <BottomNav />
    </>
  )
}
