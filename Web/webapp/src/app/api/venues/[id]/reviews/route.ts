import { NextRequest } from 'next/server'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    console.log('🔧 [API Route][reviews] Using NEXT_PUBLIC_API_BASE:', base)
    return base
  }

  if (process.env.NODE_ENV !== 'production') {
    const localBackend = 'http://localhost:4000'
    console.log('🔧 [API Route][reviews] Development mode, using local backend:', localBackend)
    return localBackend
  }

  const defaultBackend = 'https://findyusports-production.up.railway.app'
  console.warn('⚠️ [API Route][reviews] NEXT_PUBLIC_API_BASE not set in production, using default:', defaultBackend)
  return defaultBackend
}

// 获取点评列表
export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const backendUrl = `${apiBase}/venues/${venueId}/reviews`

    console.log('📝 [API Route][reviews] Proxying GET to:', backendUrl)

    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 10000) // 10 秒超时

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
        console.error('❌ [API Route][reviews] GET timeout after 10 seconds')
        return Response.json(
          {
            error: {
              code: 'Timeout',
              message: '获取点评超时，请稍后重试',
            },
            items: [],
          },
          { status: 408 }
        )
      }
      console.error('❌ [API Route][reviews] Network error:', fetchError)
      return Response.json(
        {
          error: {
            code: 'NetworkError',
            message: '获取点评失败：网络异常，请稍后重试',
          },
          items: [],
        },
        { status: 503 }
      )
    }

    const text = await res.text()

    if (!res.ok) {
      console.error('❌ [API Route][reviews] Backend error:', res.status, text.substring(0, 200))
      let message = `请求失败: ${res.status}`
      try {
        if (text && text.trim().length > 0) {
          const json = JSON.parse(text)
          message = json.error?.message || json.message || message
        }
      } catch {
        message = text || message
      }
      return Response.json(
        {
          error: {
            code: 'BackendError',
            message,
          },
          items: [],
        },
        { status: res.status }
      )
    }

    if (!text || text.trim().length === 0) {
      console.error('❌ [API Route][reviews] Empty response')
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

    try {
      const data = JSON.parse(text)
      console.log('✅ [API Route][reviews] Got reviews, count:', data.items?.length || 0)
      return Response.json(data)
    } catch (e) {
      console.error('❌ [API Route][reviews] JSON parse error:', e)
      console.error('Response text:', text.substring(0, 500))
      return Response.json(
        {
          error: {
            code: 'ParseError',
            message: '解析点评列表失败',
          },
          items: [],
        },
        { status: 500 }
      )
    }
  } catch (error) {
    console.error('❌ [API Route][reviews] Unexpected error:', error)
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: '获取点评失败',
        },
        items: [],
      },
      { status: 500 }
    )
  }
}

// 创建点评
export async function POST(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const backendUrl = `${apiBase}/venues/${venueId}/reviews`

    const body = await req.json()
    console.log('📝 [API Route][reviews] Proxying POST to:', backendUrl, 'body:', body)

    // 认证：必须登录
    const authHeader =
      req.headers.get('authorization') ||
      req.headers.get('Authorization') ||
      req.headers.get('x-authorization') ||
      req.headers.get('X-Authorization')

    if (!authHeader) {
      console.warn('⚠️ [API Route][reviews] No auth header, returning 401')
      return Response.json(
        { error: { code: 'Unauthorized', message: '未授权，请先登录' } },
        { status: 401 }
      )
    }

    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      Authorization: authHeader,
    }

    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 15000) // 15 秒超时

    let res: Response
    try {
      res = await fetch(backendUrl, {
        method: 'POST',
        cache: 'no-store',
        signal: controller.signal,
        headers,
        body: JSON.stringify(body),
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route][reviews] POST timeout after 15 seconds')
        return Response.json(
          {
            error: {
              code: 'Timeout',
              message: '提交点评超时，请稍后重试',
            },
          },
          { status: 408 }
        )
      }
      console.error('❌ [API Route][reviews] Network error:', fetchError)
      return Response.json(
        {
          error: {
            code: 'NetworkError',
            message: '提交点评失败：网络异常，请稍后重试',
          },
        },
        { status: 503 }
      )
    }

    const text = await res.text()

    if (!res.ok) {
      console.error('❌ [API Route][reviews] Backend error:', res.status, text.substring(0, 200))
      let message = `请求失败: ${res.status}`
      let code = 'BackendError'
      try {
        if (text && text.trim().length > 0) {
          const json = JSON.parse(text)
          message = json.error?.message || json.message || message
          code = json.error?.code || json.code || code
        }
      } catch {
        message = text || message
      }

      if (res.status === 401) {
        message = '登录已过期或未授权，请重新登录'
        code = 'Unauthorized'
      }

      return Response.json(
        {
          error: {
            code,
            message,
          },
        },
        { status: res.status }
      )
    }

    if (!text || text.trim().length === 0) {
      console.error('❌ [API Route][reviews] Empty response on POST')
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

    try {
      const data = JSON.parse(text)
      console.log('✅ [API Route][reviews] Review created, id:', data.id)
      return Response.json(data)
    } catch (e) {
      console.error('❌ [API Route][reviews] JSON parse error on POST:', e)
      console.error('Response text:', text.substring(0, 500))
      return Response.json(
        {
          error: {
            code: 'ParseError',
            message: '解析点评创建结果失败',
          },
        },
        { status: 500 }
      )
    }
  } catch (error) {
    console.error('❌ [API Route][reviews] Unexpected error on POST:', error)
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: '提交点评失败',
        },
      },
      { status: 500 }
    )
  }
}

