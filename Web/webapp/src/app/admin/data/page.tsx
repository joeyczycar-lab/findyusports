"use client"

import { useEffect, useState } from 'react'
import { fetchJson } from '@/lib/api'

export default function DataViewPage() {
  const [stats, setStats] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadStats()
  }, [])

  async function loadStats() {
    try {
      setLoading(true)
      setError(null)
      
      // 获取所有场地数据
      const venuesData = await fetchJson('/venues?ne=135,54&sw=73,18&pageSize=1000')
      
      // 检查是否有错误
      if (venuesData.error) {
        throw new Error(venuesData.error.message || '获取场地数据失败')
      }
      
      const venues = venuesData.items || []
      
      // 统计信息
      const stats = {
        totalVenues: venues.length,
        basketballVenues: venues.filter((v: any) => v.sportType === 'basketball').length,
        footballVenues: venues.filter((v: any) => v.sportType === 'football').length,
        indoorVenues: venues.filter((v: any) => v.indoor === true).length,
        outdoorVenues: venues.filter((v: any) => v.indoor === false).length,
        venuesWithPrice: venues.filter((v: any) => v.price && v.price > 0).length,
        freeVenues: venues.filter((v: any) => !v.price || v.price === 0).length,
        venues: venues,
      }
      
      setStats(stats)
    } catch (err: any) {
      console.error('加载数据失败:', err)
      const errorMessage = err.message || '加载数据失败'
      setError(errorMessage)
      console.error('详细错误:', {
        message: errorMessage,
        error: err,
      })
    } finally {
      setLoading(false)
    }
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
          加载中...
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-6">
          ❌ {error}
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
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">🏀 篮球场地</div>
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
                    <th className="pb-3 text-body-sm font-bold uppercase tracking-wide">坐标</th>
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
                        {venue.sportType === 'basketball' ? '🏀' : '⚽'}
                      </td>
                      <td className="py-3 text-body-sm">{venue.cityCode || '-'}</td>
                      <td className="py-3 text-body-sm text-textSecondary">
                        {venue.location ? `${venue.location[0].toFixed(4)}, ${venue.location[1].toFixed(4)}` : '-'}
                      </td>
                      <td className="py-3 text-body-sm">
                        {venue.price ? `¥${venue.price}` : '免费'}
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

