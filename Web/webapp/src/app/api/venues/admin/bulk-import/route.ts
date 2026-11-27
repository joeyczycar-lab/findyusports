import { NextRequest } from 'next/server'

export const dynamic = 'force-dynamic'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

export async function POST(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const body = await req.json()
    const authHeader = req.headers.get('authorization') || req.headers.get('Authorization')
    const xAuthToken = req.headers.get('x-auth-token') || req.headers.get('X-Auth-Token')
    const headers: HeadersInit = { 'Content-Type': 'application/json' }
    if (authHeader) headers['Authorization'] = authHeader
    if (xAuthToken) headers['X-Auth-Token'] = xAuthToken

    // 批量导入逐条入库 + 挂首图，耗时较长，放宽到 5 分钟
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 300000)
    const res = await fetch(`${apiBase}/venues/admin/bulk-import`, {
      method: 'POST',
      headers,
      body: JSON.stringify(body),
      cache: 'no-store',
      signal: controller.signal,
    })
    clearTimeout(timeoutId)

    const text = await res.text()
    return new Response(text, {
      status: res.status,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error: any) {
    const message = error?.name === 'AbortError' ? '批量导入超时，请减少单次导入条数后重试' : error instanceof Error ? error.message : '批量导入失败'
    return Response.json(
      { error: { code: 'InternalServerError', message } },
      { status: 500 }
    )
  }
}
