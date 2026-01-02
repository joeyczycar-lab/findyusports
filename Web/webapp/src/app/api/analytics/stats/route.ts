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
    const timeoutId = setTimeout(() => controller.abort(), 10000)
    
    // 尝试从多个可能的 header 名称获取 token
    const authToken = req.headers.get('authorization') || 
                     req.headers.get('Authorization') ||
                     req.headers.get('x-authorization')
    
    console.log('📊 [API Route] Authorization header:', authToken ? 'Present' : 'Missing')
    if (authToken) {
      console.log('📊 [API Route] Token preview:', authToken.substring(0, 30) + '...')
    } else {
      console.warn('⚠️ [API Route] No authorization token found')
      console.log('📊 [API Route] Available headers:', Array.from(req.headers.keys()))
    }
    
    const headers: HeadersInit = { 'Content-Type': 'application/json' }
    if (authToken) {
      headers['Authorization'] = authToken
    } else {
      // 即使没有 token，也尝试请求，让后端返回明确的错误
      console.warn('⚠️ [API Route] Proceeding without authorization token')
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
    
    if (!res.ok) {
      console.error('❌ [API Route] Backend error:', responseText)
      let errorData: any = { code: 'BackendError', message: '后端服务错误' }
      try {
        errorData = JSON.parse(responseText)
      } catch {}
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

