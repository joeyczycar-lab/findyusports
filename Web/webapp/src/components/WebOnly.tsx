'use client'

import { ReactNode } from 'react'
import { useIsMobile } from '@/hooks/useIsMobile'

/** 仅网页端（视口 ≥768px）渲染子节点，便于与手机端设计分离。 */
export default function WebOnly({ children }: { children: ReactNode }) {
  const isMobile = useIsMobile()
  if (isMobile) return null
  return <>{children}</>
}
