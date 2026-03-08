import { NextRequest } from 'next/server'

export const dynamic = 'force-dynamic'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

async function proxyBookings(
  req: NextRequest,
  method: 'GET' | 'POST',
  body?: unknown
): Promise<Response> {
  const apiBase = getApiBase()
  const backendUrl = `${apiBase}/bookings`
  const authHeader = req.headers.get('authorization') || req.headers.get('Authorization')
  const headers: HeadersInit = { 'Content-Type': 'application/json' }
  if (authHeader) headers['Authorization'] = authHeader

  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), 15000)
  let res: Response
  try {
    res = await fetch(backendUrl, {
      method,
      headers,
      ...(body !== undefined ? { body: JSON.stringify(body) } : {}),
      cache: 'no-store',
      signal: controller.signal,
    })
    clearTimeout(timeoutId)
  } catch (e: any) {
    clearTimeout(timeoutId)
    if (e?.name === 'AbortError') {
      return Response.json(
        { error: { code: 'Timeout', message: '请求超时，请稍后重试' } },
        { status: 504 }
      )
    }
    return Response.json(
      { error: { code: 'BackendUnreachable', message: '无法连接服务，请稍后重试' } },
      { status: 502 }
    )
  }

  const text = await res.text()
  if (!res.ok) {
    let msg = `请求失败: ${res.status}`
    try {
      if (text?.trim()) {
        const j = JSON.parse(text)
        msg = j.error?.message || j.message || msg
      }
    } catch {}
    if (res.status === 401) msg = '请先登录'
    return Response.json({ error: { code: 'BackendError', message: msg } }, { status: res.status })
  }
  const contentType = res.headers.get('content-type')
  if (!contentType?.includes('application/json')) {
    return Response.json(
      { error: { code: 'InvalidResponse', message: '服务器返回格式错误' } },
      { status: 500 }
    )
  }
  if (!text?.trim()) {
    return Response.json(
      { error: { code: 'EmptyResponse', message: '服务器返回为空' } },
      { status: 500 }
    )
  }
  try {
    return Response.json(JSON.parse(text))
  } catch {
    return Response.json(
      { error: { code: 'ParseError', message: '解析响应失败' } },
      { status: 500 }
    )
  }
}

export async function GET(req: NextRequest) {
  return proxyBookings(req, 'GET')
}

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => ({}))
  return proxyBookings(req, 'POST', body)
}
