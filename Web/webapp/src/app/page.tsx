import Link from 'next/link'
import { getApiBase } from '@/lib/api'
import dynamic from 'next/dynamic'

// 使用动态导入加载客户端组件，避免 SSR 问题
const LotteryAd = dynamic(() => import('@/components/LotteryAd'), {
  ssr: false
})

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
      // 添加超时和错误处理
      signal: AbortSignal.timeout(5000), // 5秒超时
    })
    if (!res.ok) throw new Error(`Request failed: ${res.status}`)
    const data = await res.json()
    return data?.items || []
  } catch (error) {
    // 静默处理网络错误，不影响构建
    if (error instanceof Error) {
      // 只在开发环境输出错误
      if (process.env.NODE_ENV === 'development') {
        console.error('Failed to fetch venues:', error.message)
      }
    }
    return []
  }
}

async function getVenuesBySport(sport: 'basketball' | 'football') {
  try {
    const base = getApiBase()
    if (!base || base.length === 0) {
      return []
    }
    const url = `${base}/venues?sport=${sport}&pageSize=100`
    const res = await fetch(url, { 
      next: { revalidate: 60 },
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (!res.ok) throw new Error(`Request failed: ${res.status}`)
    const data = await res.json()
    return data?.items || []
  } catch (error) {
    console.error(`Failed to fetch ${sport} venues:`, error)
    return []
  }
}

export default async function HomePage() {
  const venues = await getFeaturedVenues()
  const basketballVenues = await getVenuesBySport('basketball')
  const footballVenues = await getVenuesBySport('football')

  return (
    <main className="bg-white" style={{ paddingTop: 0 }}>
      {/* 首页 Hero 区域不需要额外的 padding-top，因为 body 已经有了 */}
      
      {/* Hero Section - Nike 风格大图 */}
      <section className="relative text-white min-h-[600px] flex items-center overflow-hidden" style={{ position: 'relative' }}>
        {/* 强制样式 - 确保背景图片显示 */}
        <style dangerouslySetInnerHTML={{
          __html: `
            section:first-of-type {
              background-color: transparent !important;
            }
            .hero-bg-image {
              position: absolute !important;
              top: 0 !important;
              left: 0 !important;
              right: 0 !important;
              bottom: 0 !important;
              width: 100% !important;
              height: 100% !important;
              background-image: url('/hero-background.jpg') !important;
              background-size: cover !important;
              background-position: center !important;
              background-repeat: no-repeat !important;
              z-index: 0 !important;
              opacity: 1 !important;
              visibility: visible !important;
              display: block !important;
              pointer-events: none !important;
            }
          `
        }} />
        {/* 背景图片层 - 使用内联样式 + CSS 类双重保障 */}
        <div 
          className="hero-bg-image absolute inset-0"
          style={{
            zIndex: 0,
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            width: '100%',
            height: '100%',
            backgroundImage: "url('/hero-background.jpg')",
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            backgroundRepeat: 'no-repeat',
            opacity: 1,
            visibility: 'visible',
            display: 'block',
            pointerEvents: 'none'
          }}
        />
        {/* 半透明遮罩层 - 降低透明度让图片更明显 */}
        <div className="absolute inset-0" style={{ zIndex: 1, backgroundColor: 'rgba(0, 0, 0, 0.2)' }}></div>
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
              <Link href="/map" className="btn-primary whitespace-nowrap flex items-center justify-center" style={{ borderRadius: '4px', lineHeight: '1', display: 'flex', alignItems: 'center', justifyContent: 'center', paddingTop: '12px', paddingBottom: '12px' }}>
                开始探索
              </Link>
            </div>
            <div className="flex flex-wrap gap-3">
              <Link 
                href="/map?sport=basketball" 
                className="btn-secondary text-white hover:bg-white hover:text-black" 
                style={{ borderRadius: '4px', border: 'none', borderWidth: 0 }}
              >
                篮球
              </Link>
              <Link 
                href="/map?sport=football" 
                className="btn-secondary text-white hover:bg-white hover:text-black" 
                style={{ borderRadius: '4px', border: 'none', borderWidth: 0 }}
              >
                足球
              </Link>
              <Link href="/admin/add-venue" className="bg-white text-black px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-100 transition-colors duration-200 border-2 border-white shadow-2xl !inline-flex items-center justify-center min-w-[140px]" style={{ borderRadius: '4px' }}>
                ➕ 添加场地
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Sport Categories Section - 在搜索栏下面 */}
      <section className="container-page py-16 bg-gray-50">
        {/* 篮球场地分类 */}
        <div className="mb-16">
          <div className="flex items-center justify-between mb-8 flex-wrap gap-4">
            <div className="flex items-center gap-4">
              <span className="text-4xl">🏀</span>
              <h2 className="text-heading font-bold tracking-tight">篮球场地</h2>
              <span className="text-body-sm text-textSecondary">({basketballVenues.length} 个场地)</span>
            </div>
            <Link href="/map?sport=basketball" className="link-nike">查看全部 →</Link>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {basketballVenues.length > 0 ? (
              basketballVenues.map((venue: any) => {
                const firstImage = venue.firstImage || null
                return (
                  <Link key={venue.id} href={`/venues/${venue.id}`} className="card-nike group bg-white">
                    <div className="h-48 bg-gray-100 relative overflow-hidden">
                      {firstImage ? (
                        <img 
                          src={firstImage} 
                          alt={venue.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                          loading="lazy"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-textMuted text-4xl">
                          🏀
                        </div>
                      )}
                    </div>
                    <div className="p-4">
                      <div className="font-bold text-heading-sm mb-2 line-clamp-1">{venue.name}</div>
                      <div className="text-body-sm text-textSecondary uppercase tracking-wide">
                        {venue.priceMin ? `¥${venue.priceMin}` : '免费'} · {venue.indoor ? '室内' : '室外'}
                      </div>
                    </div>
                  </Link>
                )
              })
            ) : (
              <div className="col-span-full text-center text-textSecondary py-12 text-body">
                暂无篮球场地数据
              </div>
            )}
          </div>
        </div>

        {/* 足球场地分类 */}
        <div>
          <div className="flex items-center justify-between mb-8 flex-wrap gap-4">
            <div className="flex items-center gap-4">
              <span className="text-4xl">⚽</span>
              <h2 className="text-heading font-bold tracking-tight">足球场地</h2>
              <span className="text-body-sm text-textSecondary">({footballVenues.length} 个场地)</span>
            </div>
            <Link href="/map?sport=football" className="link-nike">查看全部 →</Link>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {footballVenues.length > 0 ? (
              footballVenues.map((venue: any) => {
                const firstImage = venue.firstImage || null
                return (
                  <Link key={venue.id} href={`/venues/${venue.id}`} className="card-nike group bg-white">
                    <div className="h-48 bg-gray-100 relative overflow-hidden">
                      {firstImage ? (
                        <img 
                          src={firstImage} 
                          alt={venue.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                          loading="lazy"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-textMuted text-4xl">
                          ⚽
                        </div>
                      )}
                    </div>
                    <div className="p-4">
                      <div className="font-bold text-heading-sm mb-2 line-clamp-1">{venue.name}</div>
                      <div className="text-body-sm text-textSecondary uppercase tracking-wide">
                        {venue.priceMin ? `¥${venue.priceMin}` : '免费'} · {venue.indoor ? '室内' : '室外'}
                      </div>
                    </div>
                  </Link>
                )
              })
            ) : (
              <div className="col-span-full text-center text-textSecondary py-12 text-body">
                暂无足球场地数据
              </div>
            )}
          </div>
        </div>
      </section>

      {/* Featured Venues Section */}
      <section className="container-page py-20">
        <div className="flex items-center justify-between mb-12 flex-wrap gap-4">
          <h2 className="text-heading font-bold tracking-tight">精选场地</h2>
          <div className="flex items-center gap-4">
            <Link href="/admin/add-venue" className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors !inline-flex items-center justify-center shadow-lg" style={{ borderRadius: '4px' }}>
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
          <aside className="hidden lg:block">
            <div className="sticky top-24">
              <LotteryAd />
            </div>
          </aside>
        </div>
        
        {/* 广告区域 - 移动端显示 */}
        <div className="lg:hidden mt-8">
          <LotteryAd />
        </div>
      </section>

      {/* 浮动添加场地按钮 - 移动端 */}
      <div className="fixed bottom-6 right-6 z-50 lg:hidden">
        <Link 
          href="/admin/add-venue" 
          className="bg-black text-white px-6 py-4 shadow-lg hover:bg-gray-900 transition-colors duration-200 flex items-center gap-2 font-bold text-sm uppercase tracking-wider"
          style={{ borderRadius: '4px' }}
        >
          <span className="text-xl">➕</span>
          <span>添加场地</span>
        </Link>
      </div>
    </main>
  )
}

