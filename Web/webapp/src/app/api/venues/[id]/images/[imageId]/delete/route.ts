import { NextRequest } from 'next/server'

function getApiBase(): string {
  // 在服务器端，使用环境变量或默认值
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

export async function POST(
  req: NextRequest,
  { params }: { params: { id: string; imageId: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const imageId = params.imageId
    const backendUrl = `${apiBase}/venues/${venueId}/images/${imageId}/delete`
    
    console.log('🗑️ [API Route] Proxying delete image request to:', backendUrl)
    
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000) // 30秒超时
    const authToken = req.headers.get('authorization')
    const headers: HeadersInit = { 'Content-Type': 'application/json' }
    if (authToken) {
      headers['Authorization'] = authToken
    }
    
    let res: Response
    try {
      res = await fetch(backendUrl, {
        method: 'POST',
        cache: 'no-store',
        signal: controller.signal,
        headers,
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route] Delete image request timeout')
        return Response.json(
          { error: { code: 'Timeout', message: '请求超时，请稍后重试' } },
          { status: 408 }
        )
      }
      console.error('❌ [API Route] Failed to proxy delete image request:', fetchError)
      return Response.json(
        { error: { code: 'NetworkError', message: '网络错误，无法连接到后端服务' } },
        { status: 503 }
      )
    }
    
    // Read response text once
    const responseText = await res.text()

    if (!res.ok) {
      console.error(`❌ [API Route] Backend returned error: ${res.status} ${responseText}`)
      let errorData: any = { code: 'BackendError', message: '后端服务错误' }
      try {
        if (responseText) {
          const parsed = JSON.parse(responseText)
          errorData = parsed.error || parsed
        }
      } catch (e) {
        errorData.message = responseText || `HTTP ${res.status}`
      }
      return Response.json({ error: errorData }, { status: res.status })
    }
    
    const contentType = res.headers.get('content-type')
    if (!contentType || !contentType.includes('application/json')) {
      console.error('❌ [API Route] Invalid content-type:', contentType)
      return Response.json(
        { error: { code: 'InvalidResponse', message: '后端返回了无效的响应格式' } },
        { status: 500 }
      )
    }
    
    if (!responseText || responseText.trim().length === 0) {
      console.error('❌ [API Route] Empty response body')
      return Response.json(
        { error: { code: 'EmptyResponse', message: '后端返回了空响应' } },
        { status: 500 }
      )
    }
    
    let data
    try {
      data = JSON.parse(responseText)
      console.log('✅ Successfully deleted image:', imageId)
    } catch (parseError) {
      console.error('❌ [API Route] Failed to parse JSON response:', parseError)
      return Response.json(
        { error: { code: 'ParseError', message: '无法解析后端响应' } },
        { status: 500 }
      )
    }
    
    return Response.json(data)
  } catch (error) {
    console.error('❌ [API Route] Unexpected error in delete image route:', error)
    return Response.json(
      { error: { code: 'InternalError', message: error instanceof Error ? error.message : '未知错误' } },
      { status: 500 }
    )
  }
}

