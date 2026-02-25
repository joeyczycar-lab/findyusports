'use client'

import { ReactNode } from 'react'
import { useIsMobile } from '@/hooks/useIsMobile'

/** 仅手机端（视口 <768px）渲染子节点，便于与网页端设计分离。 */
export default function MobileOnly({ children }: { children: ReactNode }) {
  const isMobile = useIsMobile()
  if (!isMobile) return null
  return <>{children}</>
}
