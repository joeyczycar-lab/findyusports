import { NextRequest } from 'next/server'

export const dynamic = 'force-dynamic'
export const runtime = 'nodejs'

function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  if (base && base.length > 0) return base
  if (process.env.NODE_ENV !== 'production') return 'http://localhost:4000'
  return 'https://findyusports-production.up.railway.app'
}

export function GET() {
  return Response.json(
    { error: { message: '请使用 POST 上传头像，并携带 multipart/form-data 字段 file' } },
    { status: 405 }
  )
}

export async function POST(req: NextRequest) {
  try {
    const formData = await req.formData()
    const file = formData.get('file')
    if (!file || !(file instanceof Blob)) {
      return Response.json(
        { error: { message: '请选择图片文件' } },
        { status: 400 }
      )
    }
    const apiBase = getApiBase()
    const backendUrl = `${apiBase}/auth/upload-avatar`
    const authHeader = req.headers.get('authorization')
    const outForm = new FormData()
    outForm.append('file', file)
    const headers: Record<string, string> = {}
    if (authHeader) headers['Authorization'] = authHeader
    const res = await fetch(backendUrl, {
      method: 'POST',
      headers,
      body: outForm,
      cache: 'no-store',
    })
    const data = await res.json().catch(() => ({}))
    if (res.status === 404) {
      return Response.json(
        {
          error: {
            message: '后端暂不支持头像上传，请确保 Server 已部署最新代码（包含 POST /auth/upload-avatar）',
          },
        },
        { status: 502 }
      )
    }
    return Response.json(data, { status: res.status })
  } catch (e) {
    return Response.json(
      { error: { message: e instanceof Error ? e.message : '上传失败' } },
      { status: 500 }
    )
  }
}
