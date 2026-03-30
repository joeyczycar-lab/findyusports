'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { fetchJson } from '@/lib/api'
import { getAuthState, getAuthHeader } from '@/lib/auth'
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
      console.log('📊 [Analytics Page] useEffect triggered, authState:', {
        isAuthenticated: authState.isAuthenticated,
        userRole: authState.user?.role,
      })
      
      // 检查是否已登录且是管理员
      if (!authState.isAuthenticated) {
        console.log('📊 [Analytics Page] Not authenticated, showing login modal')
        setError('请先登录管理员账号后查看访问统计')
        setIsLoginModalOpen(true)
        setLoading(false)
        return
      }
      if (authState.user?.role !== 'admin') {
        console.warn('📊 [Analytics Page] Not admin, role:', authState.user?.role)
        setError(`只有管理员可以查看访问统计。当前用户角色: ${authState.user?.role || '未设置'}。请重新登录以刷新用户信息。`)
        setLoading(false)
        return
      }
      console.log('📊 [Analytics Page] Calling loadStats...')
      loadStats()
    }
  }, [mounted, authState])

  const handleLoginSuccess = () => {
    setIsLoginModalOpen(false)
    // 重新获取认证状态
    const newAuthState = getAuthState()
    setAuthState(newAuthState)
    console.log('📊 [Analytics Page] After login, auth state:', {
      isAuthenticated: newAuthState.isAuthenticated,
      userRole: newAuthState.user?.role,
      userId: newAuthState.user?.id,
    })
    // 重新加载数据
    if (newAuthState.user?.role === 'admin') {
      loadStats()
    } else {
      setError(`当前用户角色: ${newAuthState.user?.role || '未设置'}，需要管理员权限`)
      setLoading(false)
    }
  }

  async function loadStats() {
    try {
      setLoading(true)
      setError(null)
      console.log('📊 [Analytics Page] Loading stats...')
      
      // 检查认证状态
      const currentAuth = getAuthState()
      console.log('📊 [Analytics Page] Auth state:', {
        isAuthenticated: currentAuth.isAuthenticated,
        hasToken: !!currentAuth.token,
        userRole: currentAuth.user?.role,
        userId: currentAuth.user?.id,
      })
      
      if (!currentAuth.isAuthenticated || !currentAuth.token) {
        setError('请先登录管理员账号后查看访问统计')
        setIsLoginModalOpen(true)
        setLoading(false)
        return
      }

      // 检查 Authorization header
      const authHeader = getAuthHeader()
      console.log('📊 [Analytics Page] Auth header:', authHeader)
      
      // fetchJson 会自动通过 getAuthHeader() 添加 Authorization header
      const data = await fetchJson<Stats>('/analytics/stats')

      // 检查响应是否包含错误
      if (data && typeof data === 'object' && 'error' in data) {
        const errorMsg = (data as any).error?.message || '获取统计数据失败'
        console.error('❌ [Analytics Page] API returned error:', errorMsg)
        throw new Error(errorMsg)
      }
      
      // 检查是否是有效的统计数据
      if (!data || typeof data !== 'object' || !('totalViews' in data)) {
        console.error('❌ [Analytics Page] Invalid response format:', data)
        throw new Error('服务器返回了无效的数据格式')
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
                {(error.includes('Unauthorized') || error.includes('未授权') || error.includes('管理员') || error.includes('角色') || error.includes('401')) ? (
                  <div>
                    <p className="text-gray-600 mb-4">请重新登录以刷新用户信息</p>
                    <button
                      onClick={() => {
                        // 清除旧的认证信息
                        if (typeof window !== 'undefined') {
                          localStorage.removeItem('auth_token')
                          localStorage.removeItem('auth_user')
                        }
                        setIsLoginModalOpen(true)
                      }}
                      className="px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark mr-2"
                    >
                      重新登录
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

