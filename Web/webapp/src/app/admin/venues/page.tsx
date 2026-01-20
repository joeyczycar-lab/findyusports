"use client"

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import { useRouter } from 'next/navigation'
import { getAuthState } from '@/lib/auth'

export default function VenuesListPage() {
  const router = useRouter()
  const [venues, setVenues] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(0)
  const [keyword, setKeyword] = useState('') // 关键词搜索
  const [mounted, setMounted] = useState(false)
  const [sortBy, setSortBy] = useState<'city' | 'popularity' | 'name'>('popularity')
  const [deletingVenueId, setDeletingVenueId] = useState<number | null>(null)
  const [authState, setAuthState] = useState(getAuthState())
  const pageSize = 20

  useEffect(() => {
    setAuthState(getAuthState())
  }, [])

  useEffect(() => {
    setMounted(true)
  }, [])

  useEffect(() => {
    loadVenues()
  }, [page, sortBy, keyword])

  async function loadVenues() {
    try {
      setLoading(true)
      setError(null)
      
      // 不传坐标参数，获取所有场地，按地区和热度排序
      const params = new URLSearchParams({
        page: String(page),
        pageSize: String(pageSize),
        sortBy: sortBy,
      })
      // 如果有关键词，添加到查询参数
      if (keyword && keyword.trim()) {
        params.append('keyword', keyword.trim())
      }
      
      const data = await fetchJson(`/venues?${params.toString()}`)
      
      // 检查是否有错误
      if (data.error) {
        throw new Error(data.error.message || '获取场地列表失败')
      }
      
      const items = data.items || []
      const total = data.total || 0
      
      setVenues(items)
      setTotal(total)
    } catch (err: any) {
      setError(err.message || '加载场地失败')
      // 即使出错也设置空数组，避免显示"没有场地"
      setVenues([])
      setTotal(0)
    } finally {
      setLoading(false)
    }
  }

  const totalPages = Math.ceil(total / pageSize) || 1

  // 关键词搜索已由后端处理，直接使用返回的venues
  const filteredVenues = venues

  // 处理删除场地
  const handleDeleteVenue = async (venueId: number, venueName: string) => {
    if (!confirm(`确定要删除场地"${venueName}"吗？\n\n此操作将删除：\n- 场地信息\n- 所有图片\n- 所有评论\n\n此操作不可撤销！`)) {
      return
    }

    try {
      setDeletingVenueId(venueId)
      const result = await fetchJson(`/venues/${venueId}/delete`, {
        method: 'POST',
      })

      if (result.error) {
        throw new Error(result.error.message || '删除场地失败')
      }

      // 从列表中移除场地
      setVenues(prev => prev.filter(v => v.id !== venueId))
      setTotal(prev => Math.max(0, prev - 1))
      
      alert('场地已成功删除')
    } catch (error: any) {
      console.error('❌ [Admin] Failed to delete venue:', error)
      alert(error.message || '删除场地失败，请稍后重试')
    } finally {
      setDeletingVenueId(null)
    }
  }

  const isAdmin = authState.isAuthenticated && authState.user?.role === 'admin'

  // 在客户端挂载之前，返回一个简单的加载状态，避免 hydration 错误
  if (!mounted) {
    return (
      <div className="container-page py-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-heading font-bold mb-2">场地管理</h1>
            <p className="text-body text-textSecondary">加载中...</p>
          </div>
        </div>
        <div className="text-center py-16 text-textSecondary">
          加载中...
        </div>
      </div>
    )
  }

  return (
    <div className="container-page py-8">
      <div className="flex flex-col gap-4 mb-8">
        <div className="flex items-center justify-between gap-4 flex-wrap">
          <div>
            <h1 className="text-heading font-bold mb-2">全部场地</h1>
            <p className="text-body text-textSecondary">
              共 {total} 个场地 · 第 {page} / {totalPages} 页
            </p>
          </div>
          <div className="flex gap-4 items-center flex-wrap">
            <div className="flex items-center gap-2">
              <input
                type="text"
                value={keyword}
                onChange={(e) => {
                  setKeyword(e.target.value)
                  setPage(1) // 搜索时重置到第一页
                }}
                placeholder="按名称或地址搜索场地..."
                className="px-3 py-2 border border-gray-300 rounded text-sm bg-white min-w-[220px]"
              />
            </div>
            <select
              value={sortBy}
              onChange={(e) => {
                setSortBy(e.target.value as 'city' | 'popularity' | 'name')
                setPage(1) // 重置到第一页
              }}
              className="px-4 py-2 border border-gray-300 rounded text-sm bg-white"
            >
              <option value="popularity">🔥 按热度</option>
              <option value="city">📍 按地区</option>
              <option value="name">🔤 按名称</option>
            </select>
            <Link 
              href="/admin/add-venue" 
              className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors"
              style={{ borderRadius: '4px' }}
            >
              ➕ 添加场地
            </Link>
          </div>
        </div>
        {keyword && keyword.trim() && (
          <div className="text-xs text-textSecondary">
            搜索关键词：<span className="font-mono bg-gray-100 px-1 py-0.5 rounded">{keyword}</span> · 找到 {total} 个场地
            <button
              onClick={() => {
                setKeyword('')
                setPage(1)
              }}
              className="ml-2 text-blue-600 hover:text-blue-800 underline"
            >
              清除
            </button>
          </div>
        )}
      </div>

      {/* 调试信息 - 开发环境显示（仅在客户端渲染） */}
      {mounted && process.env.NODE_ENV === 'development' && (
        <div className="mb-4 p-3 bg-gray-100 text-xs rounded font-mono">
          <div>🔍 调试信息:</div>
          <div>loading: {loading ? 'true' : 'false'}</div>
          <div>error: {error || 'null'}</div>
          <div>venues.length: {venues.length}</div>
          <div>total: {total}</div>
          <div>page: {page}</div>
        </div>
      )}

      {loading && (
        <div className="text-center py-16 text-textSecondary">
          加载中...
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-6">
          ❌ {error}
          <div className="mt-2 text-sm">
            请检查：
            <ul className="list-disc list-inside mt-1">
              <li>后端服务是否运行在 http://localhost:4000</li>
              <li>打开浏览器控制台（F12）查看详细错误</li>
              <li>检查 Network 标签页中的 API 请求</li>
            </ul>
          </div>
        </div>
      )}

      {!loading && !error && venues.length === 0 && total === 0 && (
        <div className="text-center py-16 text-textSecondary">
          <div className="text-4xl mb-4">📭</div>
          <div className="text-body mb-4">还没有添加任何场地</div>
          <Link 
            href="/admin/add-venue" 
            className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors inline-block"
            style={{ borderRadius: '4px' }}
          >
            ➕ 添加第一个场地
          </Link>
        </div>
      )}

      {/* 搜索无结果的情况 */}
      {!loading && !error && venues.length === 0 && total === 0 && keyword && keyword.trim() && (
        <div className="text-center py-16 text-textSecondary">
          <div className="text-4xl mb-4">🔎</div>
          <div className="text-body mb-2">没有找到匹配"{keyword}"的场地</div>
          <div className="text-xs mb-4">请尝试其他关键词或清除搜索条件</div>
          <button
            onClick={() => {
              setKeyword('')
              setPage(1)
            }}
            className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors inline-block"
            style={{ borderRadius: '4px' }}
          >
            清除搜索
          </button>
        </div>
      )}

      {!loading && !error && venues.length === 0 && total > 0 && !keyword?.trim() && (
        <div className="text-center py-16 text-textSecondary">
          <div className="text-body mb-4">当前页没有场地数据（共 {total} 个场地）</div>
          <button
            onClick={() => setPage(1)}
            className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors inline-block"
            style={{ borderRadius: '4px' }}
          >
            返回第一页
          </button>
        </div>
      )}

      {!loading && !error && venues.length > 0 && (
        <>
          <div className="mb-4 text-sm text-textSecondary">
            显示 {venues.length} 个场地（共 {total} 个）
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            {venues.map((venue) => (
              <div
                key={venue.id}
                className="card-nike hover:shadow-lg transition-shadow overflow-hidden relative"
              >
                {/* 图片区域 */}
                <div className="h-48 bg-gray-100 relative overflow-hidden">
                  {venue.firstImage ? (
                    <img 
                      src={venue.firstImage} 
                      alt={venue.name}
                      className="w-full h-full object-cover"
                      loading="lazy"
                      onError={(e) => {
                        // 图片加载失败时隐藏图片，显示默认图标
                        const target = e.target as HTMLImageElement
                        target.style.display = 'none'
                        const parent = target.parentElement
                        if (parent && !parent.querySelector('.fallback-icon')) {
                          const fallback = document.createElement('div')
                          fallback.className = 'fallback-icon w-full h-full flex items-center justify-center text-textMuted text-4xl absolute inset-0'
                          fallback.textContent = venue.sportType === 'basketball' ? '🏀' : '⚽'
                          parent.appendChild(fallback)
                        }
                      }}
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-textMuted text-4xl">
                      {venue.sportType === 'basketball' ? '🏀' : '⚽'}
                    </div>
                  )}
                </div>
                
                {/* 编辑和删除按钮 - 仅管理员可见 */}
                {isAdmin && (
                  <div className="absolute top-2 right-2 flex gap-2 z-10">
                    <Link
                      href={`/admin/edit-venue/${venue.id}`}
                      onClick={(e) => e.stopPropagation()}
                      className="bg-blue-500 text-white px-3 py-1 text-xs font-bold rounded hover:bg-blue-600 transition-colors"
                    >
                      ✏️ 编辑
                    </Link>
                    <button
                      onClick={(e) => {
                        e.preventDefault()
                        e.stopPropagation()
                        handleDeleteVenue(venue.id, venue.name)
                      }}
                      disabled={deletingVenueId === venue.id}
                      className="bg-red-500 text-white px-3 py-1 text-xs font-bold rounded hover:bg-red-600 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {deletingVenueId === venue.id ? '删除中...' : '🗑️ 删除'}
                    </button>
                  </div>
                )}

                {/* 内容区域 */}
                <div className="p-6">
                  <div className="flex items-start justify-between mb-3">
                    <div className="flex-1">
                      <Link
                        href={`/venues/${venue.id}`}
                        className="block"
                        onClick={(e) => e.stopPropagation()}
                      >
                        <h3 className="font-bold text-heading-sm mb-2 line-clamp-2 hover:underline">
                          {venue.name}
                        </h3>
                      </Link>
                      <div className="flex items-center gap-2 mb-2">
                        <span className="text-xs px-2 py-1 bg-gray-100 rounded uppercase">
                          {venue.sportType === 'basketball' ? '🏀 篮球' : '⚽ 足球'}
                        </span>
                        {venue.indoor && (
                          <span className="text-xs px-2 py-1 bg-blue-100 text-blue-700 rounded">
                            室内
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="text-body-sm text-textSecondary space-y-1">
                    {venue.address && (
                      <div className="flex items-center gap-2">
                        <span>📍</span>
                        <span className="text-xs line-clamp-1">{venue.address}</span>
                      </div>
                    )}
                    {venue.contact && (
                      <div className="flex items-center gap-2">
                        <span>📞</span>
                        <span className="text-xs line-clamp-1">{venue.contact}</span>
                      </div>
                    )}
                    <div className="flex items-center gap-4">
                      {venue.price !== undefined && venue.price > 0 && (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">¥{venue.price.toFixed(2)}/小时</span>
                        </div>
                      )}
                      {venue.price === 0 && (
                        <div className="flex items-center gap-1">
                          <span>💰</span>
                          <span className="text-xs">免费</span>
                        </div>
                      )}
                      {venue.reviewCount > 0 && (
                        <div className="flex items-center gap-1">
                          <span>⭐</span>
                          <span className="text-xs">{venue.avgRating.toFixed(1)} ({venue.reviewCount})</span>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* 分页 */}
          {totalPages > 1 && (
            <div className="flex items-center justify-center gap-4">
              <button
                onClick={() => setPage(p => Math.max(1, p - 1))}
                disabled={page === 1}
                className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                上一页
              </button>
              
              <span className="text-body text-textSecondary">
                第 {page} / {totalPages} 页
              </span>
              
              <button
                onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                disabled={page === totalPages}
                className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                下一页
              </button>
            </div>
          )}
        </>
      )}
    </div>
  )
}

