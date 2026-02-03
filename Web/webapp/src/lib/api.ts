import { getAuthHeader } from './auth'

export function getApiBase(): string {
  // 在浏览器环境中，始终使用 Next.js API 路由作为代理
  // 这样可以避免 CORS 问题，并且可以更好地处理错误
  // 注意：对于需要认证的 API（如 /analytics/stats），必须通过 Next.js API 路由
  // 因为 Next.js API 路由可以正确转发 Authorization header
  if (typeof window !== 'undefined') {
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
    const authHeader = getAuthHeader()
    const headers: HeadersInit = {
      ...authHeader,
      ...(isFormData ? {} : { 'Content-Type': 'application/json' }),
      ...options?.headers,
    }
    
    // 仅在开发环境输出调试信息，减少生产环境主线程开销
    if (process.env.NODE_ENV === 'development') {
      if (authHeader.Authorization) {
        console.log('✅ [fetchJson] Authorization header present:', authHeader.Authorization.substring(0, 30) + '...')
      } else {
        console.warn('⚠️ [fetchJson] No Authorization header found')
      }
      console.log('🌐 [fetchJson] Making request:', {
        url,
        method: options?.method || 'GET',
        hasAuthHeader: !!authHeader.Authorization,
      })
    }
    
    let res: Response
    try {
      res = await fetch(url, { 
        cache: 'no-store',
        headers,
        ...options,
      })
    } catch (fetchError: any) {
      // 处理网络错误（连接失败、超时等）
      console.error('❌ [fetchJson] Network error:', {
        message: fetchError.message,
        name: fetchError.name,
        url: url,
        base: base,
      })
      
      // 提供更友好的错误信息
      if (fetchError.name === 'TypeError' && fetchError.message.includes('fetch')) {
        throw new Error(`无法连接到后端服务 (${url})。请确保：
1. 后端服务正在运行
2. 后端地址正确
3. 没有防火墙阻止连接`)
      }
      
      if (fetchError.name === 'AbortError') {
        throw new Error('请求超时，请稍后重试')
      }
      
      throw new Error(`网络错误: ${fetchError.message || '无法连接到服务器'}`)
    }
    
    console.log('📥 [fetchJson] Response received:', {
      status: res.status,
      statusText: res.statusText,
      ok: res.ok,
      contentType: res.headers.get('content-type')
    })
    
    if (!res.ok) {
      const errorText = await res.text()
      console.error('❌ [fetchJson] Request failed:', {
        status: res.status,
        statusText: res.statusText,
        url,
        errorText: errorText.substring(0, 200)
      })
      
      let errorMessage = `请求失败: ${res.status}`
      if (res.status === 404) {
        errorMessage = '未找到请求的资源 (404)，请检查地址或联系管理员'
      }
      try {
        if (errorText && errorText.trim().length > 0) {
          const errorJson = JSON.parse(errorText)
          const bodyMsg = errorJson.error?.message || errorJson.message
          if (bodyMsg) errorMessage = bodyMsg
          // 英文转中文
          if (errorMessage.includes('Unauthorized')) {
            errorMessage = '未授权，请先登录'
          } else if (errorMessage.includes('Forbidden')) {
            errorMessage = '禁止访问，权限不足'
          } else if (errorMessage.includes('Not Found') || errorMessage.includes('404')) {
            errorMessage = '未找到请求的资源，请检查地址或联系管理员'
          } else if (errorMessage.includes('Internal Server Error')) {
            errorMessage = '服务器内部错误'
          } else if (errorMessage.includes('Bad Request')) {
            errorMessage = '请求参数错误'
          }
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
      console.error('❌ [fetchJson] JSON 解析错误:', parseError)
      console.error('Response text length:', text.length)
      console.error('Response text (first 500 chars):', text.substring(0, 500))
      console.error('Response text (last 100 chars):', text.substring(Math.max(0, text.length - 100)))
      throw new Error(`JSON 解析失败: ${parseError instanceof Error ? parseError.message : String(parseError)}`)
    }
  } catch (error) {
    // 网络错误：上传接口给出可操作建议，其它接口给出通用提示
    if (error instanceof TypeError && (error.message.includes('fetch') || error.message.includes('Failed to fetch'))) {
      const isUpload = url.includes('/upload')
      const errorMsg = isUpload
        ? '上传失败（网络异常）。请检查网络后重试；若图片较大，请先缩小到单张 2MB 以内再上传。'
        : `无法连接到后端服务 (${url})。请确保：\n1. 后端服务正在运行\n2. 后端地址正确\n3. 没有防火墙阻止连接`
      if (process.env.NODE_ENV === 'development') {
        console.error('❌ [fetchJson] 网络错误:', error)
        console.error('❌ [fetchJson] 尝试访问的 URL:', url)
      }
      throw new Error(errorMsg)
    }
    // 如果是其他错误，确保错误信息是中文
    if (error instanceof Error) {
      let errorMsg = error.message
      // 转换常见的英文错误信息为中文
      if (errorMsg.includes('Unauthorized')) {
        errorMsg = '未授权，请先登录'
      } else if (errorMsg.includes('Forbidden')) {
        errorMsg = '禁止访问，权限不足'
      } else if (errorMsg.includes('Not Found')) {
        errorMsg = '未找到请求的资源'
      } else if (errorMsg.includes('Internal Server Error')) {
        errorMsg = '服务器内部错误'
      } else if (errorMsg.includes('Bad Request')) {
        errorMsg = '请求参数错误'
      } else if (errorMsg.includes('Request failed')) {
        errorMsg = errorMsg.replace('Request failed', '请求失败')
      }
      throw new Error(errorMsg)
    }
    throw error
  }
}


