'use client'

import { useState } from 'react'
import { X, Eye, EyeOff } from 'lucide-react'
import { setAuthState } from '@/lib/auth'

interface LoginModalProps {
  isOpen: boolean
  onClose: () => void
  onSuccess: (user: any, token: string) => void
}

export default function LoginModal({ isOpen, onClose, onSuccess }: LoginModalProps) {
  const [isLogin, setIsLogin] = useState(true)
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [formData, setFormData] = useState({
    phone: '',
    password: '',
    nickname: ''
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    try {
      // 使用 Next.js API 路由作为代理
      const endpoint = isLogin ? '/api/auth/login' : '/api/auth/register'
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      })

      // 安全地解析 JSON
      const text = await response.text()
      let data: any
      
      if (!text || text.trim().length === 0) {
        throw new Error('服务器返回了空响应')
      }
      
      try {
        data = JSON.parse(text)
      } catch (parseError) {
        console.error('❌ [LoginModal] JSON 解析错误:', parseError)
        console.error('Response text:', text.substring(0, 500))
        throw new Error(`响应解析失败: ${parseError instanceof Error ? parseError.message : String(parseError)}`)
      }

      if (!response.ok) {
        let errorMsg = data.message || data.error?.message || '操作失败'
        // 转换英文错误信息为中文
        if (errorMsg.includes('Unauthorized')) {
          errorMsg = '未授权，请先登录'
        } else if (errorMsg.includes('Invalid credentials')) {
          errorMsg = '用户名或密码错误'
        } else if (errorMsg.includes('User already exists')) {
          errorMsg = '用户已存在'
        } else if (errorMsg.includes('User not found')) {
          errorMsg = '用户不存在'
        }
        throw new Error(errorMsg)
      }

      // 保存认证信息到 localStorage
      if (data.user && data.token) {
        console.log('✅ [LoginModal] Login successful, user:', {
          id: data.user.id,
          phone: data.user.phone,
          role: data.user.role,
          nickname: data.user.nickname,
        })
        setAuthState(data.user, data.token)
      } else {
        console.error('❌ [LoginModal] Missing user or token in response:', data)
      }

      onSuccess(data.user, data.token)
      onClose()
      setFormData({ phone: '', password: '', nickname: '' })
    } catch (err: any) {
      let errorMsg = err.message || '网络错误，请检查后端服务是否正常运行'
      // 确保错误信息是中文
      if (errorMsg.includes('Failed to fetch') || errorMsg.includes('fetch')) {
        errorMsg = '无法连接到服务器，请检查网络连接'
      } else if (errorMsg.includes('Unauthorized')) {
        errorMsg = '未授权，请先登录'
      } else if (errorMsg.includes('401')) {
        errorMsg = '登录失败，用户名或密码错误'
      }
      setError(errorMsg)
    } finally {
      setLoading(false)
    }
  }

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }))
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white w-full max-w-md" style={{ borderRadius: '4px' }}>
        <div className="flex items-center justify-between p-6 border-b">
          <h2 className="text-xl font-semibold">
            {isLogin ? '登录' : '注册'}
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600"
          >
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {error && (
            <div className="bg-red-50 border border-red-200 text-red-600 px-4 py-3" style={{ borderRadius: '4px' }}>
              {error}
            </div>
          )}

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              手机号
            </label>
            <input
              type="tel"
              name="phone"
              value={formData.phone}
              onChange={handleInputChange}
              placeholder="请输入手机号"
              className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
              style={{ borderRadius: '4px' }}
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              密码
            </label>
            <div className="relative">
              <input
                type={showPassword ? 'text' : 'password'}
                name="password"
                value={formData.password}
                onChange={handleInputChange}
                placeholder="请输入密码"
                className="w-full px-3 py-2 pr-10 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                style={{ borderRadius: '4px' }}
                required
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          {!isLogin && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                昵称（可选）
              </label>
              <input
                type="text"
                name="nickname"
                value={formData.nickname}
                onChange={handleInputChange}
                placeholder="请输入昵称"
                className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                style={{ borderRadius: '4px' }}
              />
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 text-white py-2 px-4 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            style={{ borderRadius: '4px' }}
          >
            {loading ? '处理中...' : (isLogin ? '登录' : '注册')}
          </button>

          <div className="text-center">
            <button
              type="button"
              onClick={() => setIsLogin(!isLogin)}
              className="text-blue-600 hover:text-blue-700 text-sm"
            >
              {isLogin ? '没有账号？立即注册' : '已有账号？立即登录'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
