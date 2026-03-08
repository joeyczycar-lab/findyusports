'use client'

import Link from 'next/link'
import FavoriteButton from './FavoriteButton'

type Props = {
  venueName: string
  venueId: string
  sportType?: 'basketball' | 'football'
}

export default function VenueDetailTopBar({ venueName, venueId, sportType }: Props) {
  return (
    <header
      className="fixed top-0 left-0 right-0 z-[99998] flex items-center justify-between h-12 px-4 bg-white border-b border-gray-200"
      style={{ paddingTop: 'env(safe-area-inset-top, 0)' }}
    >
      <Link
        href="/map"
        className="flex items-center justify-center w-10 h-10 -ml-2 text-black"
        aria-label="返回地图"
      >
        ←
      </Link>
      <h1 className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 text-base font-semibold text-black truncate max-w-[50%]">
        {venueName || '场地详情'}
      </h1>
      <div className="flex items-center justify-end w-10">
        <FavoriteButton
          venueId={venueId}
          name={venueName}
          sportType={sportType}
          iconOnly
          className="min-w-0 w-10 h-10 p-0 flex items-center justify-center border-0 bg-transparent text-black hover:bg-gray-100 rounded-full text-lg"
        />
      </div>
    </header>
  )
}
