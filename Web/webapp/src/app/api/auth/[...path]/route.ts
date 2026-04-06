import { NextRequest } from 'next/server'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

function buildBackendUrl(pathSegments: string[]): string {
  const apiBase = getApiBase().replace(/\/+$/, '')
  const authPath = pathSegments.join('/')
  return `${apiBase}/auth/${authPath}`
}

async function proxy(req: NextRequest, method: 'GET' | 'POST' | 'PUT') {
  try {
    const segments = req.nextUrl.pathname.split('/').filter(Boolean)
    const pathSegments = segments.slice(2) // /api/auth/...
    const backendUrl = buildBackendUrl(pathSegments)

    const authHeader = req.headers.get('authorization') || req.headers.get('Authorization')
    const xAuthToken = req.headers.get('x-auth-token') || req.headers.get('X-Auth-Token')
    const xFindyuBearer = req.headers.get('x-findyu-bearer') || req.headers.get('X-Findyu-Bearer')
    const contentType = req.headers.get('content-type')
    const headers: HeadersInit = {}
    if (contentType) headers['Content-Type'] = contentType
    if (authHeader) headers['Authorization'] = authHeader
    if (xAuthToken) headers['X-Auth-Token'] = xAuthToken
    if (xFindyuBearer) headers['X-Findyu-Bearer'] = xFindyuBearer

    const fetchOptions: RequestInit = {
      method,
      headers,
      cache: 'no-store',
    }
    if (method !== 'GET') {
      fetchOptions.body = await req.arrayBuffer()
    }

    const res = await fetch(backendUrl, fetchOptions)
    const text = await res.text()

    let data: any = null
    try {
      data = text ? JSON.parse(text) : {}
    } catch {
      data = { message: text || '后端返回了非 JSON 响应' }
    }
    return Response.json(data, { status: res.status })
  } catch (error: any) {
    return Response.json(
      {
        error: {
          code: 'ProxyError',
          message: error?.message || '认证请求代理失败',
        },
      },
      { status: 500 }
    )
  }
}

export async function GET(req: NextRequest) {
  return proxy(req, 'GET')
}

export async function POST(req: NextRequest) {
  return proxy(req, 'POST')
}

export async function PUT(req: NextRequest) {
  return proxy(req, 'PUT')
}

