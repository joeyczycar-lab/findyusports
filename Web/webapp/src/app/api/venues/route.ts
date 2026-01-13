import { NextRequest } from 'next/server'

// 标记为动态路由，因为使用了 searchParams
export const dynamic = 'force-dynamic'

function getApiBase(): string {
  // 优先使用环境变量（开发和生产环境都支持）
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    console.log('🔧 [API Route] Using NEXT_PUBLIC_API_BASE:', base)
    return base
  }
  
  // 在开发环境中，如果没有配置环境变量，使用本地后端地址
  if (process.env.NODE_ENV !== 'production') {
    const localBackend = 'http://localhost:4000'
    console.log('🔧 [API Route] Development mode, using local backend:', localBackend)
    return localBackend
  }
  
  // 在生产环境中，如果未配置，使用默认的 Railway 后端地址
  // 注意：在生产环境中，应该通过 Vercel 环境变量配置 NEXT_PUBLIC_API_BASE
  const defaultBackend = 'https://findyusports-production.up.railway.app'
  console.warn('⚠️ [API Route] NEXT_PUBLIC_API_BASE not set in production, using default:', defaultBackend)
  
  return defaultBackend
}

export async function GET(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const searchParams = req.nextUrl.searchParams
    const queryString = searchParams.toString()
    const backendUrl = `${apiBase}/venues${queryString ? `?${queryString}` : ''}`
    
    console.log('📡 [API Route] Proxying request to:', backendUrl)
    
    // 添加超时和重试机制
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 10000) // 10秒超时
    
    let res: Response
    try {
      res = await fetch(backendUrl, {
        cache: 'no-store',
        signal: controller.signal,
        headers: {
          'Content-Type': 'application/json',
        },
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route] Request timeout after 10 seconds')
        throw new Error('请求超时：后端服务响应时间过长')
      }
      throw fetchError
    }
    
    if (!res.ok) {
      const errorText = await res.text()
      console.error('❌ Backend returned error:', res.status, errorText)
      let errorMessage = `Request failed: ${res.status}`
      try {
        if (errorText && errorText.trim().length > 0) {
          const errorJson = JSON.parse(errorText)
          errorMessage = errorJson.error?.message || errorJson.message || errorMessage
        }
      } catch {
        errorMessage = errorText || errorMessage
      }
      return Response.json(
        {
          error: {
            code: 'InternalServerError',
            message: errorMessage,
          },
          items: [],
          page: 1,
          pageSize: 20,
          total: 0,
        },
        { status: res.status }
      )
    }
    
    // 只读取一次响应体
    const text = await res.text()
    
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
          items: [],
          page: 1,
          pageSize: 20,
          total: 0,
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
          items: [],
          page: 1,
          pageSize: 20,
          total: 0,
        },
        { status: 500 }
      )
    }
    
    // 安全地解析 JSON
    let data
    try {
      data = JSON.parse(text)
      console.log('✅ Successfully proxied response, items count:', data.items?.length || 0)
    } catch (parseError) {
      console.error('❌ [API Route] JSON parse error:', parseError)
      console.error('Response text:', text.substring(0, 500))
      return Response.json(
        {
          error: {
            code: 'ParseError',
            message: `JSON 解析失败: ${parseError instanceof Error ? parseError.message : String(parseError)}`,
          },
          items: [],
          page: 1,
          pageSize: 20,
          total: 0,
        },
        { status: 500 }
      )
    }
    
    return Response.json(data)
  } catch (error) {
    console.error('❌ Error proxying to backend:', error)
    if (error instanceof Error) {
      console.error('Error name:', error.name)
      console.error('Error message:', error.message)
      console.error('Error stack:', error.stack)
    }
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '无法连接到后端服务',
        },
        items: [],
        page: 1,
        pageSize: 20,
        total: 0,
      },
      { status: 500 }
    )
  }
}

export async function POST(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const backendUrl = `${apiBase}/venues`
    
    console.log('📤 [API Route] Proxying POST request to:', backendUrl)
    
    // 获取请求体
    const body = await req.json()
    console.log('📤 [API Route] Request body:', JSON.stringify(body).substring(0, 200))
    
    // 获取认证 token
    const authToken = req.headers.get('authorization')
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    if (authToken) {
      headers['Authorization'] = authToken
    }
    
    // 添加超时机制
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000) // 30秒超时
    
    let res: Response
    try {
      res = await fetch(backendUrl, {
        method: 'POST',
        headers,
        body: JSON.stringify(body),
        cache: 'no-store',
        signal: controller.signal,
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route] Request timeout after 30 seconds')
        return Response.json(
          {
            error: {
              code: 'Timeout',
              message: '请求超时：后端服务响应时间过长',
            },
          },
          { status: 504 }
        )
      }
      throw fetchError
    }
    
    // 只读取一次响应体
    const responseText = await res.text()
    
    if (!res.ok) {
      console.error('❌ [API Route] Backend returned error:', res.status, responseText)
      let errorMessage = `Request failed: ${res.status}`
      try {
        if (responseText && responseText.trim().length > 0) {
          const errorJson = JSON.parse(responseText)
          errorMessage = errorJson.error?.message || errorJson.message || errorMessage
        }
      } catch {
        errorMessage = responseText || errorMessage
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
      console.error('❌ [API Route] Response is not JSON:', { contentType, text: responseText.substring(0, 200) })
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
    if (!responseText || responseText.trim().length === 0) {
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
      data = JSON.parse(responseText)
      console.log('✅ [API Route] Successfully created venue:', data.id || data.name)
    } catch (parseError) {
      console.error('❌ [API Route] JSON parse error:', parseError)
      console.error('Response text:', responseText.substring(0, 500))
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
    console.error('❌ [API Route] Error proxying POST to backend:', error)
    if (error instanceof Error) {
      console.error('Error name:', error.name)
      console.error('Error message:', error.message)
      console.error('Error stack:', error.stack)
    }
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '无法连接到后端服务',
        },
      },
      { status: 500 }
    )
  }
}
