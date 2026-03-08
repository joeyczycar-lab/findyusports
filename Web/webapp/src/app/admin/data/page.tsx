"use client"

import { useEffect, useState } from 'react'
import { fetchJson } from '@/lib/api'

export default function DataViewPage() {
  const [stats, setStats] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  useEffect(() => {
    if (mounted) {
      loadStats()
    }
  }, [mounted])

  async function loadStats() {
    try {
      setLoading(true)
      setError(null)
      console.log('📊 [Data Page] Starting to load stats...')
      
      // 获取所有场地数据（不使用坐标参数，获取所有场地）
      // 使用较大的 pageSize 获取所有数据
      let allVenues: any[] = []
      let page = 1
      const pageSize = 100
      let hasMore = true
      
      while (hasMore) {
        try {
          const params = new URLSearchParams({
            page: String(page),
            pageSize: String(pageSize),
            sortBy: 'name', // 按名称排序
          })
          
          console.log(`📊 [Data Page] Fetching page ${page}...`)
          const venuesData = await fetchJson(`/venues?${params.toString()}`)
          console.log(`📊 [Data Page] Received response for page ${page}:`, {
            hasError: !!venuesData.error,
            itemsCount: venuesData.items?.length || 0,
            total: venuesData.total || 0,
          })
          
          // 检查是否有错误
          if (venuesData.error) {
            console.error(`❌ [Data Page] Error in response:`, venuesData.error)
            throw new Error(venuesData.error.message || '获取场地数据失败')
          }
          
          const items = venuesData.items || []
          const total = venuesData.total || 0
          
          allVenues = [...allVenues, ...items]
          
          console.log(`📊 [Data Page] Loaded page ${page}: ${items.length} items, total: ${total}, accumulated: ${allVenues.length}`)
          
          // 如果返回的数据少于 pageSize，或者已经获取了所有数据，说明没有更多数据了
          if (items.length < pageSize || allVenues.length >= total) {
            hasMore = false
          } else {
            page++
          }
          
          // 防止无限循环，最多获取 1000 个场地
          if (allVenues.length >= 1000) {
            console.warn('⚠️ [Data Page] Reached maximum limit of 1000 venues')
            hasMore = false
          }
          
          // 防止无限循环，最多尝试 20 页
          if (page > 20) {
            console.warn('⚠️ [Data Page] Reached maximum page limit of 20')
            hasMore = false
          }
        } catch (pageError: any) {
          console.error(`❌ [Data Page] Error loading page ${page}:`, pageError)
          // 如果第一页就失败，抛出错误
          if (page === 1) {
            throw pageError
          }
          // 如果后续页面失败，停止加载，使用已加载的数据
          hasMore = false
        }
      }
      
      const venues = allVenues
      console.log(`📊 [Data Page] Total venues loaded: ${venues.length}`)
      
      // 统计信息
      const stats = {
        totalVenues: venues.length,
        basketballVenues: venues.filter((v: any) => v.sportType === 'basketball').length,
        footballVenues: venues.filter((v: any) => v.sportType === 'football').length,
        indoorVenues: venues.filter((v: any) => v.indoor === true).length,
        outdoorVenues: venues.filter((v: any) => v.indoor === false).length,
        // 兼容 price 和 priceMin 两种字段名（API 可能返回 price）
        venuesWithPrice: venues.filter((v: any) => {
          const price = v.priceMin ?? v.price ?? 0
          return price > 0
        }).length,
        freeVenues: venues.filter((v: any) => {
          const price = v.priceMin ?? v.price ?? 0
          return price === 0
        }).length,
        venues: venues,
      }
      
      console.log('📊 [Data Page] Stats calculated:', stats)
      setStats(stats)
      console.log('✅ [Data Page] Successfully loaded all data')
    } catch (err: any) {
      console.error('❌ [Data Page] Failed to load data:', err)
      const errorMessage = err.message || '加载数据失败'
      setError(errorMessage)
      console.error('❌ [Data Page] Error details:', {
        message: errorMessage,
        error: err,
        stack: err.stack,
      })
    } finally {
      setLoading(false)
    }
  }

  // 在客户端挂载之前，返回一个简单的加载状态，避免 hydration 错误
  if (!mounted) {
    return (
      <div className="container-page py-8">
        <div className="mb-8">
          <h1 className="text-heading font-bold mb-2">数据统计</h1>
          <p className="text-body text-textSecondary">加载中...</p>
        </div>
        <div className="text-center py-16 text-textSecondary">
          加载中...
        </div>
      </div>
    )
  }

  return (
    <div className="container-page py-8">
      <div className="mb-8">
        <h1 className="text-heading font-bold mb-2">数据统计</h1>
        <p className="text-body text-textSecondary">
          查看数据库中的所有数据统计信息
        </p>
      </div>

      {loading && (
        <div className="text-center py-16 text-textSecondary">
          <div className="mb-4">加载中...</div>
          <div className="text-sm text-textMuted">正在获取场地数据...</div>
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-6">
          <div className="font-bold mb-2">❌ {error}</div>
          <div className="text-sm mt-2">
            请检查：
            <ul className="list-disc list-inside mt-1">
              <li>后端服务是否正常运行</li>
              <li>打开浏览器控制台（F12）查看详细错误</li>
              <li>检查 Network 标签页中的 API 请求</li>
            </ul>
          </div>
          <button
            onClick={() => {
              setError(null)
              setLoading(true)
              loadStats()
            }}
            className="mt-4 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
          >
            重试
          </button>
        </div>
      )}

      {!loading && !error && stats && (
        <>
          {/* 统计卡片 */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.totalVenues}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">场地总数</div>
            </div>
            
            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.basketballVenues}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">⚽ 篮球场地</div>
            </div>
            
            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.footballVenues}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">⚽ 足球场地</div>
            </div>
            
            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.indoorVenues}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">室内场地</div>
            </div>
          </div>

          {/* 详细统计 */}
          <div className="card-nike p-6 mb-8">
            <h2 className="text-heading-sm font-bold mb-4">详细统计</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div>
                <div className="text-body-sm text-textSecondary mb-1">室外场地</div>
                <div className="text-heading-sm font-bold">{stats.outdoorVenues}</div>
              </div>
              <div>
                <div className="text-body-sm text-textSecondary mb-1">收费场地</div>
                <div className="text-heading-sm font-bold">{stats.venuesWithPrice}</div>
              </div>
              <div>
                <div className="text-body-sm text-textSecondary mb-1">免费场地</div>
                <div className="text-heading-sm font-bold">{stats.freeVenues}</div>
              </div>
            </div>
          </div>

          {/* 场地列表 */}
          <div className="card-nike p-6">
            <h2 className="text-heading-sm font-bold mb-4">所有场地 ({stats.venues.length})</h2>
            <div className="overflow-x-auto">
              <table className="w-full text-left">
                <thead>
                  <tr className="border-b border-gray-200">
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">ID</th>
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">名称</th>
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">类型</th>
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">城市</th>
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">价格</th>
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">室内</th>
                  </tr>
                </thead>
                <tbody>
                  {stats.venues.map((venue: any) => (
                    <tr key={venue.id} className="border-b border-gray-100">
                      <td className="py-3 text-body-sm">{venue.id}</td>
                      <td className="py-3 text-body-sm font-medium">{venue.name}</td>
                      <td className="py-3 text-body-sm">
                        {venue.sportType === 'basketball' ? '⚽' : '⚽'}
                      </td>
                      <td className="py-3 text-body-sm">{venue.cityCode || '-'}</td>
                      <td className="py-3 text-body-sm">
                        {(venue.priceMin ?? venue.price ?? 0) > 0 ? `¥${(venue.priceMin ?? venue.price).toFixed(2)}` : '免费'}
                      </td>
                      <td className="py-3 text-body-sm">
                        {venue.indoor ? '是' : '否'}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </>
      )}
    </div>
  )
}

