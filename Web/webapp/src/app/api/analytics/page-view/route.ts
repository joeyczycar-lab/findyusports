import { NextRequest } from 'next/server'

function getApiBase(): string {
  if (typeof window !== 'undefined') {
    return '/api'
  }
  // 优先使用环境变量（开发和生产环境都支持）
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    console.log('🔧 [API Route] Using NEXT_PUBLIC_API_BASE:', base)
    return base
  }
  // 在开发环境中，如果没有配置环境变量，使用本地后端地址
  if (process.env.NODE_ENV !== 'production') {
    return 'http://localhost:4000'
  }
  return 'https://findyusports-api-production.up.railway.app'
}

export const dynamic = 'force-dynamic'

export async function POST(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const backendUrl = `${apiBase}/analytics/page-view`
    
    console.log('📊 [API Route] Proxying page view to:', backendUrl)
    
    const body = await req.json()
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 10000)
    
    // 转发请求头
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    const userAgent = req.headers.get('user-agent')
    const referer = req.headers.get('referer')
    const forwardedFor = req.headers.get('x-forwarded-for')
    
    if (userAgent) headers['user-agent'] = userAgent
    if (referer) headers['referer'] = referer
    if (forwardedFor) headers['x-forwarded-for'] = forwardedFor
    
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
      console.log('✅ Successfully recorded page view')
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


