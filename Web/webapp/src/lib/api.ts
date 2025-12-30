import { getAuthHeader } from './auth'

export function getApiBase(): string {
  // 在浏览器环境中，始终使用 Next.js API 路由作为代理
  // 这样可以避免 CORS 问题，并且可以更好地处理错误
  if (typeof window !== 'undefined') {
    return '/api'
  }
  
  // 在服务器端（SSR），使用环境变量或默认值
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  return base && base.length > 0 ? base : 'http://localhost:4000'
}

export async function fetchJson(path: string, options?: RequestInit) {
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
      return JSON.parse(text)
    } catch (parseError) {
      console.error('❌ [fetchJson] JSON parse error:', parseError)
      console.error('Response text:', text.substring(0, 500))
      throw new Error(`JSON 解析失败: ${parseError instanceof Error ? parseError.message : String(parseError)}`)
    }
  } catch (error) {
    // 如果是网络错误，提供更友好的错误信息
    if (error instanceof TypeError && error.message.includes('fetch')) {
      throw new Error(`无法连接到后端服务 (${base})。请确保后端服务正在运行。`)
    }
    throw error
  }
}


