import { NextRequest } from 'next/server'

// 图片上传可能较慢，延长 Vercel 函数执行时间与请求超时（Vercel Pro 可到 60s）
export const maxDuration = 60

function getApiBase(): string {
  // 优先使用环境变量（开发和生产环境都支持）
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) {
    console.log('🔧 [API Route] Using NEXT_PUBLIC_API_BASE:', base)
    return base
  }
  
  // 在开发环境中，如果没有配置环境变量，使用本地后端地址
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
    
    // 添加超时机制（与 maxDuration 一致，避免过早中断大图上传）
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 55000) // 55 秒，略小于 maxDuration
    
    // 获取认证 token（优先 Authorization，兼容 X-Auth-Token，避免被策略剥离）
    const authFromHeader = req.headers.get('authorization') || req.headers.get('Authorization')
    const authFromCustom = req.headers.get('x-auth-token') || req.headers.get('X-Auth-Token')
    const authToken = authFromHeader
      ? authFromHeader
      : authFromCustom
        ? (authFromCustom.startsWith('Bearer ') ? authFromCustom : `Bearer ${authFromCustom}`)
        : null
    console.log('🔐 [API Route] Auth token present:', !!authToken, 'from:', authFromHeader ? 'Authorization' : authFromCustom ? 'X-Auth-Token' : 'none')
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
        console.error('❌ [API Route] Upload timeout after 55 seconds')
        return Response.json(
          {
            error: {
              code: 'Timeout',
              message: '上传超时：请缩小图片尺寸或压缩后重试（建议单张小于 2MB）',
            },
          },
          { status: 408 }
        )
      }
      
      // 处理网络连接错误
      console.error('❌ [API Route] Fetch error:', {
        name: fetchError.name,
        message: fetchError.message,
        backendUrl,
        apiBase,
      })
      
      // 提供更友好的错误信息
      let errorMessage = '图片上传失败：网络异常。请缩小图片后重试（建议单张小于 2MB）。'
      if (fetchError.message?.includes('ECONNREFUSED') || fetchError.message?.includes('Failed to fetch')) {
        errorMessage = `无法连接到后端服务。请检查网络后重试；若图片较大，请先压缩或缩小尺寸再上传。`
      } else if (fetchError.message) {
        errorMessage = `图片上传失败：${fetchError.message}。建议缩小图片后重试。`
      }
      
      return Response.json(
        {
          error: {
            code: 'NetworkError',
            message: errorMessage,
          },
        },
        { status: 503 }
      )
    }
    
    if (!res.ok) {
      const errorText = await res.text()
      console.error('❌ [API Route] Backend returned error:', res.status, errorText)
      console.error('❌ [API Route] Response headers:', Object.fromEntries(res.headers.entries()))
      
      let errorMessage = `请求失败: ${res.status}`
      let errorCode = 'BackendError'
      
      try {
        if (errorText && errorText.trim().length > 0) {
          const errorJson = JSON.parse(errorText)
          errorMessage = errorJson.error?.message || errorJson.message || errorMessage
          errorCode = errorJson.error?.code || errorJson.code || errorCode
        }
      } catch {
        errorMessage = errorText || errorMessage
      }
      
      // 根据状态码提供更友好的错误信息
      if (res.status === 401) {
        errorMessage = '未授权，请先登录'
        errorCode = 'Unauthorized'
      } else if (res.status === 403) {
        errorMessage = '权限不足，无法上传图片'
        errorCode = 'Forbidden'
      } else if (res.status === 400) {
        errorMessage = errorMessage || '请求参数错误'
        errorCode = 'BadRequest'
      } else if (res.status >= 500) {
        errorMessage = errorMessage || '服务器内部错误，请稍后重试'
        errorCode = 'InternalServerError'
      }
      
      return Response.json(
        {
          error: {
            code: errorCode,
            message: errorMessage,
          },
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
        },
        { status: 500 }
      )
    }
    
    // 安全地解析 JSON
    let data: { url?: string; id?: number; error?: { code: string; message: string } }
    try {
      data = JSON.parse(text)
      const url = data?.url ?? (data as any)?.image?.url
      const id = data?.id ?? (data as any)?.image?.id
      console.log('✅ Successfully uploaded image:', url || id ? (url || `id=${id}`) : '(no url/id in response)', data?.error ? `backend error: ${data.error.message}` : '')
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

    // 若后端未返回顶层 url 但有 sizes.large，补全给前端使用
    const payload = data as Record<string, unknown>
    if (!payload.url && payload.sizes && typeof payload.sizes === 'object' && (payload.sizes as Record<string, string>).large) {
      payload.url = (payload.sizes as Record<string, string>).large
    }
    return Response.json(payload)
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

