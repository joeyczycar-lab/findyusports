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
    
    // 获取认证token（检查多种可能的header名称）
    // Next.js headers 是大小写不敏感的，但为了兼容性，我们检查多个变体
    let authHeader = req.headers.get('authorization') || 
                     req.headers.get('Authorization') ||
                     req.headers.get('x-authorization') ||
                     req.headers.get('X-Authorization')
    
    // 如果还是没有找到，尝试从 headers 对象中查找（不区分大小写）
    if (!authHeader) {
      const allHeaders = Array.from(req.headers.entries())
      const authEntry = allHeaders.find(([key]) => 
        key.toLowerCase() === 'authorization' || key.toLowerCase() === 'x-authorization'
      )
      if (authEntry) {
        authHeader = authEntry[1]
        console.log('✅ [API Route] Found auth header via case-insensitive search')
      }
    }
    
    console.log('🔍 [API Route] Checking auth header:', {
      'authorization': req.headers.get('authorization') ? 'found' : 'not found',
      'Authorization': req.headers.get('Authorization') ? 'found' : 'not found',
      'authHeader value': authHeader ? authHeader.substring(0, 30) + '...' : 'null',
      'allHeaderKeys': Array.from(req.headers.keys())
    })
    
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    if (authHeader) {
      headers['Authorization'] = authHeader
      console.log('✅ [API Route] Authorization header found, will forward to backend:', authHeader.substring(0, 30) + '...')
    } else {
      console.warn('⚠️ [API Route] No authorization header found in request')
      console.log('📋 [API Route] All request headers:', Array.from(req.headers.entries()).map(([k, v]) => {
        // 隐藏敏感信息
        if (k.toLowerCase().includes('auth')) {
          return `${k}: ${v.substring(0, 20)}...`
        }
        return `${k}: ${v}`
      }).join(', '))
      // 如果没有认证信息，返回401错误
      return Response.json(
        { error: { code: 'Unauthorized', message: '未授权，请先登录' } },
        { status: 401 }
      )
    }
    
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000) // 30秒超时
    
    console.log('📤 [API Route] Forwarding request to backend:', {
      url: backendUrl,
      method: 'PUT',
      hasAuthHeader: !!headers['Authorization'],
      authHeaderPreview: headers['Authorization'] ? (headers['Authorization'] as string).substring(0, 30) + '...' : 'none',
      allHeaders: Object.keys(headers)
    })
    
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
    
    const responseText = await res.text()
    let data: any
    try {
      data = responseText ? JSON.parse(responseText) : {}
    } catch (e) {
      console.error('❌ [API Route] Failed to parse response:', responseText.substring(0, 200))
      data = { error: { message: '后端返回了无效的JSON响应' } }
    }
    
    if (!res.ok) {
      console.error('❌ [API Route] Backend returned error:', {
        status: res.status,
        statusText: res.statusText,
        url: backendUrl,
        headersSent: Object.keys(headers),
        authHeaderPresent: !!headers['Authorization'],
        authHeaderPreview: headers['Authorization'] ? (headers['Authorization'] as string).substring(0, 30) + '...' : 'none',
        responseData: data
      })
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
