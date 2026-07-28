import { Metadata } from 'next';
import Link from 'next/link';
import { getCityName } from './cityMap';

interface CityGroup {
  code: string;
  count: number;
  basketball: number;
  football: number;
}

async function getCityGroups(): Promise<CityGroup[]> {
  const baseUrl = process.env.NEXT_PUBLIC_API_URL || '';
  if (!baseUrl) return [];
  
  try {
    const res = await fetch(`${baseUrl}/api/venues?limit=2000`, {
      next: { revalidate: 3600 }
    });
    if (!res.ok) return [];
    const data = await res.json();
    const venues = data.items || [];
    
    const cityMap = new Map<string, { total: number; basketball: number; football: number }>();
    
    for (const v of venues) {
      const code = (v.cityCode || 'unk').substring(0, 4);
      const entry = cityMap.get(code) || { total: 0, basketball: 0, football: 0 };
      entry.total++;
      if (v.sportType === 'basketball') entry.basketball++;
      if (v.sportType === 'football') entry.football++;
      cityMap.set(code, entry);
    }
    
    return Array.from(cityMap.entries())
      .map(([code, stats]) => ({
        code,
        count: stats.total,
        basketball: stats.basketball,
        football: stats.football,
      }))
      .filter(c => c.count >= 3) // 只显示 3+ 场馆的城市
      .sort((a, b) => b.count - a.count);
  } catch {
    return [];
  }
}

export const metadata: Metadata = {
  title: '全国体育场馆预订平台 | 篮球场·足球场在线预订 | FY体育',
  description: '覆盖全国50+城市、1000+体育场馆的预订平台。找篮球馆、足球场、室内体育馆，在线查看真实图片和地址信息，快速找到身边的运动场地。',
  openGraph: {
    title: '全国体育场馆预订 | FY体育',
    description: '覆盖全国50+城市、1000+体育场馆，在线查看和预订场馆。',
  },
};

export default async function CitiesPage() {
  const cities = await getCityGroups();
  
  if (cities.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 py-12 px-4">
        <div className="max-w-6xl mx-auto text-center">
          <h1 className="text-3xl font-bold mb-4">全国体育场馆预订</h1>
          <p className="text-gray-600">正在加载城市数据，请稍后再试...</p>
        </div>
      </div>
    );
  }
  
  const totalVenues = cities.reduce((s, c) => s + c.count, 0);
  const totalCities = cities.length;
  
  return (
    <div className="min-h-screen bg-gray-50 py-8 px-4">
      <div className="max-w-6xl mx-auto">
        {/* H1 + Intro */}
        <h1 className="text-3xl md:text-4xl font-bold text-gray-900 mb-3">
          全国体育场馆预订 - {totalCities}个城市{totalVenues}家场馆
        </h1>
        <p className="text-lg text-gray-600 mb-8">
          覆盖全国主要城市，包括篮球馆、足球场、综合体育馆。在线查看场馆真实图片和地址信息，轻松找到身边的运动场地。
        </p>
        
        {/* City grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {cities.map(city => (
            <Link
              key={city.code}
              href={`/cities/${city.code}00`}
              className="bg-white rounded-xl p-4 shadow-sm hover:shadow-md transition-shadow border border-gray-100"
            >
              <h2 className="font-semibold text-lg text-blue-600">
                {getCityName(city.code)}体育馆
              </h2>
              <p className="text-sm text-gray-500 mt-1">
                {city.count}家场馆
                {city.basketball > 0 && ` · 篮球${city.basketball}`}
                {city.football > 0 && ` · 足球${city.football}`}
              </p>
            </Link>
          ))}
        </div>
        
        {/* SEO 正文 */}
        <div className="mt-12 prose prose-gray max-w-none">
          <h2>各城市篮球馆、足球场馆在线预订</h2>
          <p>
            FY体育聚合了全国{totalCities}个城市共{totalVenues}家体育场馆信息，
            覆盖篮球馆、足球场、室内体育馆、综合体育中心等多种场地类型。
            无论你在哪个城市，都能快速找到附近的运动场地，查看真实图片和详细地址。
          </p>
          <p>
            热门城市如杭州（247家）、上海（139家）、深圳（62家）场馆资源丰富，
            北京、成都、广州、武汉、重庆等城市也有大量场馆收录。
            每个场馆都有详细的地址、运动类型和图片展示，方便您对比选择。
          </p>
        </div>
      </div>
    </div>
  );
}
