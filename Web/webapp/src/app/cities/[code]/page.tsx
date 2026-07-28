import { Metadata } from 'next';
import Link from 'next/link';
import Image from 'next/image';
import { getCityName, getCityTag, getCityDescription } from '../cityMap';

interface Venue {
  id: string;
  name: string;
  address: string;
  sportType: string;
  indoor: boolean;
  firstImage: string;
  discoveryMethod: string;
  bookingLink: string;
  price: number;
}

interface CityPageData {
  code: string;
  name: string;
  total: number;
  basketball: number;
  football: number;
  venues: Venue[];
}

async function getCityData(code: string): Promise<CityPageData | null> {
  const baseUrl = process.env.NEXT_PUBLIC_API_URL || '';
  if (!baseUrl) return null;
  
  const fullCode = code.substring(0, 4) + '00';
  
  try {
    const res = await fetch(`${baseUrl}/api/venues?limit=2000`, {
      next: { revalidate: 3600 }
    });
    if (!res.ok) return null;
    const data = await res.json();
    const allVenues: Venue[] = (data.items || []);
    
    const cityVenues = allVenues.filter(v => 
      (v.cityCode || '').startsWith(code.substring(0, 4))
    );
    
    if (cityVenues.length === 0) return null;
    
    const cityCodePrefix = code.substring(0, 4);
    const name = getCityName(cityCodePrefix);
    const basketball = cityVenues.filter(v => v.sportType === 'basketball').length;
    const football = cityVenues.filter(v => v.sportType === 'football').length;
    
    return {
      code: cityCodePrefix + '00',
      name,
      total: cityVenues.length,
      basketball,
      football,
      venues: cityVenues,
    };
  } catch {
    return null;
  }
}

export async function generateMetadata({ params }: { params: { code: string } }): Promise<Metadata> {
  const code = params.code.substring(0, 4);
  const cityName = getCityName(code);
  
  return {
    title: `${cityName}篮球馆·足球场馆预订 | ${cityName}体育馆推荐 | FY体育`,
    description: `找${cityName}的体育场馆？FY体育提供${cityName}区体育馆、篮球馆、足球场在线查询和预订，真实场馆图片展示，快速找到身边的运动场地。`,
    openGraph: {
      title: `${cityName}体育场馆预订 | FY体育`,
      description: `${cityName}区体育馆在线查询，篮球馆、足球场真实图片展示。`,
    },
    alternates: {
      canonical: `https://findyu.cn/cities/${code}00`,
    },
  };
}

function VenueCard({ venue }: { venue: Venue }) {
  const sportLabel = venue.sportType === 'basketball' ? '篮球' : 
                     venue.sportType === 'football' ? '足球' : '综合';
  const indoorLabel = venue.indoor ? '室内' : '室外';
  
  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow">
      <div className="relative h-48 bg-gray-100">
        {venue.firstImage ? (
          <Image
            src={venue.firstImage}
            alt={`${venue.name} - ${cityName}场馆照片`}
            fill
            className="object-cover"
            sizes="(max-width: 768px) 100vw, 400px"
          />
        ) : (
          <div className="flex items-center justify-center h-full text-gray-400">
            <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} 
                d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0H5m14 0h2m-2 0v-4H5v4m0 0H3" />
            </svg>
          </div>
        )}
        <div className="absolute top-2 right-2">
          <span className="bg-blue-500 text-white text-xs px-2 py-1 rounded-full">
            {indoorLabel}
          </span>
        </div>
      </div>
      <div className="p-4">
        <h3 className="font-semibold text-gray-900 mb-1 line-clamp-1">{venue.name}</h3>
        <p className="text-sm text-gray-500 mb-2 line-clamp-1">{venue.address}</p>
        <div className="flex items-center gap-2">
          <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded">
            {sportLabel}
          </span>
          <span className="text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded">
            {indoorLabel}
          </span>
        </div>
        {venue.bookingLink && (
          <a 
            href={venue.bookingLink}
            target="_blank"
            rel="noopener noreferrer"
            className="mt-3 block w-full text-center bg-blue-500 hover:bg-blue-600 text-white text-sm py-2 rounded-lg transition-colors"
          >
            查看详情
          </a>
        )}
      </div>
    </div>
  );
}

export default async function CityDetailPage({ params }: { params: { code: string } }) {
  const city = await getCityData(params.code);
  
  if (!city) {
    return (
      <div className="min-h-screen bg-gray-50 py-12 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-2xl font-bold mb-2">城市未找到</h1>
          <p className="text-gray-600 mb-4">抱歉，该城市暂无场馆数据。</p>
          <Link href="/cities" className="text-blue-500 hover:underline">
            ← 返回全国城市列表
          </Link>
        </div>
      </div>
    );
  }
  
  const ballTypes = [];
  if (city.basketball > 0) ballTypes.push(`${city.basketball}个篮球场馆`);
  if (city.football > 0) ballTypes.push(`${city.football}个足球场馆`);
  const typeStr = ballTypes.length > 0 ? ballTypes.join('、') : '多个体育场馆';
  
  const indoorCount = city.venues.filter(v => v.indoor).length;
  const outdoorCount = city.venues.filter(v => !v.indoor).length;
  
  return (
    <div className="min-h-screen bg-gray-50 py-8 px-4">
      <div className="max-w-6xl mx-auto">
        {/* Breadcrumb */}
        <nav className="text-sm text-gray-500 mb-4">
          <Link href="/" className="hover:text-blue-500">首页</Link>
          <span className="mx-2">/</span>
          <Link href="/cities" className="hover:text-blue-500">全国城市</Link>
          <span className="mx-2">/</span>
          <span className="text-gray-900">{city.name}</span>
        </nav>
        
        {/* H1 + SEO intro */}
        <h1 className="text-3xl md:text-4xl font-bold text-gray-900 mb-3">
          {city.name}体育馆推荐 - {city.total}家场馆在线预订
        </h1>
        
        <div className="prose prose-gray max-w-none mb-8">
          <p>
            {city.name}作为{city.name}的中心城市，体育场馆资源丰富。FY体育为您收录了{city.name}区共{city.total}家体育场馆（{typeStr}），
            {indoorCount > 0 ? `其中室内场馆${indoorCount}家、` : ''}
            {outdoorCount > 0 ? `室外场馆${outdoorCount}家` : ''}。
            {city.venues.length > 0 && `代表性场馆包括${city.venues.slice(0, 3).map(v => v.name).join('、')}等。`}
          </p>
          <p>
            无论您想找{city.name}的篮球馆约球、足球场踢比赛，还是想找综合体育馆锻炼，
            FY体育都能帮您快速找到合适的场地。每家场馆都配有真实图片展示和详细地址信息。
          </p>
        </div>
        
        {/* Stats bar */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-xl p-4 text-center shadow-sm">
            <div className="text-2xl font-bold text-blue-600">{city.total}</div>
            <div className="text-sm text-gray-500">场馆总数</div>
          </div>
          {city.basketball > 0 && (
            <div className="bg-white rounded-xl p-4 text-center shadow-sm">
              <div className="text-2xl font-bold text-orange-600">{city.basketball}</div>
              <div className="text-sm text-gray-500">篮球场馆</div>
            </div>
          )}
          {city.football > 0 && (
            <div className="bg-white rounded-xl p-4 text-center shadow-sm">
              <div className="text-2xl font-bold text-green-600">{city.football}</div>
              <div className="text-sm text-gray-500">足球场馆</div>
            </div>
          )}
          <div className="bg-white rounded-xl p-4 text-center shadow-sm">
            <div className="text-2xl font-bold text-purple-600">{indoorCount}</div>
            <div className="text-sm text-gray-500">室内场馆</div>
          </div>
          <div className="bg-white rounded-xl p-4 text-center shadow-sm">
            <div className="text-2xl font-bold text-amber-600">{outdoorCount}</div>
            <div className="text-sm text-gray-500">室外场馆</div>
          </div>
        </div>
        
        {/* Venue grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {city.venues.map(venue => (
            <VenueCard key={venue.id} venue={venue} />
          ))}
        </div>
        
        {/* Bottom SEO text */}
        <div className="mt-12 prose prose-gray max-w-none border-t pt-8">
          <h2>{city.name}体育馆预订指南</h2>
          <p>
            {city.name}的体育场馆分布广泛，从市中心到各区域均有覆盖。
            篮球场馆主要集中在{city.basketball > 10 ? '高校和社区体育中心' : '各大体育馆和健身中心'}，
            足球场馆则以{city.football > 5 ? '专业足球场和体育公园为主' : '综合体育场和学校场地为主'}。
          </p>
          <p>
            在{city.name}预约体育馆，可通过FY体育在线查看场馆图片、了解场地类型（室内/室外）、
            查看详细地址。建议提前联系场馆确认开放时间和预订方式。
          </p>
          <p className="text-sm text-gray-500 mt-4">
            FY体育-{city.name}站 | 数据最后更新：{new Date().toISOString().split('T')[0]}
          </p>
        </div>
      </div>
    </div>
  );
}
