"use client"

import { useEffect, useRef, useState, ChangeEvent } from 'react'
import { fetchJson } from '@/lib/api'
import Link from 'next/link'

// 轻量 CSV 解析（支持双引号、逗号转义、换行），与后端批量导入口径一致
function parseCsv(text: string): string[][] {
  const rows: string[][] = []
  let row: string[] = []
  let field = ''
  let inQuotes = false
  for (let i = 0; i < text.length; i++) {
    const ch = text[i]
    if (inQuotes) {
      if (ch === '"') {
        if (text[i + 1] === '"') { field += '"'; i++ } else inQuotes = false
      } else field += ch
    } else {
      if (ch === '"') inQuotes = true
      else if (ch === ',') { row.push(field); field = '' }
      else if (ch === '\n') { row.push(field); rows.push(row); row = []; field = '' }
      else if (ch === '\r') { /* skip */ }
      else field += ch
    }
  }
  if (field.length > 0 || row.length > 0) { row.push(field); rows.push(row) }
  return rows.filter((r) => r.some((c) => c.trim() !== ''))
}

function csvToObjects(text: string): Record<string, string>[] {
  const rows = parseCsv(text)
  if (rows.length < 2) return []
  const headers = rows[0].map((h) => h.trim())
  return rows.slice(1).map((cells) => {
    const obj: Record<string, string> = {}
    headers.forEach((h, idx) => (obj[h] = (cells[idx] ?? '').trim()))
    return obj
  })
}

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

  // 批量导入
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [importRows, setImportRows] = useState<Record<string, string>[]>([])
  const [importing, setImporting] = useState(false)
  const [importReport, setImportReport] = useState<any>(null)
  const [importError, setImportError] = useState<string | null>(null)

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

  function handlePickFile(e: ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    setImportError(null)
    setImportReport(null)
    if (!file) { setImportRows([]); return }
    const reader = new FileReader()
    reader.onload = () => {
      try {
        const rows = csvToObjects(String(reader.result || ''))
        setImportRows(rows)
        if (rows.length === 0) setImportError('CSV 未解析到有效数据行，请检查表头与格式')
      } catch (err: any) {
        setImportRows([])
        setImportError(err instanceof Error ? err.message : 'CSV 解析失败')
      }
    }
    reader.readAsText(file, 'utf-8')
  }

  async function handleImport() {
    if (importRows.length === 0) return
    setImporting(true)
    setImportError(null)
    setImportReport(null)
    try {
      const report = await fetchJson('/venues/admin/bulk-import', {
        method: 'POST',
        body: JSON.stringify({ rows: importRows }),
      })
      if (report?.error) throw new Error(report.error.message || '导入失败')
      setImportReport(report)
      setImportRows([])
      if (fileInputRef.current) fileInputRef.current.value = ''
      // 导入完成后刷新统计与列表
      loadStats()
    } catch (err: any) {
      setImportError(err instanceof Error ? err.message : '导入失败')
    } finally {
      setImporting(false)
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

          {/* 批量导入 */}
          <div className="card-nike p-6 mb-8">
            <h2 className="text-heading-sm font-bold mb-2">批量导入场地</h2>
            <p className="text-body-sm text-textSecondary mb-4">
              上传对齐导入模板的 CSV（可含 <code>firstImage</code> 首图链接列）。系统逐条校验并按「运动类型 + 城市 + 名称/地址」自动查重，重复与不合格条目会在报告中列出，不会入库。
            </p>

            <input
              ref={fileInputRef}
              type="file"
              accept=".csv,text/csv"
              className="hidden"
              onChange={handlePickFile}
            />
            <div className="flex items-center gap-3 flex-wrap">
              <button
                onClick={() => fileInputRef.current?.click()}
                disabled={importing}
                className="px-4 py-2 bg-gray-100 text-black rounded hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed text-sm font-bold"
              >
                选择 CSV 文件
              </button>
              {importRows.length > 0 && (
                <span className="text-body-sm text-textSecondary">已解析 {importRows.length} 条待导入</span>
              )}
              <button
                onClick={handleImport}
                disabled={importing || importRows.length === 0}
                className="px-4 py-2 bg-black text-white rounded hover:bg-gray-900 disabled:opacity-50 disabled:cursor-not-allowed text-sm font-bold"
              >
                {importing ? '导入中…' : `开始导入（${importRows.length}）`}
              </button>
            </div>

            {importError && (
              <div className="mt-4 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded text-sm">
                ❌ {importError}
              </div>
            )}

            {importReport && (
              <div className="mt-4">
                <div className="grid grid-cols-3 gap-4 mb-4">
                  <div>
                    <div className="text-heading-sm font-bold">{importReport.total}</div>
                    <div className="text-body-sm text-textSecondary">总数</div>
                  </div>
                  <div>
                    <div className="text-heading-sm font-bold text-green-600">{importReport.success}</div>
                    <div className="text-body-sm text-textSecondary">成功入库</div>
                  </div>
                  <div>
                    <div className="text-heading-sm font-bold text-amber-600">{importReport.skipped}</div>
                    <div className="text-body-sm text-textSecondary">跳过</div>
                  </div>
                </div>

                {importReport.skippedList?.length > 0 && (
                  <div className="border border-gray-200 rounded p-4">
                    <div className="font-bold text-body-sm mb-2">跳过明细（{importReport.skippedList.length}）</div>
                    <ul className="list-disc list-inside text-body-sm text-textSecondary space-y-1 max-h-48 overflow-y-auto">
                      {importReport.skippedList.map((s: any, i: number) => (
                        <li key={i}>{s.name} — {s.reason}</li>
                      ))}
                    </ul>
                  </div>
                )}

                {importReport.successList?.length > 0 && (
                  <div className="mt-3 text-body-sm text-textSecondary">
                    已入库 {importReport.successList.length} 条，其中挂载首图 {importReport.successList.filter((x: any) => x.image).length} 条。
                    {importReport.successList.some((x: any) => !x.image) && (
                      <ul className="list-disc list-inside mt-2 space-y-1 max-h-40 overflow-y-auto">
                        {importReport.successList.filter((x: any) => !x.image).map((x: any, i: number) => (
                          <li key={i}>{x.name} — {x.imageReason || '未挂图'}</li>
                        ))}
                      </ul>
                    )}
                  </div>
                )}
              </div>
            )}
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
