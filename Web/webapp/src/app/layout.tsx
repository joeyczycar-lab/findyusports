import './globals.css'
import { ReactNode } from 'react'
import Link from 'next/link'
import Nav from '@/components/Nav'
import ForceButtonRadius from '@/components/ForceButtonRadius'
import AnalyticsProvider from '@/components/AnalyticsProvider'

export const metadata = {
  title: 'Find遇体育，体育场地在线分享',
  description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传',
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="zh-CN">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className="pt-nav-offset" style={{ margin: 0, padding: 0 }}>
        <ForceButtonRadius />
        <AnalyticsProvider />
        <Nav />
        {children}
      </body>
    </html>
  )
}


