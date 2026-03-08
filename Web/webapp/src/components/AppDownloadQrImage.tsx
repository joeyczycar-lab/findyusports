'use client'

import Image from 'next/image'

export default function AppDownloadQrImage() {
  return (
    <div className="relative w-40 h-40">
      <Image
        src="/app-download-qrcode.png"
        alt="FY体育 App 下载二维码"
        fill
        sizes="160px"
        className="object-contain"
        onError={(e) => {
          const img = e.currentTarget as HTMLImageElement
          if (img.src.endsWith('/app-download-qrcode.png')) {
            img.src = '/wechat-qrcode.jpg'
            img.alt = '扫码添加微信'
          }
        }}
      />
    </div>
  )
}
