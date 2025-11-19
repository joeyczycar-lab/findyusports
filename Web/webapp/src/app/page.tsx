import Link from 'next/link'
import { fetchJson } from '@/lib/api'

async function getFeaturedVenues() {
  try {
    const data = await fetchJson('/venues?limit=6')
    return data?.items || []
  } catch (error) {
    console.error('Failed to fetch venues:', error)
    return []
  }
}

export default async function HomePage() {
  const venues = await getFeaturedVenues()

  return (
    <main>
      <section className="relative bg-[url('https://images.unsplash.com/photo-1544917841-9fdd63f3dcf9?q=80&w=2070&auto=format&fit=crop')] bg-cover bg-center">
        <div className="backdrop-brightness-75">
          <div className="container-page py-24 sm:py-32">
            <h1 className="text-white text-3xl sm:text-5xl font-bold mb-6">发现与分享 · 篮球与足球好场地</h1>
            <div className="bg-white rounded-modal shadow-md p-3 sm:p-4 flex flex-col sm:flex-row gap-3">
              <input className="flex-1 border border-border rounded-card px-3 h-10" placeholder="搜索城市、关键词…" />
              <div className="flex gap-2">
                <Link href="/map?sport=basketball" className="h-10 px-4 rounded-card border border-border flex items-center justify-center">篮球</Link>
                <Link href="/map?sport=football" className="h-10 px-4 rounded-card border border-border flex items-center justify-center">足球</Link>
                <Link href="/map" className="h-10 px-4 rounded-card bg-primary text-white flex items-center justify-center">搜索</Link>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="container-page py-10">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-semibold">精选场地</h2>
          <Link href="/map" className="text-sm text-primary hover:underline">查看全部 →</Link>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {venues.length > 0 ? (
            venues.map((venue: any) => (
              <Link key={venue.id} href={`/venues/${venue.id}`} className="bg-white rounded-card shadow-sm overflow-hidden border border-border hover:shadow-md transition-shadow">
                <div className="h-40 bg-gray-100" />
                <div className="p-4">
                  <div className="font-semibold mb-1">{venue.name}</div>
                  <div className="text-sm text-textSecondary">
                    评分 {venue.rating?.toFixed(1) || '暂无'} · {venue.priceMin ? `¥${venue.priceMin}` : '免费'} · {venue.indoor ? '室内' : '室外'}
                  </div>
                </div>
              </Link>
            ))
          ) : (
            <div className="col-span-full text-center text-textSecondary py-8">暂无场地数据</div>
          )}
        </div>
      </section>
    </main>
  )
}


