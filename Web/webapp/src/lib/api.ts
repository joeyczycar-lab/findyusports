import { getAuthHeader } from './auth'

export function getApiBase(): string {
  // 在浏览器环境中，检查是否在生产环境且需要直接调用后端
  // 如果 NEXT_PUBLIC_API_BASE 已设置，直接使用后端地址（绕过 Next.js API 路由）
  if (typeof window !== 'undefined') {
    const directBackend = process.env.NEXT_PUBLIC_API_BASE?.trim()
    if (directBackend && directBackend.length > 0) {
      // 生产环境：直接使用后端地址，避免 Next.js API 路由的 405 问题
      return directBackend
    }
    // 开发环境：使用 Next.js API 路由作为代理
    return '/api'
  }
  
  // 在服务器端（SSR），使用环境变量或默认值
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  return base && base.length > 0 ? base : 'http://localhost:4000'
}

export async function fetchJson<T = any>(path: string, options?: RequestInit): Promise<T> {
  const base = getApiBase()
  const url = `${base}${path}`
  
  try {
    // 如果是 FormData，不要设置 Content-Type，让浏览器自动设置
    const isFormData = options?.body instanceof FormData
    const headers: HeadersInit = {
      ...getAuthHeader(),
      ...(isFormData ? {} : { 'Content-Type': 'application/json' }),
      ...options?.headers,
    }
    
    const res = await fetch(url, { 
      cache: 'no-store',
      headers,
      ...options,
    })
    
    if (!res.ok) {
      const errorText = await res.text()
      let errorMessage = `Request failed: ${res.status}`
      try {
        if (errorText && errorText.trim().length > 0) {
          const errorJson = JSON.parse(errorText)
          errorMessage = errorJson.error?.message || errorJson.message || errorMessage
        }
      } catch {
        errorMessage = errorText || errorMessage
      }
      throw new Error(errorMessage)
    }
    
    // 只读取一次响应体
    const text = await res.text()
    
    // 检查响应内容类型
    const contentType = res.headers.get('content-type')
    if (!contentType || !contentType.includes('application/json')) {
      console.error('❌ [fetchJson] Response is not JSON:', { contentType, text: text.substring(0, 200) })
      throw new Error(`服务器返回了非 JSON 格式的响应 (${contentType})`)
    }
    
    // 检查响应是否为空
    if (!text || text.trim().length === 0) {
      console.error('❌ [fetchJson] Response is empty')
      throw new Error('服务器返回了空响应')
    }
    
    // 安全地解析 JSON
    try {
      const parsed = JSON.parse(text)
      console.log('✅ [fetchJson] Successfully parsed JSON')
      return parsed
    } catch (parseError) {
      console.error('❌ [fetchJson] JSON parse error:', parseError)
      console.error('Response text length:', text.length)
      console.error('Response text (first 500 chars):', text.substring(0, 500))
      console.error('Response text (last 100 chars):', text.substring(Math.max(0, text.length - 100)))
      throw new Error(`JSON 解析失败: ${parseError instanceof Error ? parseError.message : String(parseError)}`)
    }
  } catch (error) {
    // 如果是网络错误，提供更友好的错误信息
    if (error instanceof TypeError && (error.message.includes('fetch') || error.message.includes('Failed to fetch'))) {
      const errorMsg = `无法连接到后端服务 (${url})。请确保：\n1. 后端服务正在运行\n2. 后端地址正确\n3. 没有防火墙阻止连接`
      console.error('❌ [fetchJson] Network error:', error)
      console.error('❌ [fetchJson] Attempted URL:', url)
      throw new Error(errorMsg)
    }
    throw error
  }
}


