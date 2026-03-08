import './globals.css'
import { ReactNode } from 'react'
import LayoutClient from '@/components/LayoutClient'
import ForceButtonRadius from '@/components/ForceButtonRadius'
import AnalyticsProvider from '@/components/AnalyticsProvider'

export const metadata = {
  title: 'FY体育（Find遇体育） - 篮球足球场地分享与地图',
  description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传。查找附近篮球场、足球场。',
  openGraph: {
    title: 'FY体育 - 篮球足球场地分享与地图',
    description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传。',
    url: 'https://findyusports.com',
    siteName: 'FY体育',
    locale: 'zh_CN',
    type: 'website',
  },
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="zh-CN">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
      </head>
      <body className="pt-nav-offset pb-bottom-nav" style={{ margin: 0, padding: 0 }}>
        <ForceButtonRadius />
        <AnalyticsProvider />
        <LayoutClient>{children}</LayoutClient>
      </body>
    </html>
  )
}


