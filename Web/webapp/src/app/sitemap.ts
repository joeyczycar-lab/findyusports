import type { MetadataRoute } from 'next'
import { headers } from 'next/headers'

const FALLBACK_BASE = process.env.NEXT_PUBLIC_SITE_URL || 'https://findyusports.com'
const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://findyu.cn'

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const headersList = await headers()
  const host = headersList.get('host') || ''
  const base = host && !host.includes('localhost') ? `https://${host}` : FALLBACK_BASE

  let venueUrls: { url: string; lastModified: Date; changeFrequency?: string; priority?: number }[] = []
  try {
    const res = await fetch(`${API_BASE}/api/venues?limit=2000`)
    const data = await res.json()
    if (data?.items?.length > 0) {
      venueUrls = data.items
        .filter((v: any) => v?.id)
        .map((v: any) => ({
          url: `${base}/venues/${v.id}`,
          lastModified: v.updatedAt ? new Date(v.updatedAt) : new Date(),
          changeFrequency: 'weekly' as const,
          priority: 0.6,
        }))
    }
  } catch (e) {
    console.error('Failed to fetch venues for sitemap:', e)
  }

  return [
    { url: base, lastModified: new Date(), changeFrequency: 'daily', priority: 1 },
    { url: `${base}/map`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.9 },
    { url: `${base}/map?sport=basketball`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.8 },
    { url: `${base}/map?sport=football`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.8 },
    { url: `${base}/venues`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.7 },
    { url: `${base}/app`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.5 },
    ...venueUrls,
  ]
}
