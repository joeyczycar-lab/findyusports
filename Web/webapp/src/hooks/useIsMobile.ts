'use client'

import { useState, useEffect } from 'react'

const BREAKPOINT = 768

/**
 * 是否为手机端（视口宽度 < 768px）。
 * 用于网页端 / 手机端设计分离，便于按设备渲染不同布局或组件。
 */
export function useIsMobile(): boolean {
  const [isMobile, setIsMobile] = useState(false)

  useEffect(() => {
    const update = () => setIsMobile(window.innerWidth < BREAKPOINT)
    update()
    window.addEventListener('resize', update)
    return () => window.removeEventListener('resize', update)
  }, [])

  return isMobile
}
