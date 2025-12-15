import { getAuthHeader } from './auth'

export function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  // 如果未配置，返回默认的本地开发地址
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
        const errorJson = JSON.parse(errorText)
        errorMessage = errorJson.error?.message || errorJson.message || errorMessage
      } catch {
        errorMessage = errorText || errorMessage
      }
      throw new Error(errorMessage)
    }
    
    return await res.json()
  } catch (error) {
    // 如果是网络错误，提供更友好的错误信息
    if (error instanceof TypeError && error.message.includes('fetch')) {
      throw new Error(`无法连接到后端服务 (${base})。请确保后端服务正在运行。`)
    }
    throw error
  }
}


