'use client'

export default function VenueError({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div className="container-page py-12">
      <div className="text-center">
        <h1 className="text-heading font-bold mb-4">加载场地详情失败</h1>
        <p className="text-body text-textSecondary mb-8">
          {error.message || '无法加载场地信息，请稍后重试'}
        </p>
        <div className="flex gap-4 justify-center">
          <button
            onClick={reset}
            className="btn-primary"
            style={{ borderRadius: '4px' }}
          >
            重试
          </button>
          <a
            href="/map"
            className="btn-secondary"
            style={{ borderRadius: '4px' }}
          >
            返回地图
          </a>
        </div>
      </div>
    </div>
  )
}

