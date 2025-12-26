"use client"

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import { useRouter } from 'next/navigation'

export default function VenuesListPage() {
  const router = useRouter()
  const [venues, setVenues] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(0)
  const pageSize = 20

  useEffect(() => {
    loadVenues()
  }, [page])

  async function loadVenues() {
    try {
      setLoading(true)
      setError(null)
      
      // 使用一个较大的边界范围来获取所有场地
      // 中国大致范围：经度 73-135，纬度 18-54
      const data = await fetchJson(`/venues?ne=135,54&sw=73,18&page=${page}&pageSize=${pageSize}`)
      
      console.log('📊 API返回数据:', data)
      
      // 检查是否有错误
      if (data.error) {
        throw new Error(data.error.message || '获取场地列表失败')
      }
      
      const items = data.items || []
      const total = data.total || 0
      
      console.log(`✅ 加载到 ${items.length} 个场地，总共 ${total} 个`)
      
      setVenues(items)
      setTotal(total)
    } catch (err: any) {
      console.error('❌ 加载场地失败:', err)
      setError(err.message || '加载场地失败')
      // 即使出错也设置空数组，避免显示"没有场地"
      setVenues([])
      setTotal(0)
    } finally {
      setLoading(false)
    }
  }

  const totalPages = Math.ceil(total / pageSize)

  return (
    <div className="container-page py-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-heading font-bold mb-2">场地管理</h1>
          <p className="text-body text-textSecondary">
            共 {total} 个场地 · 第 {page} / {totalPages} 页
          </p>
        </div>
        <div className="flex gap-4">
          <Link 
            href="/admin/add-venue" 
            className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors"
            style={{ borderRadius: '4px' }}
          >
            ➕ 添加场地
          </Link>
          <Link 
            href="/map" 
            className="bg-gray-100 text-black px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-200 transition-colors"
            style={{ borderRadius: '4px' }}
          >
            🗺️ 查看地图
          </Link>
        </div>
      </div>

      {loading && (
        <div className="text-center py-16 text-textSecondary">
          加载中...
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-6">
          ❌ {error}
        </div>
      )}

      {!loading && !error && venues.length === 0 && (
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

      {!loading && !error && venues.length > 0 && (
        <>
          <div className="mb-4 text-sm text-textSecondary">
            显示 {venues.length} 个场地（共 {total} 个）
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            {venues.map((venue) => {
              console.log('渲染场地:', venue)
              return (
              <Link
                key={venue.id}
                href={`/venues/${venue.id}`}
                className="card-nike p-6 hover:shadow-lg transition-shadow"
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex-1">
                    <h3 className="font-bold text-heading-sm mb-2 line-clamp-2">
                      {venue.name}
                    </h3>
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
                  {venue.location && (
                    <div className="flex items-center gap-2">
                      <span>📍</span>
                      <span>
                        {venue.location[0].toFixed(4)}, {venue.location[1].toFixed(4)}
                      </span>
                    </div>
                  )}
                  {venue.price !== undefined && venue.price > 0 && (
                    <div className="flex items-center gap-2">
                      <span>💰</span>
                      <span>¥{venue.price}/小时</span>
                    </div>
                  )}
                  {venue.price === 0 && (
                    <div className="flex items-center gap-2">
                      <span>💰</span>
                      <span>免费</span>
                    </div>
                  )}
                </div>

                <div className="mt-4 pt-4 border-t border-gray-200">
                  <div className="text-xs text-textSecondary uppercase tracking-wide">
                    ID: {venue.id}
                  </div>
                </div>
              </Link>
            )
            })}
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

