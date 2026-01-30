'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { User, Heart, History } from 'lucide-react'
import { getAuthState } from '@/lib/auth'
import {
  getFavorites,
  getBrowseHistory,
  removeFavorite,
  clearBrowseHistory,
  type FavoriteItem,
  type HistoryItem,
} from '@/lib/userData'

export default function UserCenterPage() {
  const [mounted, setMounted] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())
  const [favorites, setFavorites] = useState<FavoriteItem[]>([])
  const [history, setHistory] = useState<HistoryItem[]>([])

  useEffect(() => {
    setMounted(true)
    setAuthState(getAuthState())
    setFavorites(getFavorites())
    setHistory(getBrowseHistory())
  }, [])

  useEffect(() => {
    if (!mounted) return
    const hash = window.location.hash?.replace('#', '')
    if (hash) {
      const el = document.getElementById(hash)
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  }, [mounted])

  const refreshLists = () => {
    setFavorites(getFavorites())
    setHistory(getBrowseHistory())
  }

  const handleRemoveFavorite = (id: string) => {
    removeFavorite(id)
    refreshLists()
  }

  const handleClearHistory = () => {
    clearBrowseHistory()
    setHistory([])
  }

  const formatTime = (ts: number) => {
    const d = new Date(ts)
    const now = new Date()
    const diff = now.getTime() - ts
    if (diff < 60000) return '刚刚'
    if (diff < 3600000) return `${Math.floor(diff / 60000)} 分钟前`
    if (diff < 86400000) return `${Math.floor(diff / 3600000)} 小时前`
    if (diff < 604800000) return `${Math.floor(diff / 86400000)} 天前`
    return d.toLocaleDateString('zh-CN')
  }

  if (!mounted) {
    return (
      <main className="container-page py-12">
        <div className="text-textSecondary">加载中…</div>
      </main>
    )
  }

  return (
    <main className="container-page py-8 md:py-12 bg-white max-w-3xl mx-auto">
      <h1 className="text-heading font-bold mb-8 tracking-tight">个人设置</h1>

      {/* 个人信息：显示在个人设置下属 */}
      <section id="profile" className="mb-10 scroll-mt-4">
        <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
          <User size={20} />
          个人信息
        </h2>
        <div className="border border-gray-200 rounded-lg p-5 bg-gray-50/50">
          {authState.isAuthenticated && authState.user ? (
            <div className="flex items-center gap-4">
              {authState.user.avatar ? (
                <img
                  src={authState.user.avatar}
                  alt=""
                  className="w-14 h-14 rounded-full object-cover"
                />
              ) : (
                <div className="w-14 h-14 rounded-full bg-blue-100 flex items-center justify-center">
                  <User size={28} className="text-blue-600" />
                </div>
              )}
              <div>
                <div className="font-medium text-gray-900">
                  {authState.user.nickname || authState.user.phone || '用户'}
                </div>
                <div className="text-sm text-gray-500">{authState.user.phone}</div>
              </div>
            </div>
          ) : (
            <p className="text-body text-textSecondary">
              未登录。登录后可同步个人设置。
            </p>
          )}
        </div>
      </section>

      {/* 收藏场地 */}
      <section id="favorites" className="mb-10 scroll-mt-4">
        <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
          <Heart size={20} />
          收藏场地
        </h2>
        <div className="border border-gray-200 rounded-lg overflow-hidden">
          {favorites.length === 0 ? (
            <div className="p-6 text-center text-textSecondary text-body-sm">
              暂无收藏，去
              <Link href="/map" className="text-black underline ml-1">地图</Link>
              发现场地并收藏
            </div>
          ) : (
            <ul className="divide-y divide-gray-100">
              {favorites.map((item) => (
                <li key={item.id} className="flex items-center justify-between gap-3 px-4 py-3 hover:bg-gray-50">
                  <Link href={`/venues/${item.id}`} className="flex-1 min-w-0">
                    <span className="font-medium text-gray-900 block truncate">{item.name}</span>
                    <span className="text-xs text-gray-500">
                      {item.sportType === 'basketball' ? '篮球' : item.sportType === 'football' ? '足球' : ''}
                    </span>
                  </Link>
                  <button
                    type="button"
                    onClick={() => handleRemoveFavorite(item.id)}
                    className="text-sm text-gray-500 hover:text-red-600 shrink-0"
                  >
                    取消收藏
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      </section>

      {/* 浏览记录 */}
      <section id="history" className="scroll-mt-4">
        <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
          <History size={20} />
          浏览记录
        </h2>
        <div className="border border-gray-200 rounded-lg overflow-hidden">
          {history.length === 0 ? (
            <div className="p-6 text-center text-textSecondary text-body-sm">
              暂无浏览记录
            </div>
          ) : (
            <>
              <div className="flex justify-end px-4 py-2 bg-gray-50 border-b border-gray-100">
                <button
                  type="button"
                  onClick={handleClearHistory}
                  className="text-sm text-gray-500 hover:text-gray-700"
                >
                  清空记录
                </button>
              </div>
              <ul className="divide-y divide-gray-100">
                {history.map((item) => (
                  <li key={`${item.id}-${item.visitedAt}`} className="px-4 py-3 hover:bg-gray-50">
                    <Link href={`/venues/${item.id}`} className="block">
                      <span className="font-medium text-gray-900 block truncate">{item.name}</span>
                      <span className="text-xs text-gray-500">
                        {item.sportType === 'basketball' ? '篮球' : item.sportType === 'football' ? '足球' : ''}
                        {' · '}
                        {formatTime(item.visitedAt)}
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
            </>
          )}
        </div>
      </section>
    </main>
  )
}
