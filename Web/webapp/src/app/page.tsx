import Link from 'next/link'
import { getApiBase } from '@/lib/api'
// 临时注释掉LotteryAd以避免构建错误
// import dynamic from 'next/dynamic'
// const LotteryAd = dynamic(() => import('@/components/LotteryAd'), {
//   ssr: false
// })

async function getFeaturedVenues() {
  try {
    const base = getApiBase()
    // 如果API地址未配置，返回空数组
    if (!base || base.length === 0) {
      console.warn('NEXT_PUBLIC_API_BASE is not configured, skipping venue fetch')
      return []
    }
    const url = `${base}/venues?limit=6`
    const res = await fetch(url, { 
      next: { revalidate: 60 }, // 重新验证时间：60秒
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (!res.ok) throw new Error(`Request failed: ${res.status}`)
    const data = await res.json()
    return data?.items || []
  } catch (error) {
    console.error('Failed to fetch venues:', error)
    return []
  }
}

export default async function HomePage() {
  const venues = await getFeaturedVenues()

  return (
    <main className="bg-white">
      {/* 为固定导航栏留出空间 */}
      <div className="h-16"></div>
      
      {/* Hero Section - Nike 风格大图 */}
      <section className="relative bg-black text-white min-h-[600px] flex items-center" style={{ zIndex: 1 }}>
        <div className="absolute inset-0 bg-[url('/hero-background.jpg')] bg-cover bg-center" style={{ zIndex: 1 }}></div>
        <div className="absolute inset-0 bg-black/40" style={{ zIndex: 1 }}></div>
        <div className="container-page relative z-10 py-20" style={{ zIndex: 2 }}>
          <h1 className="text-display sm:text-[64px] font-bold mb-8 tracking-tight max-w-2xl">
            发现与分享<br />篮球与足球好场地
          </h1>
          <div className="max-w-xl space-y-4">
            <div className="flex flex-col sm:flex-row gap-3">
              <input 
                className="flex-1 bg-white text-black px-6 py-4 text-body border-0 focus:outline-none focus:ring-2 focus:ring-white" 
                placeholder="搜索城市、关键词…" 
              />
              <Link href="/map" className="btn-primary whitespace-nowrap">
                开始探索
              </Link>
            </div>
            <div className="flex flex-wrap gap-3">
              <Link href="/map?sport=basketball" className="btn-secondary text-white border-white hover:bg-white hover:text-black">
                篮球
              </Link>
              <Link href="/map?sport=football" className="btn-secondary text-white border-white hover:bg-white hover:text-black">
                足球
              </Link>
              <Link href="/admin/add-venue" className="bg-white text-black px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-100 transition-colors duration-200 border-2 border-white shadow-2xl !inline-flex items-center justify-center min-w-[140px]">
                ➕ 添加场地
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Featured Venues Section */}
      <section className="container-page py-20">
        <div className="flex items-center justify-between mb-12 flex-wrap gap-4">
          <h2 className="text-heading font-bold tracking-tight">精选场地</h2>
          <div className="flex items-center gap-4">
            <Link href="/admin/add-venue" className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors !inline-flex items-center justify-center shadow-lg">
              ➕ 添加场地
            </Link>
            <Link href="/map" className="link-nike">查看全部 →</Link>
          </div>
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_320px] gap-8">
          {/* 场地列表 */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {venues.length > 0 ? (
              venues.map((venue: any) => {
                // 获取第一张图片（如果有）
                const firstImage = venue.firstImage || null
                return (
                  <Link key={venue.id} href={`/venues/${venue.id}`} className="card-nike group">
                    <div className="h-64 bg-gray-100 relative overflow-hidden">
                      {firstImage ? (
                        <img 
                          src={firstImage} 
                          alt={venue.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                          loading="lazy"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-textMuted text-4xl">
                          {venue.sportType === 'basketball' ? '🏀' : '⚽'}
                        </div>
                      )}
                    </div>
                    <div className="p-6">
                      <div className="font-bold text-heading-sm mb-2 line-clamp-1">{venue.name}</div>
                      <div className="text-body-sm text-textSecondary uppercase tracking-wide">
                        {venue.rating ? `${venue.rating.toFixed(1)} · ` : ''}
                        {venue.priceMin ? `¥${venue.priceMin}` : '免费'} · {venue.indoor ? '室内' : '室外'}
                      </div>
                    </div>
                  </Link>
                )
              })
            ) : (
              <div className="col-span-full text-center text-textSecondary py-16 text-body">
                暂无场地数据
              </div>
            )}
          </div>
          
          {/* 广告区域 - 桌面端显示 */}
          {/* 临时注释掉LotteryAd以避免构建错误 */}
          {/* <aside className="hidden lg:block">
            <div className="sticky top-24">
              <LotteryAd />
            </div>
          </aside> */}
        </div>
        
        {/* 广告区域 - 移动端显示 */}
        {/* <div className="lg:hidden mt-8">
          <LotteryAd />
        </div> */}
      </section>

      {/* 浮动添加场地按钮 - 移动端 */}
      <div className="fixed bottom-6 right-6 z-50 lg:hidden">
        <Link 
          href="/admin/add-venue" 
          className="bg-black text-white px-6 py-4 rounded-full shadow-lg hover:bg-gray-900 transition-colors duration-200 flex items-center gap-2 font-bold text-sm uppercase tracking-wider"
        >
          <span className="text-xl">➕</span>
          <span>添加场地</span>
        </Link>
      </div>
    </main>
  )
}

