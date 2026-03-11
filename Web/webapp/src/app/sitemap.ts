import type { MetadataRoute } from 'next'
import { headers } from 'next/headers'

const FALLBACK_BASE = process.env.NEXT_PUBLIC_SITE_URL || 'https://findyusports.com'

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const headersList = await headers()
  const host = headersList.get('host') || ''
  const base = host && !host.includes('localhost') ? `https://${host}` : FALLBACK_BASE
  return [
    { url: base, lastModified: new Date(), changeFrequency: 'daily', priority: 1 },
    { url: `${base}/map`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.9 },
    { url: `${base}/map?sport=basketball`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.8 },
    { url: `${base}/map?sport=football`, lastModified: new Date(), changeFrequency: 'daily', priority: 0.8 },
    { url: `${base}/venues`, lastModified: new Date(), changeFrequency: 'weekly', priority: 0.7 },
    { url: `${base}/app`, lastModified: new Date(), changeFrequency: 'monthly', priority: 0.5 },
  ]
}
