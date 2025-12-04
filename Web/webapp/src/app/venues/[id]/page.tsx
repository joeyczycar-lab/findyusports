import Link from 'next/link'
import { fetchJson } from '@/lib/api'
import Gallery from '@/components/Gallery'
import Reviews from '@/components/Reviews'
import ReviewForm from '@/components/ReviewForm'
import MapPreview from '@/components/MapPreview'

export default async function VenueDetailPage({ params }: { params: { id: string } }) {
  const [detail, images, reviews] = await Promise.all([
    fetchJson(`/venues/${params.id}`),
    fetchJson(`/venues/${params.id}/images`),
    fetchJson(`/venues/${params.id}/reviews`),
  ])
  const v = detail?.id ? detail : null
  // 使用带防盗链保护的URL
  const urls: string[] = images?.items?.map((x: any) => x.protectedUrl || x.url) ?? []
  
  // 计算平均评分
  const avgRating = reviews?.items?.length > 0
    ? (reviews.items.reduce((sum: number, r: any) => sum + (r.rating || 0), 0) / reviews.items.length).toFixed(1)
    : null

  return (
    <main className="container-page py-8">
      <div className="mb-4">
        <Link href="/map" className="text-sm text-textSecondary hover:text-primary inline-flex items-center gap-1">
          ← 返回地图
        </Link>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-8">
        <div>
          <div className="mb-4">
            <Gallery urls={urls} venueId={params.id} />
          </div>
          <h1 className="text-2xl font-semibold mb-2">{v ? v.name : `场地 #${params.id}`}</h1>
          <div className="text-textSecondary mb-6">
            {v ? (
              <>
                {v.sportType === 'basketball' ? '篮球' : '足球'} · {v.indoor ? '室内' : '室外'} · {v.priceMin ? `¥${v.priceMin}` : '免费'}
                {avgRating && <span className="ml-2">· 评分 {avgRating}⭐</span>}
              </>
            ) : '加载中…'}
          </div>

          <section className="border border-border rounded-card p-4 mb-6">
            <h2 className="font-semibold mb-3">关键信息</h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 text-sm">
              <div>城市：{v?.cityCode ?? '-'}</div>
              <div>地址：{v?.address ?? '-'}</div>
              <div>价格：{v?.priceMin ? `¥${v.priceMin}` : '免费'}</div>
              <div>室内外：{v?.indoor ? '室内' : '室外'}</div>
              <div>坐标：{v ? `${v.location[0].toFixed(5)}, ${v.location[1].toFixed(5)}` : '-'}</div>
            </div>
          </section>

          <section className="border border-border rounded-card p-4">
            <h2 className="font-semibold mb-3">用户点评</h2>
            <Reviews items={reviews?.items ?? []} />
          </section>

          <section className="border border-border rounded-card p-4">
            <h2 className="font-semibold mb-3">写点评</h2>
            <ReviewForm venueId={params.id} />
          </section>
        </div>

        <aside className="space-y-4">
          {v && (
            <MapPreview 
              className="h-64" 
              position={v.location} 
              name={v.name}
              zoom={16}
            />
          )}
          {!v && (
            <div className="h-64 rounded-card border border-border bg-gray-100 flex items-center justify-center text-textMuted">加载中...</div>
          )}
          <a 
            className="w-full h-11 rounded-card bg-primary text-white flex items-center justify-center hover:bg-primary/90 transition-colors" 
            href={v ? `https://uri.amap.com/marker?position=${v.location[0]},${v.location[1]}&name=${encodeURIComponent(v.name)}` : '#'} 
            target="_blank"
            rel="noopener noreferrer"
          >
            导航到这里
          </a>
          <button className="w-full h-11 rounded-card border border-border hover:bg-gray-50 transition-colors">收藏</button>
        </aside>
      </div>
    </main>
  )
}


