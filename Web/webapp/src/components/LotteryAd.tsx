'use client'

import { useState } from 'react'

type Props = {
  className?: string
}

export default function LotteryAd({ className = '' }: Props) {
  const [imageError, setImageError] = useState(false)

  return (
    <div className={`bg-white border border-border p-6 ${className}`} style={{ borderRadius: '4px' }}>
      <div className="text-center">
        <h3 className="text-heading-sm font-bold mb-2 text-primary">体彩竞彩打票</h3>
        <p className="text-body-sm text-textSecondary mb-4">实体店在线打票，安全快速</p>
        
        <div className="flex justify-center mb-4">
          <div className="relative w-48 h-48 bg-gray-50 border border-border overflow-hidden flex items-center justify-center" style={{ borderRadius: '4px' }}>
            {!imageError ? (
              <img
                src="/wechat-qrcode.jpg"
                alt="微信二维码"
                className="w-full h-full object-contain"
                onError={() => setImageError(true)}
              />
            ) : (
              <div className="w-full h-full flex flex-col items-center justify-center text-textMuted text-sm p-4">
                <div className="mb-2 text-4xl">📱</div>
                <div className="text-center">请上传微信二维码<br />到 public/wechat-qrcode.jpg</div>
              </div>
            )}
          </div>
        </div>
        
        <p className="text-xs text-textMuted">扫码添加微信，在线打票</p>
      </div>
    </div>
  )
}
