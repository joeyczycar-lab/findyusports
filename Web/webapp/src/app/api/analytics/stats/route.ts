import { NextRequest } from 'next/server'

function getApiBase(): string {
  if (typeof window !== 'undefined') {
    return '/api'
  }
  if (process.env.NODE_ENV !== 'production') {
    return 'http://localhost:4000'
  }
  return process.env.NEXT_PUBLIC_API_BASE || 'https://findyusports-api-production.up.railway.app'
}

export const dynamic = 'force-dynamic'

export async function GET(req: NextRequest) {
  try {
    // 在服务器端，getApiBase 应该返回后端地址
    const apiBase = process.env.NODE_ENV !== 'production' 
      ? 'http://localhost:4000'
      : (process.env.NEXT_PUBLIC_API_BASE || 'https://findyusports-api-production.up.railway.app')
    
    const searchParams = req.nextUrl.searchParams
    const queryString = searchParams.toString()
    const backendUrl = `${apiBase}/analytics/stats${queryString ? `?${queryString}` : ''}`
    
    console.log('📊 [API Route] Proxying analytics stats to:', backendUrl)
    console.log('📊 [API Route] Environment:', process.env.NODE_ENV)
    
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000) // 增加到 30 秒
    
    // 尝试从多个可能的 header 名称获取 token
    // Next.js 的 headers 是只读的 Headers 对象，需要正确获取
    const authHeader = req.headers.get('authorization') || 
                      req.headers.get('Authorization') ||
                      req.headers.get('x-authorization')
    
    console.log('📊 [API Route] Request headers:', {
      hasAuth: !!authHeader,
      allHeaders: Array.from(req.headers.keys()),
    })
    
    if (authHeader) {
      console.log('📊 [API Route] Authorization header found, preview:', authHeader.substring(0, 30) + '...')
    } else {
      console.warn('⚠️ [API Route] No authorization header found in request')
      // 尝试从 cookie 或其他地方获取（如果需要）
    }
    
    const headers: HeadersInit = { 'Content-Type': 'application/json' }
    if (authHeader) {
      headers['Authorization'] = authHeader
      console.log('✅ [API Route] Authorization header will be forwarded to backend')
    } else {
      console.warn('⚠️ [API Route] No authorization header, request will likely fail')
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
        return Response.json(
          { error: { code: 'Timeout', message: '请求超时' } },
          { status: 504 }
        )
      }
      throw fetchError
    }
    
    const responseText = await res.text()
    
    console.log('📊 [API Route] Backend response status:', res.status)
    console.log('📊 [API Route] Backend response headers:', Object.fromEntries(res.headers.entries()))
    
    if (!res.ok) {
      console.error('❌ [API Route] Backend error:', {
        status: res.status,
        statusText: res.statusText,
        responseText: responseText.substring(0, 500),
      })
      let errorData: any = { code: 'BackendError', message: '后端服务错误' }
      try {
        if (responseText && responseText.trim().length > 0) {
          errorData = JSON.parse(responseText)
        }
      } catch (parseError) {
        console.error('❌ [API Route] Failed to parse error response:', parseError)
        errorData = { 
          code: 'BackendError', 
          message: responseText || `后端返回错误: ${res.status} ${res.statusText}` 
        }
      }
      return Response.json({ error: errorData }, { status: res.status })
    }
    
    const contentType = res.headers.get('content-type')
    if (!contentType || !contentType.includes('application/json')) {
      return Response.json(
        { error: { code: 'InvalidContentType', message: '服务器返回了非 JSON 响应' } },
        { status: 500 }
      )
    }
    
    if (!responseText || responseText.trim().length === 0) {
      return Response.json(
        { error: { code: 'EmptyResponse', message: '服务器返回了空响应' } },
        { status: 500 }
      )
    }
    
    let data
    try {
      data = JSON.parse(responseText)
      console.log('✅ Successfully fetched analytics stats')
    } catch (parseError) {
      console.error('❌ [API Route] JSON parse error:', parseError)
      return Response.json(
        { error: { code: 'ParseError', message: '解析响应失败' } },
        { status: 500 }
      )
    }
    
    return Response.json(data)
  } catch (error) {
    console.error('❌ [API Route] Unexpected error:', error)
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '未知错误',
        },
      },
      { status: 500 }
    )
  }
}

