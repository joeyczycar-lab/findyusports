'use client'

import Link from 'next/link'
import { useState } from 'react'
import { ChevronRight, Filter } from 'lucide-react'
import TicketBannerMobile from '@/components/TicketBannerMobile'

type Venue = {
  id: string
  name: string
  firstImage?: string | null
  sportType?: string
  indoor?: boolean
  priceMin?: number
  priceDisplay?: string
}

const CATEGORIES = [
  { id: 'football', label: '足球场地' },
  { id: 'basketball', label: '篮球场地' },
] as const

type CategoryId = (typeof CATEGORIES)[number]['id']

export default function MobileHome({
  venues,
  basketballVenues,
  footballVenues,
}: {
  venues: Venue[]
  basketballVenues: Venue[]
  footballVenues: Venue[]
}) {
  const [category, setCategory] = useState<CategoryId>('football')

  const list =
    category === 'basketball'
      ? basketballVenues
      : footballVenues

  return (
    <div className="bg-white min-h-full pb-6">
      {/* 分类栏 - Nike 风格，选中下划线 */}
      <div className="sticky top-[64px] z-[9998] bg-white border-b border-gray-200">
        <div className="flex gap-8 px-4 py-3">
          {CATEGORIES.map(({ id, label }) => (
            <button
              key={id}
              type="button"
              onClick={() => setCategory(id)}
              className="relative pb-1 text-sm font-medium transition-colors"
              style={{
                color: category === id ? '#000' : '#6b7280',
              }}
            >
              {label}
              {category === id && (
                <span
                  className="absolute bottom-0 left-0 right-0 h-0.5 bg-black"
                  aria-hidden
                />
              )}
            </button>
          ))}
        </div>
      </div>

      {/* 精选场地 - 大标题 + 横向滚动卡片 */}
      <section className="px-4 pt-6 pb-8">
        <h2 className="text-xl font-bold text-black mb-4 tracking-tight">
          精选场地
        </h2>
        <div className="flex gap-4 overflow-x-auto pb-2 -mx-4 px-4 scrollbar-hide">
          {list.length > 0 ? (
            list.slice(0, 8).map((venue) => (
              <Link
                key={venue.id}
                href={`/venues/${venue.id}`}
                className="shrink-0 w-[280px] rounded-lg overflow-hidden bg-gray-100 block"
              >
                <div className="relative h-[180px] bg-gray-200">
                  {venue.firstImage ? (
                    <img
                      src={venue.firstImage}
                      alt={venue.name}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-4xl">
                      {venue.sportType === 'basketball' ? '⚽' : '⚽'}
                    </div>
                  )}
                  <div
                    className="absolute inset-0 flex items-end p-3"
                    style={{
                      background:
                        'linear-gradient(to top, rgba(0,0,0,0.5) 0%, transparent 50%)',
                    }}
                  >
                    <span className="text-white font-bold text-sm drop-shadow">
                      {venue.name}
                    </span>
                  </div>
                </div>
                <div className="p-3 bg-white">
                  <p className="text-xs text-gray-500 truncate">
                    {(venue as Venue).priceDisplay?.trim() ||
                      (venue.priceMin
                        ? `¥${venue.priceMin.toFixed(0)}/小时`
                        : '免费')}{' '}
                    · {venue.indoor ? '室内' : '室外'}
                  </p>
                </div>
              </Link>
            ))
          ) : (
            <div className="shrink-0 w-full py-8 text-center text-gray-500 text-sm">
              暂无场地
            </div>
          )}
        </div>
      </section>

      {/* 中部广告位：移动端专用版本（背景稍窄 + 文案 + 二维码） */}
      <section className="pb-6">
        <TicketBannerMobile />
      </section>

      {/* 场地征集计划 - 放在二维码广告下方 */}
      <section className="px-4 pb-6">
        <div
          className="rounded-xl border border-gray-200 p-4"
          style={{ background: 'linear-gradient(180deg, #fafafa 0%, #ffffff 100%)' }}
        >
          <p className="text-[11px] font-semibold tracking-wide text-gray-500 mb-1">
            VENUE RECRUITMENT
          </p>
          <h3 className="text-lg font-bold text-black mb-2 tracking-tight">场地征集计划</h3>
          <p className="text-sm text-gray-600 leading-6 mb-4">
            征集优质足球、篮球场地，审核通过即可在平台展示，获得更多曝光与预约机会。
          </p>
          <Link
            href="/admin/add-venue"
            className="inline-flex items-center justify-center w-full h-10 rounded-md bg-black text-white text-sm font-semibold"
          >
            立即参加
          </Link>
        </div>
      </section>

      {/* 发现更多 - 深色卡片横向滚动（Nike 达人任务风格） */}
      <section className="px-4 pt-4 pb-8">
        <h2 className="text-xl font-bold text-black mb-2 tracking-tight">
          发现更多
        </h2>
        <p className="text-sm text-gray-500 mb-4">运动场地与活动</p>
        <div className="flex gap-4 overflow-x-auto pb-2 -mx-4 px-4 scrollbar-hide">
          <Link
            href="/map?sport=basketball"
            className="shrink-0 w-[160px] h-[120px] rounded-xl flex flex-col items-center justify-center gap-2 text-white font-bold text-sm"
            style={{ background: '#111' }}
          >
            <div className="flex items-center gap-2">
              <span>篮球场地</span>
              <button
                type="button"
                className="ml-1 h-6 w-6 rounded-full bg-white/10 flex items-center justify-center"
                aria-label="筛选篮球场地"
              >
                <Filter className="h-3 w-3" />
              </button>
            </div>
          </Link>
          <Link
            href="/map?sport=football"
            className="shrink-0 w-[160px] h-[120px] rounded-xl flex flex-col items-center justify-center gap-2 text-white font-bold text-sm"
            style={{ background: '#111' }}
          >
            <span>足球场地</span>
            <ChevronRight className="h-4 w-4 opacity-80" />
          </Link>
          <Link
            href="/map"
            className="shrink-0 w-[160px] h-[120px] rounded-xl flex flex-col items-center justify-center gap-2 text-white font-bold text-sm"
            style={{ background: '#1f2937' }}
          >
            <span>全部探索</span>
            <ChevronRight className="h-4 w-4 opacity-80" />
          </Link>
        </div>
      </section>
    </div>
  )
}
