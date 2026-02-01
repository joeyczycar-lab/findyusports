import { NextRequest } from 'next/server'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

export async function GET(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const authHeader = req.headers.get('authorization')
    const res = await fetch(`${apiBase}/auth/profile`, {
      method: 'GET',
      headers: authHeader ? { Authorization: authHeader } : {},
      cache: 'no-store',
    })
    const data = await res.json().catch(() => ({}))
    return Response.json(data, { status: res.status })
  } catch (e) {
    return Response.json(
      { error: { message: e instanceof Error ? e.message : '请求失败' } },
      { status: 500 }
    )
  }
}

export async function PUT(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const authHeader = req.headers.get('authorization')
    const body = await req.json()
    const res = await fetch(`${apiBase}/auth/profile`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        ...(authHeader ? { Authorization: authHeader } : {}),
      },
      body: JSON.stringify(body),
      cache: 'no-store',
    })
    const data = await res.json().catch(() => ({}))
    return Response.json(data, { status: res.status })
  } catch (e) {
    return Response.json(
      { error: { message: e instanceof Error ? e.message : '请求失败' } },
      { status: 500 }
    )
  }
}
