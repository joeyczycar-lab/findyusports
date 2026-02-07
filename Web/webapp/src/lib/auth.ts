// 认证相关工具函数
export interface User {
  id: number
  phone: string
  nickname?: string
  avatar?: string
  role: string
  status: string
  points?: number
  /** VIP 等级 0–5，由积分计算：VIP1=20, VIP2=50, VIP3=100, VIP4=200, VIP5=500 */
  vipLevel?: number
  isVip?: boolean
  createdAt: string
  updatedAt: string
}

export interface AuthState {
  user: User | null
  token: string | null
  isAuthenticated: boolean
}

// 从localStorage获取认证信息
export function getAuthState(): AuthState {
  if (typeof window === 'undefined') {
    return { user: null, token: null, isAuthenticated: false }
  }

  try {
    const token = localStorage.getItem('auth_token')
    const userStr = localStorage.getItem('auth_user')
    
    if (token && userStr) {
      const user = JSON.parse(userStr)
      return { user, token, isAuthenticated: true }
    }
  } catch (error) {
    console.warn('Failed to parse auth state:', error)
  }

  return { user: null, token: null, isAuthenticated: false }
}

// 保存认证信息到localStorage
export function setAuthState(user: User, token: string): void {
  if (typeof window === 'undefined') return

  localStorage.setItem('auth_token', token)
  localStorage.setItem('auth_user', JSON.stringify(user))
}

// 清除认证信息
export function clearAuthState(): void {
  if (typeof window === 'undefined') return

  localStorage.removeItem('auth_token')
  localStorage.removeItem('auth_user')
}

// 获取 Authorization header；多路兜底以防 Vercel 等环境剥离 Authorization
export function getAuthHeader(): Record<string, string> {
  const { token } = getAuthState()
  if (!token) return {}
  return {
    Authorization: `Bearer ${token}`,
    'X-Auth-Token': token,
    // 自定义头，避免被 Vercel 生产环境剥离
    'X-Findyu-Bearer': token.startsWith('Bearer ') ? token : `Bearer ${token}`,
  }
}

// 检查token是否过期（简单检查，实际应该解析JWT）
export function isTokenExpired(): boolean {
  const { token } = getAuthState()
  if (!token) return true

  try {
    // 简单检查token格式，实际应该解析JWT payload
    const parts = token.split('.')
    if (parts.length !== 3) return true

    const payload = JSON.parse(atob(parts[1]))
    const now = Math.floor(Date.now() / 1000)
    return payload.exp < now
  } catch {
    return true
  }
}
