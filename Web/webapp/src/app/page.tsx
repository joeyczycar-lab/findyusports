import Link from 'next/link'
import { getApiBase } from '@/lib/api'
import TicketBanner from '@/components/TicketBanner'
import HeroSearch from '@/components/HeroSearch'

// 首页场地数据使用短期缓存（60 秒）以减轻后端压力、加快页面响应
const VENUE_REVALIDATE_SECONDS = 60

async function getFeaturedVenues(): Promise<any[]> {
  try {
    const base = getApiBase()
    if (!base || base.length === 0) return []
    const url = `${base}/venues?limit=6`
    const res = await fetch(url, {
      next: { revalidate: VENUE_REVALIDATE_SECONDS },
      headers: { 'Content-Type': 'application/json' },
      signal: AbortSignal.timeout(5000),
    })
    if (!res.ok) throw new Error(`Request failed: ${res.status}`)
    const data = await res.json()
    return data?.items || []
  } catch (error) {
    if (process.env.NODE_ENV === 'development' && error instanceof Error) {
      console.error('Failed to fetch venues:', error.message)
    }
    return []
  }
}

async function getVenuesBySport(sport: 'basketball' | 'football'): Promise<any[]> {
  try {
    const base = getApiBase()
    if (!base || base.length === 0) return []
    const url = `${base}/venues?sport=${sport}&pageSize=12`
    const res = await fetch(url, {
      next: { revalidate: VENUE_REVALIDATE_SECONDS },
      headers: { 'Content-Type': 'application/json' },
      signal: AbortSignal.timeout(5000),
    })
    if (!res.ok) throw new Error(`Request failed: ${res.status}`)
    const data = await res.json()
    return data?.items || []
  } catch (error) {
    if (process.env.NODE_ENV === 'development') {
      console.error(`Failed to fetch ${sport} venues:`, error)
    }
    return []
  }
}

export default async function HomePage() {
  // 三路请求并行，减少首屏等待时间
  const [venues, basketballVenues, footballVenues] = await Promise.all([
    getFeaturedVenues(),
    getVenuesBySport('basketball'),
    getVenuesBySport('football'),
  ])

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
            /* 响应式：桌面端拉长搜索栏和标题 */
            @media (min-width: 768px) {
              .hero-title-responsive {
                width: 133.33% !important;
                max-width: 133.33% !important;
                margin-left: -16.67% !important;
              }
              .hero-search-responsive {
                width: 133.33% !important;
                max-width: 133.33% !important;
                margin-left: -16.67% !important;
              }
            }
            /* 手机端：保持100%宽度 */
            @media (max-width: 767px) {
              .hero-title-responsive {
                width: 100% !important;
                max-width: 100% !important;
                margin-left: 0 !important;
              }
              .hero-search-responsive {
                width: 100% !important;
                max-width: 100% !important;
                margin-left: 0 !important;
              }
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
        <div className="container-page relative z-10 py-13" style={{ zIndex: 2, paddingTop: '3.25rem', paddingBottom: '3.25rem' }}>
          <h1 
            className="text-display sm:text-[43px] font-bold mb-5 tracking-tight hero-title-responsive" 
            style={{ 
              fontSize: 'clamp(1.5rem, 4vw, 2.67rem)', 
            }}
          >
            不负每一片热爱
          </h1>
          <div 
            className="space-y-3 hero-search-responsive"
          >
            <HeroSearch />
            <div className="flex flex-wrap gap-2">
              <Link 
                href="/map?sport=basketball" 
                className="btn-secondary text-white hover:bg-white hover:text-black" 
                style={{ borderRadius: '4px', border: 'none', borderWidth: 0, padding: '0.5rem 1rem', fontSize: '0.875rem' }}
              >
                篮球
              </Link>
              <Link 
                href="/map?sport=football" 
                className="btn-secondary text-white hover:bg-white hover:text-black" 
                style={{ borderRadius: '4px', border: 'none', borderWidth: 0, padding: '0.5rem 1rem', fontSize: '0.875rem' }}
              >
                足球
              </Link>
              <Link href="/admin/add-venue" className="bg-white text-black px-4 py-2 text-xs font-bold uppercase tracking-wider hover:bg-gray-100 transition-colors duration-200 border-2 border-white shadow-2xl !inline-flex items-center justify-center min-w-[93px]" style={{ borderRadius: '4px' }}>
                ➕ 添加场地
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* 文字区域 - 在广告栏上方 */}
      <div 
        className="bg-white py-8"
        style={{ 
          backgroundColor: '#ffffff',
          paddingTop: '3rem',
          paddingBottom: '3rem',
        }}
      >
        <div className="container-page">
          <div 
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '0.75rem',
              textAlign: 'center',
              maxWidth: '600px',
              margin: '0 auto',
            }}
          >
            <h3 
              className="font-bold"
              style={{
                fontSize: 'clamp(1.5rem, 4vw, 2rem)',
                fontWeight: 'bold',
                lineHeight: '1.2',
                color: '#000000',
                margin: 0,
              }}
            >
              竞彩实体店出票
            </h3>
            <p 
              style={{
                fontSize: 'clamp(0.875rem, 2vw, 1rem)',
                lineHeight: '1.5',
                color: '#000000',
                margin: 0,
              }}
            >
              备战世界杯
            </p>
            <p 
              style={{
                fontSize: 'clamp(0.875rem, 2vw, 1rem)',
                lineHeight: '1.5',
                color: '#000000',
                margin: 0,
              }}
            >
              即刻扫码
            </p>
          </div>
        </div>
      </div>

      {/* 在线打票横幅 - 在场地列表上方 */}
      <TicketBanner />

      {/* Featured Venues Section - Nike 风格大图展示 */}
      <section className="container-page py-20 bg-white">
        <div className="flex items-center justify-between mb-16 flex-wrap gap-4">
          <div>
            <h2 className="text-heading font-bold tracking-tight mb-2">精选场地</h2>
            <p className="text-body-sm text-textSecondary">发现优质运动场地，开启你的运动之旅</p>
          </div>
          <div className="flex items-center gap-4">
            <Link href="/admin/add-venue" className="bg-black text-white px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors !inline-flex items-center justify-center" style={{ borderRadius: '4px' }}>
              ➕ 添加场地
            </Link>
            <Link href="/map" className="text-black font-medium hover:underline">查看全部 →</Link>
          </div>
        </div>
        {/* Nike 风格：大图网格布局 */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {venues.length > 0 ? (
            venues.map((venue: any, index: number) => {
              const firstImage = venue.firstImage || null
              const isAboveFold = index < 3 // 前 3 张优先加载，利于 LCP
              return (
                <Link key={venue.id} href={`/venues/${venue.id}`} className="group relative bg-white overflow-hidden" style={{ borderRadius: '4px' }}>
                  {/* 大图展示 */}
                  <div className="relative h-[400px] bg-gray-100 overflow-hidden">
                    {firstImage ? (
                      <img 
                        src={firstImage} 
                        alt={venue.name}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                        loading={isAboveFold ? 'eager' : 'lazy'}
                        decoding="async"
                        fetchPriority={isAboveFold ? 'high' : undefined}
                      />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-textMuted text-6xl">
                        {venue.sportType === 'basketball' ? '🏀' : '⚽'}
                      </div>
                    )}
                    {/* Nike 风格：白色按钮覆盖在图片左下角 */}
                    <div className="absolute bottom-6 left-6">
                      <div className="bg-white text-black px-6 py-3 text-sm font-bold uppercase tracking-wider hover:bg-gray-100 transition-colors inline-flex items-center justify-center shadow-lg" style={{ borderRadius: '4px' }}>
                        立即探索
                      </div>
                    </div>
                  </div>
                  {/* 文字信息 - 简洁风格 */}
                  <div className="p-6 bg-white">
                    <div className="font-bold text-heading mb-2 line-clamp-1">{venue.name}</div>
                    <div className="text-body-sm text-textSecondary">
                      {(venue as any).priceDisplay?.trim() || (venue.priceMin ? `¥${venue.priceMin.toFixed(0)}/小时` : '免费')} · {venue.indoor ? '室内' : '室外'}
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
      </section>

      {/* Sport Categories Section - Nike 风格 */}
      <section className="container-page py-20 bg-white">
        {/* 篮球场地分类 */}
        <div className="mb-20">
          <div className="flex items-center justify-between mb-12 flex-wrap gap-4">
            <div>
              <h2 className="text-heading font-bold tracking-tight mb-2">篮球场地</h2>
              <p className="text-body-sm text-textSecondary">精选优质篮球场地，释放你的运动激情</p>
            </div>
            <Link href="/map?sport=basketball" className="text-black font-medium hover:underline">查看全部 →</Link>
          </div>
          {/* Nike 风格：更大的卡片，更大的图片 */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {basketballVenues.length > 0 ? (
              basketballVenues.map((venue: any) => {
                const firstImage = venue.firstImage || null
                return (
                  <Link key={venue.id} href={`/venues/${venue.id}`} className="group relative bg-white overflow-hidden" style={{ borderRadius: '4px' }}>
                    <div className="relative h-[320px] bg-gray-100 overflow-hidden">
                      {firstImage ? (
                        <img 
                          src={firstImage} 
                          alt={venue.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                          loading="lazy"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-textMuted text-5xl">
                          🏀
                        </div>
                      )}
                      {/* Nike 风格：白色按钮 */}
                      <div className="absolute bottom-4 left-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                        <div className="bg-white text-black px-4 py-2 text-xs font-bold uppercase tracking-wider hover:bg-gray-100 transition-colors inline-flex items-center justify-center shadow-lg" style={{ borderRadius: '4px' }}>
                          查看详情
                        </div>
                      </div>
                    </div>
                    <div className="p-5 bg-white">
                      <div className="font-bold text-heading-sm mb-1 line-clamp-1">{venue.name}</div>
                      <div className="text-body-sm text-textSecondary">
                        {(venue as any).priceDisplay?.trim() || (venue.priceMin ? `¥${venue.priceMin.toFixed(0)}/小时` : '免费')} · {venue.indoor ? '室内' : '室外'}
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
          <div className="flex items-center justify-between mb-12 flex-wrap gap-4">
            <div>
              <h2 className="text-heading font-bold tracking-tight mb-2">足球场地</h2>
              <p className="text-body-sm text-textSecondary">专业足球场地，体验绿茵场上的速度与激情</p>
            </div>
            <Link href="/map?sport=football" className="text-black font-medium hover:underline">查看全部 →</Link>
          </div>
          {/* Nike 风格：更大的卡片，更大的图片 */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {footballVenues.length > 0 ? (
              footballVenues.map((venue: any) => {
                const firstImage = venue.firstImage || null
                return (
                  <Link key={venue.id} href={`/venues/${venue.id}`} className="group relative bg-white overflow-hidden" style={{ borderRadius: '4px' }}>
                    <div className="relative h-[320px] bg-gray-100 overflow-hidden">
                      {firstImage ? (
                        <img 
                          src={firstImage} 
                          alt={venue.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                          loading="lazy"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-textMuted text-5xl">
                          ⚽
                        </div>
                      )}
                      {/* Nike 风格：白色按钮 */}
                      <div className="absolute bottom-4 left-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                        <div className="bg-white text-black px-4 py-2 text-xs font-bold uppercase tracking-wider hover:bg-gray-100 transition-colors inline-flex items-center justify-center shadow-lg" style={{ borderRadius: '4px' }}>
                          查看详情
                        </div>
                      </div>
                    </div>
                    <div className="p-5 bg-white">
                      <div className="font-bold text-heading-sm mb-1 line-clamp-1">{venue.name}</div>
                      <div className="text-body-sm text-textSecondary">
                        {(venue as any).priceDisplay?.trim() || (venue.priceMin ? `¥${venue.priceMin.toFixed(0)}/小时` : '免费')} · {venue.indoor ? '室内' : '室外'}
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
    </main>
  )
}

