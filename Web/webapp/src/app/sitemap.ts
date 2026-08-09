import { MetadataRoute } from 'next'

// 城市代码列表（需与 cityMap.ts 保持一致）
const CITY_CODES = [
  '330100', '310100', '440300', '110100', '510100', '440100', '120100',
  '420100', '500100', '320100', '610100', '410100', '210100', '210200',
  '320500', '350200', '370200', '370100', '130100', '330200', '330300',
  '350100', '360100', '430100', '440600', '441900', '530100', '330400',
  '330700', '140100', '230100', '320600', '520100', '440700', '450200',
  '450300', '130200', '130600', '440500', '340100', '340200', '350500',
  '450100', '460100', '460200', '650100', '130400', '130900', '131000',
  '150100', '150200', '220100', '320300', '320400', '320800', '330500',
  '330600', '331000', '350300', '350400', '350800', '350900', '360400',
  '360700', '360900', '361100', '371300', '410200', '441300', '510700',
  '511300', '511500', '511700', '520300', '540100', '620100', '630100',
  '640100', '130500', '130700', '130800', '131100', '320200', '320700',
  '320900', '321000', '321100', '321200', '330800', '330900', '331100',
  '340300', '340500', '340800', '341100', '341300', '360800', '370300',
  '370400', '370500', '370600', '370700', '370800', '370900', '371000',
  '371100', '371400', '371500', '371600', '371700', '410300', '410700',
  '411300', '430200', '430600', '441200', '442000', '110000',
]

interface VenueItem {
  id: string | number
  updatedAt?: string
}

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const baseUrl = 'https://findyu.cn'
  const entries: MetadataRoute.Sitemap = []

  // 1. 首页
  entries.push({
    url: baseUrl,
    lastModified: new Date(),
    changeFrequency: 'weekly',
    priority: 1,
  })

  // 2. 城市索引页
  entries.push({
    url: `${baseUrl}/cities`,
    lastModified: new Date(),
    changeFrequency: 'weekly',
    priority: 0.9,
  })

  // 2.5 FAQ 页面
  entries.push({
    url: `${baseUrl}/faq`,
    lastModified: new Date(),
    changeFrequency: 'weekly',
    priority: 0.9,
  })

  // 3. 城市详情页
  for (const code of CITY_CODES) {
    entries.push({
      url: `${baseUrl}/cities/${code}`,
      lastModified: new Date(),
      changeFrequency: 'daily',
      priority: 0.8,
    })
  }

  // 4. 场馆详情页 — 分页拉全量（每页 2000，fetch 到空页为止）
  try {
    const apiBase = process.env.NEXT_PUBLIC_API_URL
      ? `${process.env.NEXT_PUBLIC_API_URL}/api/venues`
      : `${baseUrl}/api/venues`

    let page = 1
    let hasMore = true
    let totalFetched = 0

    while (hasMore) {
      const res = await fetch(
        `${apiBase}?page=${page}&limit=2000`,
        { next: { revalidate: 3600 } }
      )

      if (!res.ok) {
        console.error(`sitemap: API page ${page} returned ${res.status}`)
        break
      }

      const data = await res.json()
      const items: VenueItem[] = data.items || []

      if (items.length === 0) {
        hasMore = false
        break
      }

      for (const venue of items) {
        const id = typeof venue === 'object' ? (venue.id ?? venue['id']) : venue
        entries.push({
          url: `${baseUrl}/venues/${id}`,
          lastModified: venue.updatedAt ? new Date(venue.updatedAt) : new Date(),
          changeFrequency: 'weekly',
          priority: 0.7,
        })
      }

      totalFetched += items.length
      hasMore = items.length === 2000
      page++
    }

    console.log(`sitemap: fetched ${totalFetched} venues across ${page - 1} page(s)`)
  } catch (error) {
    console.error('Failed to fetch venues for sitemap:', error)
  }

  return entries
}
