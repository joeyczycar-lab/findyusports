"use client"

import { useState, useEffect } from 'react'
import Image from 'next/image'

type ReviewUser = { id?: number; nickname?: string; avatar?: string | null } | null
type ReviewItem = {
  id: number | string
  rating: number
  content: string
  createdAt?: string
  user?: ReviewUser
}

export default function Reviews({ items }: { items: ReviewItem[] }) {
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!items || items.length === 0) return <div className="text-textSecondary text-body-sm uppercase tracking-wide">还没有点评</div>

  return (
    <div className="space-y-6">
      {items.map(r => (
        <div key={r.id} className="border-t border-border pt-6 first:border-t-0 first:pt-0">
          <div className="flex items-center gap-3 mb-2">
            {r.user && (
              <>
                <div className="relative w-9 h-9 rounded-full overflow-hidden bg-muted flex-shrink-0">
                  {r.user.avatar ? (
                    <Image
                      src={r.user.avatar}
                      alt=""
                      fill
                      className="object-cover"
                      sizes="36px"
                    />
                  ) : (
                    <span className="w-full h-full flex items-center justify-center text-body-sm font-medium text-textSecondary bg-muted">
                      {(r.user.nickname || '?').slice(0, 1)}
                    </span>
                  )}
                </div>
                <div className="min-w-0">
                  <span className="font-medium text-body text-foreground block truncate">
                    {r.user.nickname || '匿名用户'}
                  </span>
                  <span className="text-textSecondary text-body-sm">
                    评分 {r.rating} 分
                    {r.createdAt && mounted && (
                      <span className="ml-2 uppercase tracking-wide">
                        {new Date(r.createdAt).toLocaleDateString('zh-CN', {
                          year: 'numeric',
                          month: 'long',
                          day: 'numeric',
                        })}
                      </span>
                    )}
                    {r.createdAt && !mounted && <span className="ml-2">加载中...</span>}
                  </span>
                </div>
              </>
            )}
            {!r.user && (
              <div className="font-bold text-heading-sm">
                评分 {r.rating} 分
                {r.createdAt && mounted && (
                  <span className="text-textSecondary text-body-sm font-normal ml-3 uppercase tracking-wide">
                    {new Date(r.createdAt).toLocaleDateString('zh-CN', {
                      year: 'numeric',
                      month: 'long',
                      day: 'numeric',
                    })}
                  </span>
                )}
                {r.createdAt && !mounted && (
                  <span className="text-textSecondary text-body-sm font-normal ml-3">加载中...</span>
                )}
              </div>
            )}
          </div>
          <div className={`text-body text-textSecondary leading-relaxed ${r.user ? 'pl-12' : ''}`}>{r.content}</div>
        </div>
      ))}
    </div>
  )
}


