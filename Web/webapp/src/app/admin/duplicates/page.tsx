"use client"

import { useCallback, useEffect, useState } from 'react'
import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import { getAuthState } from '@/lib/auth'

type DupItem = {
  id: string | number
  name: string
  address?: string
  sportType?: string
  cityCode?: string
  lng?: number
  lat?: number
  approvalStatus?: string
}

type DupGroup = {
  key: string
  reason: '同名' | '同地址'
  name: string
  count: number
  items: DupItem[]
}

export default function DuplicatesPage() {
  const [mounted, setMounted] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())
  const [groups, setGroups] = useState<DupGroup[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [sport, setSport] = useState<'all' | 'basketball' | 'football'>('all')
  const [deletingId, setDeletingId] = useState<number | null>(null)
  const [refreshing, setRefreshing] = useState(false)

  const load = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)
      const params = new URLSearchParams()
      if (sport !== 'all') params.append('sport', sport)
      const data = await fetchJson(`/venues/duplicates?${params.toString()}`)
      if (data.error) throw new Error(data.error.message || '加载失败')
      setGroups(data.items || [])
    } catch (err: any) {
      setError(err.message || '加载重复场地失败')
      setGroups([])
    } finally {
      setLoading(false)
    }
  }, [sport])

  useEffect(() => {
    setMounted(true)
    setAuthState(getAuthState())
  }, [])

  useEffect(() => {
    load()
  }, [load])

  const handleDelete = async (item: DupItem) => {
    if (!confirm(`确定删除场地 "${item.name}"（ID: ${item.id}）吗？\n\n将同时删除其图片与评论，此操作不可撤销。`)) return
    try {
      setDeletingId(Number(item.id))
      const result = await fetchJson(`/venues/${item.id}/delete`, { method: 'POST' })
      if (result?.error) throw new Error(result.error.message || '删除失败')
      await load()
      alert('已删除，列表已刷新')
    } catch (e: any) {
      alert(e.message || '删除失败')
    } finally {
      setDeletingId(null)
    }
  }

  if (!mounted) {
    return (
      <div className="container-page py-8 text-textSecondary">加载中...</div>
    )
  }

  const isAdmin = authState.isAuthenticated && authState.user?.role === 'admin'
  const totalDupItems = groups.reduce((s, g) => s + g.count, 0)

  return (
    <div className="container-page py-8">
      <div className="flex flex-col gap-4 mb-8">
        <div className="flex items-center justify-between gap-4 flex-wrap">
          <div>
            <h1 className="text-heading font-bold mb-2">🔁 重复场地查重</h1>
            <p className="text-body text-textSecondary">
              共 {groups.length} 组疑似重复 · 涉及 {totalDupItems} 条场地
            </p>
          </div>
          <div className="flex gap-2 items-center flex-wrap">
            <select
              value={sport}
              onChange={(e) => setSport(e.target.value as any)}
              className="px-3 py-2 border border-gray-300 rounded text-sm bg-white"
            >
              <option value="all">全部运动</option>
              <option value="basketball">🏀 篮球</option>
              <option value="football">⚽ 足球</option>
            </select>
            <button
              onClick={async () => { setRefreshing(true); await load(); setRefreshing(false) }}
              className="px-4 py-2 border border-gray-300 rounded text-sm bg-white hover:bg-gray-50"
            >
              {refreshing ? '刷新中...' : '🔄 刷新'}
            </button>
            <Link
              href="/admin/add-venue"
              className="bg-black text-white px-5 py-2 text-sm font-bold hover:bg-gray-900 transition-colors"
              style={{ borderRadius: '4px' }}
            >
              ➕ 添加场地
            </Link>
          </div>
        </div>
        <p className="text-xs text-textSecondary">
          判定规则：同运动类型下，名称规范化后相同，或地址规范化后相同即归入一组。请人工核对后保留信息最全的一条，删除其余重复项。
        </p>
      </div>

      {loading && <div className="text-center py-16 text-textSecondary">加载中...</div>}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-6">❌ {error}</div>
      )}

      {!loading && !error && groups.length === 0 && (
        <div className="text-center py-16 text-textSecondary">
          <div className="text-4xl mb-4">✅</div>
          <div className="text-body">未发现疑似重复场地</div>
        </div>
      )}

      <div className="space-y-6">
        {groups.map((g) => (
          <div key={g.key} className="bg-white border border-gray-200 rounded-lg overflow-hidden">
            <div className="flex items-center justify-between gap-3 px-5 py-3 border-b border-gray-100 bg-gray-50">
              <div className="min-w-0">
                <span className={`text-xs px-2 py-1 rounded mr-2 ${g.reason === '同名' ? 'bg-blue-100 text-blue-700' : 'bg-amber-100 text-amber-700'}`}>
                  {g.reason}
                </span>
                <span className="font-bold text-heading-sm truncate">{g.name}</span>
              </div>
              <span className="text-xs text-textSecondary shrink-0">{g.count} 条</span>
            </div>
            <div className="divide-y divide-gray-100">
              {g.items.map((it) => (
                <div key={it.id} className="flex items-center gap-3 px-5 py-3 flex-wrap">
                  <div className="flex-1 min-w-[200px]">
                    <div className="flex items-center gap-2 mb-1">
                      <span className="text-xs text-textMuted font-mono">#{it.id}</span>
                      <span className="text-xs px-2 py-0.5 bg-gray-100 rounded uppercase">
                        {it.sportType === 'basketball' ? '🏀 篮球' : '⚽ 足球'}
                      </span>
                      {it.approvalStatus === 'pending' && <span className="text-xs px-2 py-0.5 bg-yellow-100 text-yellow-700 rounded">待审核</span>}
                      {it.approvalStatus === 'rejected' && <span className="text-xs px-2 py-0.5 bg-red-100 text-red-700 rounded">已拒绝</span>}
                    </div>
                    <div className="text-body-sm font-medium">{it.name}</div>
                    {it.address && <div className="text-xs text-textSecondary mt-0.5">{it.address}</div>}
                  </div>
                  <div className="flex gap-2 shrink-0">
                    <Link
                      href={`/admin/edit-venue/${it.id}`}
                      className="bg-blue-500 text-white px-3 py-1 text-xs font-bold rounded hover:bg-blue-600"
                    >
                      ✏️ 编辑
                    </Link>
                    {isAdmin && (
                      <button
                        onClick={() => handleDelete(it)}
                        disabled={deletingId === Number(it.id)}
                        className="bg-red-500 text-white px-3 py-1 text-xs font-bold rounded hover:bg-red-600 disabled:opacity-50"
                      >
                        {deletingId === Number(it.id) ? '删除中...' : '🗑️ 删除'}
                      </button>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
