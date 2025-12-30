import { NextRequest } from 'next/server'

function getApiBase(): string {
  // 在生产环境中，必须使用环境变量
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    return base
  }
  
  // 如果未配置，使用默认的 Railway 后端地址
  const defaultBackend = 'https://findyusports-production.up.railway.app'
  
  // 只在开发环境显示警告
  if (process.env.NODE_ENV !== 'production') {
    console.warn('⚠️ [API Route] NEXT_PUBLIC_API_BASE not set, using default:', defaultBackend)
  }
  
  return defaultBackend
}

export async function POST(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const backendUrl = `${apiBase}/auth/login`
    
    console.log('🔐 [API Route] Proxying login request to:', backendUrl)
    
    // 获取请求体
    const body = await req.json()
    
    // 添加超时机制
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 10000) // 10秒超时
    
    let res: Response
    try {
      res = await fetch(backendUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
        cache: 'no-store',
        signal: controller.signal,
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route] Request timeout after 10 seconds')
        return Response.json(
          {
            error: {
              code: 'Timeout',
              message: '请求超时：请检查网络连接或稍后重试',
            },
          },
          { status: 408 }
        )
      }
      throw fetchError
    }
    
    // 只读取一次响应体
    const text = await res.text()
    
    if (!res.ok) {
      console.error('❌ Backend returned error:', res.status, text)
      let errorMessage = `Request failed: ${res.status}`
      try {
        if (text && text.trim().length > 0) {
          const errorJson = JSON.parse(text)
          errorMessage = errorJson.error?.message || errorJson.message || errorMessage
        }
      } catch {
        errorMessage = text || errorMessage
      }
      return Response.json(
        {
          error: {
            code: 'InternalServerError',
            message: errorMessage,
          },
        },
        { status: res.status }
      )
    }
    
    // 检查响应内容类型
    const contentType = res.headers.get('content-type')
    if (!contentType || !contentType.includes('application/json')) {
      console.error('❌ [API Route] Response is not JSON:', { contentType, text: text.substring(0, 200) })
      return Response.json(
        {
          error: {
            code: 'InvalidResponse',
            message: `后端返回了非 JSON 格式的响应 (${contentType})`,
          },
        },
        { status: 500 }
      )
    }
    
    // 检查响应是否为空
    if (!text || text.trim().length === 0) {
      console.error('❌ [API Route] Response is empty')
      return Response.json(
        {
          error: {
            code: 'EmptyResponse',
            message: '后端返回了空响应',
          },
        },
        { status: 500 }
      )
    }
    
    // 安全地解析 JSON
    let data
    try {
      data = JSON.parse(text)
      console.log('✅ Successfully logged in user:', data.user?.phone || data.user?.id)
    } catch (parseError) {
      console.error('❌ [API Route] JSON parse error:', parseError)
      console.error('Response text:', text.substring(0, 500))
      return Response.json(
        {
          error: {
            code: 'ParseError',
            message: `JSON 解析失败: ${parseError instanceof Error ? parseError.message : String(parseError)}`,
          },
        },
        { status: 500 }
      )
    }
    
    return Response.json(data)
  } catch (error) {
    console.error('❌ Error proxying login to backend:', error)
    if (error instanceof Error) {
      console.error('Error name:', error.name)
      console.error('Error message:', error.message)
      console.error('Error stack:', error.stack)
    }
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '登录失败',
        },
      },
      { status: 500 }
    )
  }
}

