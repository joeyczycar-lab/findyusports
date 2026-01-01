'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { fetchJson } from '@/lib/api'
import { getAuthState } from '@/lib/auth'
import LoginModal from '@/components/LoginModal'

type Stats = {
  totalViews: number
  todayViews: number
  weekViews: number
  monthViews: number
  viewsByPath: Array<{ path: string; count: number }>
  viewsByType: Array<{ pageType: string; count: number }>
}

export default function AnalyticsPage() {
  const router = useRouter()
  const [stats, setStats] = useState<Stats | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [mounted, setMounted] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false)

  useEffect(() => {
    setMounted(true)
    setAuthState(getAuthState())
  }, [])

  useEffect(() => {
    if (mounted) {
      // 检查是否已登录且是管理员
      if (!authState.isAuthenticated) {
        setIsLoginModalOpen(true)
        return
      }
      if (authState.user?.role !== 'admin') {
        setError('只有管理员可以查看访问统计')
        setLoading(false)
        return
      }
      loadStats()
    }
  }, [mounted, authState])

  const handleLoginSuccess = () => {
    setIsLoginModalOpen(false)
    setAuthState(getAuthState())
    // 重新加载数据
    if (authState.user?.role === 'admin') {
      loadStats()
    }
  }

  async function loadStats() {
    try {
      setLoading(true)
      setError(null)
      console.log('📊 [Analytics Page] Loading stats...')

      // fetchJson 会自动通过 getAuthHeader() 添加 Authorization header
      const data = await fetchJson<Stats>('/analytics/stats')

      if ('error' in data) {
        throw new Error(data.error?.message || '获取统计数据失败')
      }

      console.log('✅ [Analytics Page] Stats loaded:', data)
      setStats(data)
    } catch (err: any) {
      console.error('❌ [Analytics Page] Error:', err)
      setError(err.message || '加载统计数据失败')
    } finally {
      setLoading(false)
    }
  }

  if (!mounted) {
    return null
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 p-6">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-3xl font-bold mb-6">访问统计</h1>
          <div className="bg-white rounded-lg shadow p-6">
            <div className="text-center py-12">
              <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
              <p className="mt-4 text-gray-600">加载中...</p>
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <>
        <LoginModal
          isOpen={isLoginModalOpen}
          onClose={() => setIsLoginModalOpen(false)}
          onSuccess={handleLoginSuccess}
        />
        <div className="min-h-screen bg-gray-50 p-6">
          <div className="max-w-7xl mx-auto">
            <h1 className="text-3xl font-bold mb-6">访问统计</h1>
            <div className="bg-white rounded-lg shadow p-6">
              <div className="text-center py-12">
                <p className="text-red-600 mb-4">❌ {error}</p>
                {error.includes('Unauthorized') || error.includes('未授权') || error.includes('管理员') ? (
                  <div>
                    <p className="text-gray-600 mb-4">请先登录管理员账号</p>
                    <button
                      onClick={() => setIsLoginModalOpen(true)}
                      className="px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark mr-2"
                    >
                      登录
                    </button>
                    <button
                      onClick={() => router.push('/')}
                      className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
                    >
                      返回首页
                    </button>
                  </div>
                ) : (
                  <button
                    onClick={loadStats}
                    className="px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark"
                  >
                    重试
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>
      </>
    )
  }

  if (!stats) {
    return null
  }

  return (
    <>
      <LoginModal
        isOpen={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        onSuccess={handleLoginSuccess}
      />
      <div className="min-h-screen bg-gray-50 p-6">
        <div className="max-w-7xl mx-auto">
          <div className="flex items-center justify-between mb-6">
            <h1 className="text-3xl font-bold">访问统计</h1>
            <div className="flex gap-4">
              <Link
                href="/admin/venues"
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
              >
                场地管理
              </Link>
              <Link
                href="/admin/data"
                className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300"
              >
                数据概览
              </Link>
            </div>
          </div>

        {/* 概览卡片 */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-sm font-medium text-gray-500 mb-2">总访问量</h3>
            <p className="text-3xl font-bold text-primary">{stats.totalViews.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-sm font-medium text-gray-500 mb-2">今日访问</h3>
            <p className="text-3xl font-bold text-green-600">{stats.todayViews.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-sm font-medium text-gray-500 mb-2">近7天访问</h3>
            <p className="text-3xl font-bold text-blue-600">{stats.weekViews.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-sm font-medium text-gray-500 mb-2">近30天访问</h3>
            <p className="text-3xl font-bold text-purple-600">{stats.monthViews.toLocaleString()}</p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* 按页面路径统计 */}
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4">热门页面</h2>
            {stats.viewsByPath.length > 0 ? (
              <div className="space-y-3">
                {stats.viewsByPath.map((item, index) => (
                  <div key={item.path} className="flex items-center justify-between">
                    <div className="flex items-center">
                      <span className="text-gray-400 mr-2">#{index + 1}</span>
                      <span className="text-sm font-medium">{item.path}</span>
                    </div>
                    <span className="text-sm font-bold text-primary">{item.count.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-gray-500 text-center py-8">暂无数据</p>
            )}
          </div>

          {/* 按页面类型统计 */}
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-xl font-bold mb-4">页面类型分布</h2>
            {stats.viewsByType.length > 0 ? (
              <div className="space-y-3">
                {stats.viewsByType.map((item) => (
                  <div key={item.pageType} className="flex items-center justify-between">
                    <span className="text-sm font-medium capitalize">{item.pageType}</span>
                    <span className="text-sm font-bold text-primary">{item.count.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-gray-500 text-center py-8">暂无数据</p>
            )}
          </div>
        </div>

        {/* 刷新按钮 */}
        <div className="mt-6 text-center">
          <button
            onClick={loadStats}
            className="px-6 py-2 bg-primary text-white rounded hover:bg-primary-dark"
          >
            刷新数据
          </button>
        </div>
      </div>
    </div>
    </>
  )
}

