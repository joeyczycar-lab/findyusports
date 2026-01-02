import Link from 'next/link'
import dynamic from 'next/dynamic'
import { fetchJson } from '@/lib/api'
import NavigationMenu from '@/components/NavigationMenu'

// 使用动态导入延迟加载客户端组件，避免 SSR 问题
// Gallery 是客户端组件（使用 useState），禁用 SSR 以避免 hydration 错误
const Gallery = dynamic(() => import('@/components/Gallery'), { ssr: false })
// Reviews 是客户端组件（使用 useState 和日期格式化），禁用 SSR
const Reviews = dynamic(() => import('@/components/Reviews'), { ssr: false })
const ReviewForm = dynamic(() => import('@/components/ReviewForm'), { ssr: false })

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
  // 传递图片对象（包含 id 和 url），以便 Gallery 组件可以删除图片
  const imageItems = images?.items?.map((x: any) => ({ id: x.id, url: x.url })) ?? []
  
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
            <Gallery urls={imageItems} venueId={venueId} />
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
                <div className="font-medium">
                  {v && v.location ? (
                    <NavigationMenu
                      address={v.address || '地址未填写'}
                      location={v.location}
                      name={v.name}
                    />
                  ) : (
                    <span>{v?.address ?? '-'}</span>
                  )}
                </div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">价格</div>
                <div className="font-medium">{v?.priceMin ? `¥${v.priceMin}` : '免费'}</div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">室内外</div>
                <div className="font-medium">{v?.indoor ? '室内' : '室外'}</div>
              </div>
              {v?.contact && (
                <div>
                  <div className="text-textSecondary uppercase tracking-wide mb-1">联系方式</div>
                  <div className="font-medium">{v.contact}</div>
                </div>
              )}
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
          {v && v.location && (
            <div className="border border-border p-6" style={{ borderRadius: '4px' }}>
              <h3 className="text-heading-sm font-bold mb-4">位置信息</h3>
              <div className="space-y-3 text-body-sm">
                <div>
                  <div className="text-textSecondary uppercase tracking-wide mb-1">地址</div>
                  <NavigationMenu
                    address={v.address || '地址未填写'}
                    location={v.location}
                    name={v.name}
                  />
                </div>
                {v.contact && (
                  <div>
                    <div className="text-textSecondary uppercase tracking-wide mb-1">联系方式</div>
                    <div className="font-medium">{v.contact}</div>
                  </div>
                )}
              </div>
            </div>
          )}
          <button className="btn-secondary w-full">收藏</button>
        </aside>
      </div>
    </main>
  )
}


