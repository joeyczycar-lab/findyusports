import './globals.css'
import { ReactNode } from 'react'
import { headers } from 'next/headers'
import LayoutClient from '@/components/LayoutClient'
import ForceButtonRadius from '@/components/ForceButtonRadius'
import AnalyticsProvider from '@/components/AnalyticsProvider'

/** 主站域名，用于无 request 时的 fallback；支持多域名时在 Vercel 添加第二个域名即可，OG/链接会随访问域名动态生成 */
const DEFAULT_SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://findyusports.com'

export async function generateMetadata() {
  const headersList = await headers()
  const host = headersList.get('host') || ''
  const baseUrl = host && !host.includes('localhost')
    ? `https://${host}`
    : DEFAULT_SITE_URL
  return {
    title: 'FY体育（Find遇体育） - 篮球足球场地分享与地图',
    description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传。查找附近篮球场、足球场。',
    metadataBase: new URL(baseUrl),
    openGraph: {
      title: 'FY体育 - 篮球足球场地分享与地图',
      description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传。',
      url: baseUrl,
      siteName: 'FY体育',
      locale: 'zh_CN',
      type: 'website',
    },
  }
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="zh-CN">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
        {/* Baidu 站长平台 HTML 标签验证 */}
        <meta name="baidu-site-verification" content="codeva-5UFFf011c" />
        <meta name="baidu-site-verification" content="codeva-iO2Y0n6FI9" />
      </head>
      <body className="pt-nav-offset pb-bottom-nav" style={{ margin: 0, padding: 0 }}>
        <ForceButtonRadius />
        <AnalyticsProvider />
        <LayoutClient>{children}</LayoutClient>
      </body>
    </html>
  )
}


