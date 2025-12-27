'use client'

import { useEffect } from 'react'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    // 记录错误到控制台
    console.error('Error:', error)
  }, [error])

  return (
    <div className="container-page py-12">
      <div className="text-center">
        <h1 className="text-heading font-bold mb-4">出错了</h1>
        <p className="text-body text-textSecondary mb-8">
          {error.message || '发生了未知错误'}
        </p>
        <button
          onClick={reset}
          className="btn-primary"
          style={{ borderRadius: '4px' }}
        >
          重试
        </button>
      </div>
    </div>
  )
}

