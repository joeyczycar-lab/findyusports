import './globals.css'
import { ReactNode } from 'react'

export const metadata = {
  title: '运动场地分享 | 篮球·足球',
  description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传',
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="zh-CN">
      <body>
        {children}
      </body>
    </html>
  )
}


