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

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const searchParams = req.nextUrl.searchParams
    const queryString = searchParams.toString()
    const backendUrl = `${apiBase}/venues/${venueId}/images${queryString ? `?${queryString}` : ''}`
    
    console.log('📸 [API Route] Proxying image list request to:', backendUrl)
    
    // 添加超时机制
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 10000) // 10秒超时
    
    // 获取认证 token（如果有）
    const authToken = req.headers.get('authorization')
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    if (authToken) {
      headers['Authorization'] = authToken
    }
    
    let res: Response
    try {
      res = await fetch(backendUrl, {
        method: 'GET',
        cache: 'no-store',
        signal: controller.signal,
        headers,
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
            items: [],
          },
          { status: 408 }
        )
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
        },
        { status: 500 }
      )
    }
    
    // 安全地解析 JSON
    let data
    try {
      data = JSON.parse(text)
      console.log('✅ Successfully fetched images, count:', data.items?.length || 0)
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
        },
        { status: 500 }
      )
    }
    
    return Response.json(data)
  } catch (error) {
    console.error('❌ Error proxying image list to backend:', error)
    if (error instanceof Error) {
      console.error('Error name:', error.name)
      console.error('Error message:', error.message)
      console.error('Error stack:', error.stack)
    }
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '获取图片列表失败',
        },
        items: [],
      },
      { status: 500 }
    )
  }
}

