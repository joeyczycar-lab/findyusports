import type { MetadataRoute } from 'next'
import { headers } from 'next/headers'

const FALLBACK_BASE = process.env.NEXT_PUBLIC_SITE_URL || 'https://findyusports.com'

export default async function robots(): Promise<MetadataRoute.Robots> {
  const headersList = await headers()
  const host = headersList.get('host') || ''
  const base = host && !host.includes('localhost') ? `https://${host}` : FALLBACK_BASE
  return {
    rules: { userAgent: '*', allow: '/', disallow: [] },
    sitemap: `${base}/sitemap.xml`,
  }
}
