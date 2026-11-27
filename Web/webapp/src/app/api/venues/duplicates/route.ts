import { NextRequest } from 'next/server'

export const dynamic = 'force-dynamic'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

export async function GET(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const qs = req.nextUrl.searchParams.toString()
    const backendUrl = `${apiBase}/venues/duplicates${qs ? `?${qs}` : ''}`

    const authHeader = req.headers.get('authorization') || req.headers.get('Authorization')
    const headers: HeadersInit = { 'Content-Type': 'application/json' }
    if (authHeader) headers['Authorization'] = authHeader

    const res = await fetch(backendUrl, { cache: 'no-store', headers })
    const text = await res.text()
    return new Response(text, {
      status: res.status,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return Response.json(
      { error: { code: 'InternalServerError', message: error instanceof Error ? error.message : '获取重复场地失败' }, total: 0, items: [] },
      { status: 500 }
    )
  }
}
