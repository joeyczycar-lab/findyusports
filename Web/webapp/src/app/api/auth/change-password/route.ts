import { NextRequest } from 'next/server'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

export async function PUT(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const authHeader = req.headers.get('authorization')
    const body = await req.json()
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 15000)
    const res = await fetch(`${apiBase}/auth/change-password`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        ...(authHeader ? { Authorization: authHeader } : {}),
      },
      body: JSON.stringify(body),
      cache: 'no-store',
      signal: controller.signal,
    })
    clearTimeout(timeoutId)
    const data = await res.json().catch(() => ({}))
    return Response.json(data, { status: res.status })
  } catch (e: any) {
    const isTimeout = e?.name === 'AbortError'
    return Response.json(
      {
        error: {
          message: isTimeout ? '请求超时，请稍后重试' : (e instanceof Error ? e.message : '请求失败'),
        },
      },
      { status: isTimeout ? 408 : 500 }
    )
  }
}
