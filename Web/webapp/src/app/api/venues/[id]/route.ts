import { NextRequest } from 'next/server'

// 标记为动态路由
export const dynamic = 'force-dynamic'

function getApiBase(): string {
  // 在生产环境中，必须使用环境变量
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    return base
  }
  
  // 在开发环境中，使用本地后端地址
  if (process.env.NODE_ENV !== 'production') {
    const localBackend = 'http://localhost:4000'
    console.log('🔧 [API Route] Development mode, using local backend:', localBackend)
    return localBackend
  }
  
  // 在生产环境中，如果未配置，使用默认的 Railway 后端地址
  const defaultBackend = 'https://findyusports-production.up.railway.app'
  console.warn('⚠️ [API Route] NEXT_PUBLIC_API_BASE not set in production, using default:', defaultBackend)
  
  return defaultBackend
}

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const backendUrl = `${apiBase}/venues/${venueId}`
    
    console.log('📡 [API Route] GET /venues/[id], proxying to:', backendUrl)
    
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 10000)
    
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
        console.error('❌ [API Route] Request timeout')
        return Response.json(
          { error: { code: 'Timeout', message: '请求超时，请稍后重试' } },
          { status: 504 }
        )
      }
      throw fetchError
    }
    
    const data = await res.json()
    
    if (!res.ok) {
      console.error('❌ [API Route] Backend error:', res.status, data)
      return Response.json(data, { status: res.status })
    }
    
    return Response.json(data)
  } catch (error: any) {
    console.error('❌ [API Route] Error in GET /venues/[id]:', error)
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error.message || '获取场地详情失败',
        },
      },
      { status: 500 }
    )
  }
}

export async function PUT(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const backendUrl = `${apiBase}/venues/${venueId}`
    
    // 获取请求体
    const body = await req.json()
    
    console.log('📡 [API Route] PUT /venues/[id], proxying to:', backendUrl)
    console.log('📡 [API Route] Request body:', JSON.stringify(body, null, 2))
    
    // 获取认证token
    const authHeader = req.headers.get('authorization')
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    if (authHeader) {
      headers['Authorization'] = authHeader
    }
    
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000) // 30秒超时
    
    let res: Response
    try {
      res = await fetch(backendUrl, {
        method: 'PUT',
        cache: 'no-store',
        signal: controller.signal,
        headers,
        body: JSON.stringify(body),
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route] Request timeout')
        return Response.json(
          { error: { code: 'Timeout', message: '请求超时，请稍后重试' } },
          { status: 504 }
        )
      }
      throw fetchError
    }
    
    const data = await res.json()
    
    if (!res.ok) {
      console.error('❌ [API Route] Backend error:', res.status, data)
      return Response.json(data, { status: res.status })
    }
    
    console.log('✅ [API Route] Successfully updated venue:', venueId)
    return Response.json(data)
  } catch (error: any) {
    console.error('❌ [API Route] Error in PUT /venues/[id]:', error)
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error.message || '更新场地失败',
        },
      },
      { status: 500 }
    )
  }
}
