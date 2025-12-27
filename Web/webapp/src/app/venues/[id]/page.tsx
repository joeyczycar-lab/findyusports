import Link from 'next/link'
import dynamic from 'next/dynamic'
import { fetchJson } from '@/lib/api'

// 使用动态导入延迟加载客户端组件，避免 SSR 问题
const Gallery = dynamic(() => import('@/components/Gallery'), { ssr: true })
const Reviews = dynamic(() => import('@/components/Reviews'), { ssr: true })
const ReviewForm = dynamic(() => import('@/components/ReviewForm'), { ssr: false })
const MapPreview = dynamic(() => import('@/components/MapPreview'), { ssr: false })

export default async function VenueDetailPage({ params }: { params: { id: string } }) {
  const venueId = params.id
  
  let detail: any = null
  let images: any = { items: [] }
  let reviews: any = { items: [] }
  
  try {
    [detail, images, reviews] = await Promise.all([
      fetchJson(`/venues/${venueId}`).catch(() => null),
      fetchJson(`/venues/${venueId}/images`).catch(() => ({ items: [] })),
      fetchJson(`/venues/${venueId}/reviews`).catch(() => ({ items: [] })),
    ])
  } catch (error) {
    // 静默处理错误，继续渲染
    // console.error('Failed to fetch venue data:', error)
  }
  
  const v = detail?.id ? detail : null
  // 使用带防盗链保护的URL
  const urls: string[] = images?.items?.map((x: any) => x.protectedUrl || x.url) ?? []
  
  // 计算平均评分（确保格式一致）
  const avgRating = reviews?.items?.length > 0
    ? Number((reviews.items.reduce((sum: number, r: any) => sum + (r.rating || 0), 0) / reviews.items.length).toFixed(1))
    : null

  return (
    <main className="container-page py-12 bg-white">
      <div className="mb-8">
        <Link href="/map" className="link-nike inline-flex items-center gap-2">
          ← 返回地图
        </Link>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-12">
        <div>
          <div className="mb-8">
            <Gallery urls={urls} venueId={venueId} />
          </div>
          <h1 className="text-heading font-bold mb-4 tracking-tight">{v ? v.name : `场地 #${venueId}`}</h1>
          <div className="text-body-sm text-textSecondary mb-8 uppercase tracking-wide">
            {v ? (
              <>
                {v.sportType === 'basketball' ? '篮球' : '足球'} · {v.indoor ? '室内' : '室外'} · {v.priceMin ? `¥${v.priceMin}` : '免费'}
                {avgRating !== null && <span className="ml-2">· {avgRating.toFixed(1)} 评分</span>}
              </>
            ) : '加载中…'}
          </div>

          <section className="border-t border-border pt-8 mb-8">
            <h2 className="text-heading-sm font-bold mb-6 tracking-tight">关键信息</h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-6 text-body-sm">
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">城市</div>
                <div className="font-medium">{v?.cityCode ?? '-'}</div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">地址</div>
                <div className="font-medium">{v?.address ?? '-'}</div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">价格</div>
                <div className="font-medium">{v?.priceMin ? `¥${v.priceMin}` : '免费'}</div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">室内外</div>
                <div className="font-medium">{v?.indoor ? '室内' : '室外'}</div>
              </div>
            </div>
          </section>

          <section className="border-t border-border pt-8 mb-8">
            <h2 className="text-heading-sm font-bold mb-6 tracking-tight">用户点评</h2>
            <Reviews items={reviews?.items ?? []} />
          </section>

          <section className="border-t border-border pt-8">
            <h2 className="text-heading-sm font-bold mb-6 tracking-tight">写点评</h2>
            <ReviewForm venueId={venueId} />
          </section>
        </div>

        <aside className="space-y-6">
          {v && (
            <MapPreview 
              className="h-80" 
              position={v.location} 
              name={v.name}
              zoom={16}
            />
          )}
          {!v && (
            <div className="h-80 border border-border bg-bgMuted flex items-center justify-center text-textMuted">加载中...</div>
          )}
          <a 
            className="btn-primary w-full text-center block" 
            href={v ? `https://uri.amap.com/marker?position=${v.location[0]},${v.location[1]}&name=${encodeURIComponent(v.name)}` : '#'} 
            target="_blank"
            rel="noopener noreferrer"
          >
            导航到这里
          </a>
          <button className="btn-secondary w-full">收藏</button>
        </aside>
      </div>
    </main>
  )
}


