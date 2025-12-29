import { NextRequest } from 'next/server'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  return base && base.length > 0 ? base : 'http://localhost:4000'
}

export async function GET(req: NextRequest) {
  try {
    const apiBase = getApiBase()
    const searchParams = req.nextUrl.searchParams
    const queryString = searchParams.toString()
    const backendUrl = `${apiBase}/venues${queryString ? `?${queryString}` : ''}`
    
    const res = await fetch(backendUrl, {
      cache: 'no-store',
      headers: {
        'Content-Type': 'application/json',
      },
    })
    
    if (!res.ok) {
      const errorText = await res.text()
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
    return Response.json(data)
  } catch (error) {
    console.error('❌ Error proxying to backend:', error)
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
