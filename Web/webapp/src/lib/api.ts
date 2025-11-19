import { getAuthHeader } from './auth'

export function getApiBase(): string {
  const base = process.env.NEXT_PUBLIC_API_BASE?.trim()
  return base && base.length > 0 ? base : ''
}

export async function fetchJson(path: string, options?: RequestInit) {
  const base = getApiBase()
  const url = `${base}${path}`
  const res = await fetch(url, { 
    cache: 'no-store',
    headers: {
      'Content-Type': 'application/json',
      ...getAuthHeader(),
      ...options?.headers,
    },
    ...options,
  })
  if (!res.ok) throw new Error(`Request failed: ${res.status}`)
  return res.json()
}


