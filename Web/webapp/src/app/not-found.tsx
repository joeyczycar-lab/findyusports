import Link from 'next/link'

export default function NotFound() {
  return (
    <div className="container-page py-12">
      <div className="text-center">
        <h1 className="text-heading font-bold mb-4">404 - 页面未找到</h1>
        <p className="text-body text-textSecondary mb-8">
          抱歉，您访问的页面不存在
        </p>
        <Link
          href="/"
          className="btn-primary inline-block"
          style={{ borderRadius: '4px' }}
        >
          返回首页
        </Link>
      </div>
    </div>
  )
}

