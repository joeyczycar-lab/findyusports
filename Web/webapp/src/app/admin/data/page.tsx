"use client"

import { useEffect, useState } from 'react'
import { fetchJson } from '@/lib/api'
import Link from 'next/link'

export default function DataViewPage() {
  const [stats, setStats] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [mounted, setMounted] = useState(false)

  // 表格分页：按需加载单页，避免一次性渲染数万行导致浏览器卡死
  const [rows, setRows] = useState<any[]>([])
  const [tablePage, setTablePage] = useState(1)
  const [tableTotal, setTableTotal] = useState(0)
  const [tableLoading, setTableLoading] = useState(false)
  const TABLE_PAGE_SIZE = 50

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
      // 用最小数据量（pageSize=1）拿到真实总数与各类筛选总数，
      // 不拉取全部 5.8 万条，既准确又不拖垮浏览器
      const [all, bk, fb, indoor, paid, free] = await Promise.all([
        fetchJson('/venues?pageSize=1'),
        fetchJson('/venues?sport=basketball&pageSize=1'),
        fetchJson('/venues?sport=football&pageSize=1'),
        fetchJson('/venues?indoor=true&pageSize=1'),
        fetchJson('/venues?minPrice=1&pageSize=1'),
        fetchJson('/venues?minPrice=0&maxPrice=0&pageSize=1'),
      ])

      const total = all.total || 0
      const basketball = bk.total || 0
      const football = fb.total || 0
      const indoorCount = indoor.total || 0
      const withPrice = paid.total || 0
      const freeCount = free.total || 0

      setStats({
        totalVenues: total,
        basketballVenues: basketball,
        footballVenues: football,
        indoorVenues: indoorCount,
        outdoorVenues: total - indoorCount,
        venuesWithPrice: withPrice,
        freeVenues: freeCount,
      })
      setTableTotal(total)
      setLoading(false)
      await loadTablePage(1)
    } catch (err: any) {
      console.error('❌ [Data Page] Failed to load data:', err)
      setError(err.message || '加载数据失败')
      setLoading(false)
    }
  }

  async function loadTablePage(p: number) {
    try {
      setTableLoading(true)
      const data = await fetchJson(`/venues?page=${p}&pageSize=${TABLE_PAGE_SIZE}&sortBy=name`)
      setRows(data.items || [])
      if (typeof data.total === 'number') setTableTotal(data.total)
      setTablePage(p)
    } catch (err: any) {
      setError(err.message || '加载列表失败')
    } finally {
      setTableLoading(false)
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

  const totalPages = Math.max(1, Math.ceil(tableTotal / TABLE_PAGE_SIZE))

  return (
    <div className="container-page py-8">
      <div className="mb-8 flex items-start justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-heading font-bold mb-2">数据统计</h1>
          <p className="text-body text-textSecondary">
            查看数据库中的所有数据统计信息
          </p>
        </div>
        <Link
          href="/admin/analytics"
          className="px-4 py-2 bg-black text-white text-sm font-bold rounded hover:bg-gray-900"
        >
          查看浏览统计
        </Link>
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
              <div className="text-3xl font-bold mb-2">{stats.totalVenues.toLocaleString()}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">场地总数</div>
            </div>

            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.basketballVenues.toLocaleString()}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">⚽ 篮球场地</div>
            </div>

            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.footballVenues.toLocaleString()}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">⚽ 足球场地</div>
            </div>

            <div className="card-nike p-6">
              <div className="text-3xl font-bold mb-2">{stats.indoorVenues.toLocaleString()}</div>
              <div className="text-body-sm text-textSecondary uppercase tracking-wide">室内场地</div>
            </div>
          </div>

          {/* 详细统计 */}
          <div className="card-nike p-6 mb-8">
            <h2 className="text-heading-sm font-bold mb-4">详细统计</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div>
                <div className="text-body-sm text-textSecondary mb-1">室外场地</div>
                <div className="text-heading-sm font-bold">{stats.outdoorVenues.toLocaleString()}</div>
              </div>
              <div>
                <div className="text-body-sm text-textSecondary mb-1">收费场地</div>
                <div className="text-heading-sm font-bold">{stats.venuesWithPrice.toLocaleString()}</div>
              </div>
              <div>
                <div className="text-body-sm text-textSecondary mb-1">免费场地</div>
                <div className="text-heading-sm font-bold">{stats.freeVenues.toLocaleString()}</div>
              </div>
            </div>
          </div>

          {/* 场地列表（分页加载，不一次性渲染全部） */}
          <div className="card-nike p-6">
            <h2 className="text-heading-sm font-bold mb-4">
              场地列表（第 {tablePage} / {totalPages} 页，共 {tableTotal.toLocaleString()} 个）
            </h2>
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
                  {rows.map((venue: any) => (
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

            {totalPages > 1 && (
              <div className="flex items-center justify-center gap-4 mt-6">
                <button
                  onClick={() => loadTablePage(Math.max(1, tablePage - 1))}
                  disabled={tablePage === 1 || tableLoading}
                  className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  上一页
                </button>
                <span className="text-body text-textSecondary">
                  第 {tablePage} / {totalPages} 页
                </span>
                <button
                  onClick={() => loadTablePage(Math.min(totalPages, tablePage + 1))}
                  disabled={tablePage === totalPages || tableLoading}
                  className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  下一页
                </button>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  )
}
