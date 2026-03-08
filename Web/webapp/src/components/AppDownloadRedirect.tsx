'use client'

import { useEffect, useState } from 'react'

const APK_URL = '/findyusports.apk'

function isMobileUserAgent(): boolean {
  if (typeof navigator === 'undefined') return false
  const ua = navigator.userAgent.toLowerCase()
  return /android|iphone|ipad|ipod|mobile|webos|blackberry|iemobile|opera mini/i.test(ua)
}

export default function AppDownloadRedirect() {
  const [didRedirect, setDidRedirect] = useState(false)

  useEffect(() => {
    if (!isMobileUserAgent()) return
    setDidRedirect(true)
    window.location.href = APK_URL
  }, [])

  if (didRedirect) {
    return (
      <div className="text-center py-8 text-gray-600 text-sm">
        正在跳转下载…
      </div>
    )
  }

  return null
}

export { APK_URL }
