import Link from 'next/link'

export default function VenueNotFound() {
  return (
    <div className="container-page py-12">
      <div className="text-center">
        <h1 className="text-heading font-bold mb-4">场地未找到</h1>
        <p className="text-body text-textSecondary mb-8">
          抱歉，您访问的场地不存在或已被删除
        </p>
        <div className="flex gap-4 justify-center">
          <Link
            href="/map"
            className="btn-primary"
            style={{ borderRadius: '4px' }}
          >
            返回地图
          </Link>
          <Link
            href="/"
            className="btn-secondary"
            style={{ borderRadius: '4px' }}
          >
            返回首页
          </Link>
        </div>
      </div>
    </div>
  )
}

