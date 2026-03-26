import { NextRequest } from 'next/server'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

export async function POST(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const apiBase = getApiBase()
    const backendUrl = `${apiBase}/venues/${params.id}/approve`

    const authHeader = req.headers.get('authorization') || req.headers.get('Authorization')
    const xAuthToken = req.headers.get('x-auth-token') || req.headers.get('X-Auth-Token')
    const xFindyuBearer = req.headers.get('x-findyu-bearer') || req.headers.get('X-Findyu-Bearer')
    const headers: HeadersInit = { 'Content-Type': 'application/json' }
    if (authHeader) headers['Authorization'] = authHeader
    if (xAuthToken) headers['X-Auth-Token'] = xAuthToken
    if (xFindyuBearer) headers['X-Findyu-Bearer'] = xFindyuBearer

    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000)

    const res = await fetch(backendUrl, {
      method: 'POST',
      cache: 'no-store',
      signal: controller.signal,
      headers,
    })
    clearTimeout(timeoutId)

    const text = await res.text()
    if (!res.ok) {
      let message = `请求失败: ${res.status}`
      try {
        const parsed = JSON.parse(text)
        message = parsed?.error?.message || parsed?.message || message
      } catch {}
      return Response.json({ error: { code: 'BackendError', message } }, { status: res.status })
    }

    if (!text || !text.trim()) {
      return Response.json({ error: { code: 'EmptyResponse', message: '后端返回了空响应' } }, { status: 500 })
    }

    return Response.json(JSON.parse(text))
  } catch (error: any) {
    if (error?.name === 'AbortError') {
      return Response.json({ error: { code: 'Timeout', message: '请求超时，请稍后重试' } }, { status: 408 })
    }
    return Response.json(
      { error: { code: 'InternalError', message: error instanceof Error ? error.message : '未知错误' } },
      { status: 500 }
    )
  }
}
