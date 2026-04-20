'use client'

import { useEffect, useState } from 'react'
import { X, Eye, EyeOff } from 'lucide-react'
import { setAuthState } from '@/lib/auth'

interface LoginModalProps {
  isOpen: boolean
  onClose: () => void
  onSuccess: (user: any, token: string) => void
}

export default function LoginModal({ isOpen, onClose, onSuccess }: LoginModalProps) {
  const [mode, setMode] = useState<'login' | 'register' | 'reset'>('login')
  const [showPassword, setShowPassword] = useState(false)
  const [loading, setLoading] = useState(false)
  const [sendingCode, setSendingCode] = useState(false)
  const [countdown, setCountdown] = useState(0)
  const [resetMsg, setResetMsg] = useState('')
  const [error, setError] = useState('')
  const [formData, setFormData] = useState({
    phone: '',
    password: '',
    nickname: '',
    smsCode: '',
    newPassword: '',
  })

  const isLogin = mode === 'login'
  const isRegister = mode === 'register'
  const isReset = mode === 'reset'

  useEffect(() => {
    if (countdown <= 0) return
    const timer = setInterval(() => {
      setCountdown((prev) => (prev > 0 ? prev - 1 : 0))
    }, 1000)
    return () => clearInterval(timer)
  }, [countdown])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')
    setResetMsg('')

    try {
      if (isReset) {
        const response = await fetch('/api/auth/password-reset/reset', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            phone: formData.phone.trim(),
            code: formData.smsCode.trim(),
            newPassword: formData.newPassword.trim(),
          }),
          cache: 'no-store',
        })
        const data = await response.json().catch(() => ({}))
        if (!response.ok || data?.error) {
          throw new Error(data?.error?.message || data?.message || '重置密码失败')
        }
        setResetMsg('密码重置成功，请使用新密码登录')
        setMode('login')
        setFormData((prev) => ({
          ...prev,
          password: '',
          smsCode: '',
          newPassword: '',
        }))
        return
      }

      // 使用 Next.js API 路由作为代理
      const endpoint = isLogin ? '/api/auth/login' : '/api/auth/register'
      console.log('🔐 [LoginModal] Sending request to:', endpoint)
      console.log('🔐 [LoginModal] Request body:', { phone: formData.phone, password: '***' })
      
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
        cache: 'no-store',
      })
      
      console.log('📥 [LoginModal] Response received:', {
        status: response.status,
        statusText: response.statusText,
        ok: response.ok,
        url: response.url,
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
        } else if (errorMsg.includes('Internal server error') || errorMsg.includes('Internal Server Error')) {
          errorMsg = '服务器内部错误，请稍后重试。若持续出现请确认后端服务与数据库已正常启动。'
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
        console.log('💾 [LoginModal] Saving token to localStorage...')
        setAuthState(data.user, data.token)
        
        // 验证 token 是否已保存
        const savedToken = localStorage.getItem('auth_token')
        const savedUser = localStorage.getItem('auth_user')
        console.log('✅ [LoginModal] Token saved verification:', {
          tokenSaved: !!savedToken,
          tokenMatches: savedToken === data.token,
          userSaved: !!savedUser,
          tokenPreview: savedToken ? savedToken.substring(0, 30) + '...' : 'none',
        })
      } else {
        console.error('❌ [LoginModal] Missing user or token in response:', data)
        throw new Error('登录响应缺少用户信息或 token')
      }

      // 确保 token 已保存后再调用 onSuccess
      setTimeout(() => {
        onSuccess(data.user, data.token)
      }, 100)
      onClose()
      setFormData({
        phone: '',
        password: '',
        nickname: '',
        smsCode: '',
        newPassword: '',
      })
    } catch (err: any) {
      console.error('❌ [LoginModal] Error:', {
        name: err.name,
        message: err.message,
        stack: err.stack?.substring(0, 200),
      })
      
      let errorMsg = err.message || '网络错误，请检查后端服务是否正常运行'
      // 确保错误信息是中文
      if (errorMsg.includes('Failed to fetch') || errorMsg.includes('fetch') || errorMsg.includes('NetworkError')) {
        errorMsg = '无法连接登录服务，请检查网络后重试。若使用 findyusports.com，请确认后端服务正常。'
        console.error('❌ [LoginModal] Failed to fetch - 可能的原因：')
        console.error('  1. 网络连接问题')
        console.error('  2. 后端服务未运行或不可达')
        console.error('  3. 生产环境 NEXT_PUBLIC_API_BASE 未配置或错误')
      } else if (errorMsg.includes('无法连接登录服务')) {
        // 保留 API 返回的 502 文案
      } else if (errorMsg.includes('Unauthorized')) {
        errorMsg = '未授权，请先登录'
      } else if (errorMsg.includes('401')) {
        errorMsg = '登录失败，手机号或密码错误'
      } else if (errorMsg.includes('手机号或密码错误')) {
        errorMsg = '手机号或密码错误，请检查输入'
      } else if (errorMsg.includes('Internal server error') || errorMsg.includes('Internal Server Error') || errorMsg.includes('服务器内部错误')) {
        errorMsg = '服务器内部错误，请稍后重试。若持续出现请确认后端服务与数据库已正常启动。'
      }
      setError(errorMsg)
    } finally {
      setLoading(false)
    }
  }

  const handleSendCode = async () => {
    if (!formData.phone.trim()) {
      setError('请先输入手机号')
      return
    }
    setError('')
    setResetMsg('')
    setSendingCode(true)
    try {
      const response = await fetch('/api/auth/password-reset/send-code', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ phone: formData.phone.trim() }),
        cache: 'no-store',
      })
      const data = await response.json().catch(() => ({}))
      if (!response.ok || data?.error) {
        throw new Error(data?.error?.message || data?.message || '发送验证码失败')
      }
      setCountdown(60)
      const msg = data?.debugCode
        ? `验证码已发送（开发调试码：${data.debugCode}）`
        : '验证码已发送，请注意查收'
      setResetMsg(msg)
    } catch (err: any) {
      setError(err?.message || '发送验证码失败')
    } finally {
      setSendingCode(false)
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
            {isLogin ? '登录' : isRegister ? '注册' : '找回密码'}
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600"
            aria-label="关闭"
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
          {resetMsg && (
            <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3" style={{ borderRadius: '4px' }}>
              {resetMsg}
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
              {isReset ? '登录新密码' : '密码'}
            </label>
            <div className="relative">
              <input
                type={showPassword ? 'text' : 'password'}
                name={isReset ? 'newPassword' : 'password'}
                value={isReset ? formData.newPassword : formData.password}
                onChange={handleInputChange}
                placeholder={isReset ? '请输入新密码（6-20位）' : '请输入密码'}
                className="w-full px-3 py-2 pr-10 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                style={{ borderRadius: '4px' }}
                required
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                aria-label={showPassword ? '隐藏密码' : '显示密码'}
              >
                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          {isReset && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                短信验证码
              </label>
              <div className="flex gap-2">
                <input
                  type="text"
                  name="smsCode"
                  value={formData.smsCode}
                  onChange={handleInputChange}
                  placeholder="请输入验证码"
                  className="flex-1 px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  style={{ borderRadius: '4px' }}
                  required
                />
                <button
                  type="button"
                  disabled={sendingCode || countdown > 0}
                  onClick={handleSendCode}
                  className="px-3 py-2 text-sm border border-gray-300 rounded disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {countdown > 0 ? `${countdown}s后重发` : sendingCode ? '发送中...' : '发送验证码'}
                </button>
              </div>
            </div>
          )}

          {isRegister && (
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
            {loading ? '处理中...' : isLogin ? '登录' : isRegister ? '注册' : '重置密码'}
          </button>

          <div className="text-center space-y-2">
            {isLogin && (
              <>
                <button
                  type="button"
                  onClick={() => setMode('register')}
                  className="text-blue-600 hover:text-blue-700 text-sm block w-full"
                >
                  没有账号？立即注册
                </button>
                <button
                  type="button"
                  onClick={() => setMode('reset')}
                  className="text-gray-600 hover:text-gray-800 text-sm block w-full"
                >
                  忘记密码？短信找回
                </button>
              </>
            )}
            {!isLogin && (
              <button
                type="button"
                onClick={() => setMode('login')}
                className="text-blue-600 hover:text-blue-700 text-sm block w-full"
              >
                返回登录
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  )
}
