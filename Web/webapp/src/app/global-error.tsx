'use client'

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <html>
      <body>
        <div className="container-page py-12">
          <div className="text-center">
            <h1 className="text-heading font-bold mb-4">严重错误</h1>
            <p className="text-body text-textSecondary mb-8">
              {error.message || '发生了严重错误'}
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
      </body>
    </html>
  )
}

