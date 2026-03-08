'use client'

import FavoriteButton from './FavoriteButton'

type Props = {
  venueId: string
  venueName: string
  sportType?: 'basketball' | 'football'
  contact?: string
  address?: string
  /** 高德地图导航链接 */
  navUrl?: string
}

export default function VenueDetailBottomBar({
  venueId,
  venueName,
  sportType,
  contact,
  address,
  navUrl,
}: Props) {
  const handleContact = () => {
    if (contact && /^[\d\-+]+$/.test(contact.replace(/\s/g, ''))) {
      window.location.href = `tel:${contact}`
    } else if (address && typeof navigator !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText(address).then(() => alert('地址已复制'))
    } else {
      if (address) navigator.clipboard?.writeText(address)
      alert(address ? '地址已复制' : '暂无联系方式')
    }
  }

  const handleNav = () => {
    if (navUrl) {
      window.open(navUrl, '_blank')
    } else {
      alert('暂无位置信息，无法导航')
    }
  }

  return (
    <div
      className="fixed bottom-0 left-0 right-0 z-[99998] flex items-center gap-4 bg-white border-t border-gray-200 px-4 py-3"
      style={{ paddingBottom: 'max(env(safe-area-inset-bottom, 0px), 12px)' }}
    >
      <div className="flex items-center gap-6">
        <button
          type="button"
          onClick={handleContact}
          className="flex flex-col items-center gap-0.5 text-gray-700 hover:text-black min-w-[44px]"
        >
          <span className="text-lg">📞</span>
          <span className="text-xs">联系</span>
        </button>
        <FavoriteButton
          venueId={venueId}
          name={venueName}
          sportType={sportType}
          iconWithLabel
          className="flex flex-col items-center gap-0.5 min-w-0 p-0 border-0 bg-transparent text-gray-700 hover:text-black min-h-[44px] justify-center"
        />
      </div>
      <button
        type="button"
        onClick={handleNav}
        className="flex-1 h-12 bg-black text-white text-sm font-semibold rounded-lg hover:bg-gray-800"
      >
        导航
      </button>
    </div>
  )
}
