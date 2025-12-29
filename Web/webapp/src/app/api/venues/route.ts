import { NextRequest } from 'next/server'

function getApiBase(): string {
  // 在生产环境中，必须使用环境变量
  // 如果没有配置，尝试使用默认的 Railway 后端地址
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    return base
  }
  
  // 如果未配置，尝试使用默认的 Railway 后端地址
  // 注意：这应该通过环境变量配置，而不是硬编码
  const defaultBackend = process.env.RAILWAY_PUBLIC_DOMAIN 
    ? `https://${process.env.RAILWAY_PUBLIC_DOMAIN}`
    : 'https://findyusports-production.up.railway.app'
  
  console.warn('⚠️ [API Route] NEXT_PUBLIC_API_BASE not set, using default:', defaultBackend)
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
        const errorJson = JSON.parse(errorText)
        errorMessage = errorJson.error?.message || errorJson.message || errorMessage
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
    
    const data = await res.json()
    console.log('✅ Successfully proxied response, items count:', data.items?.length || 0)
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
