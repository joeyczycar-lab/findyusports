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

export async function POST(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const venueId = params.id
    const backendUrl = `${apiBase}/venues/${venueId}/upload`
    
    console.log('📤 [API Route] Proxying image upload to:', backendUrl)
    
    // 获取 FormData
    const formData = await req.formData()
    
    // 添加超时机制
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000) // 30秒超时（图片上传可能需要更长时间）
    
    // 获取认证 token
    const authToken = req.headers.get('authorization')
    console.log('🔐 [API Route] Auth token present:', !!authToken)
    if (authToken) {
      console.log('🔐 [API Route] Auth token (first 20 chars):', authToken.substring(0, 20) + '...')
    }
    const headers: HeadersInit = {}
    if (authToken) {
      headers['Authorization'] = authToken
    }
    // 不要设置 Content-Type，让 fetch 自动设置（包含 boundary）
    
    let res: Response
    try {
      // 将 FormData 转发到后端
      res = await fetch(backendUrl, {
        method: 'POST',
        body: formData,
        cache: 'no-store',
        signal: controller.signal,
        headers,
      })
      clearTimeout(timeoutId)
    } catch (fetchError: any) {
      clearTimeout(timeoutId)
      if (fetchError.name === 'AbortError') {
        console.error('❌ [API Route] Upload timeout after 30 seconds')
        return Response.json(
          {
            error: {
              code: 'Timeout',
              message: '上传超时：请检查网络连接或稍后重试',
            },
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
        },
        { status: res.status }
      )
    }
    
    // 检查响应内容类型
    const contentType = res.headers.get('content-type')
    if (!contentType || !contentType.includes('application/json')) {
      const text = await res.text()
      console.error('❌ [API Route] Response is not JSON:', { contentType, text: text.substring(0, 200) })
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
    
    // 安全地解析 JSON
    const text = await res.text()
    if (!text || text.trim().length === 0) {
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
    
    let data
    try {
      data = JSON.parse(text)
      console.log('✅ Successfully uploaded image:', data.url || data.id)
    } catch (parseError) {
      console.error('❌ [API Route] JSON parse error:', parseError)
      console.error('Response text:', text.substring(0, 500))
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
    console.error('❌ Error proxying image upload to backend:', error)
    if (error instanceof Error) {
      console.error('Error name:', error.name)
      console.error('Error message:', error.message)
      console.error('Error stack:', error.stack)
    }
    return Response.json(
      {
        error: {
          code: 'InternalServerError',
          message: error instanceof Error ? error.message : '图片上传失败',
        },
      },
      { status: 500 }
    )
  }
}

