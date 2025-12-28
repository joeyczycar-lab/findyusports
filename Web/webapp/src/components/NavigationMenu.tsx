"use client"

import { useState, useRef, useEffect } from 'react'

type Props = {
  address: string
  location: [number, number]
  name: string
  className?: string
}

export default function NavigationMenu({ address, location, name, className = '' }: Props) {
  const [isOpen, setIsOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  // 点击外部关闭菜单
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [isOpen])

  const [lng, lat] = location

  // 导航链接
  const navigationLinks = [
    {
      name: '高德地图',
      icon: '🗺️',
      url: `https://uri.amap.com/marker?position=${lng},${lat}&name=${encodeURIComponent(name)}`,
    },
    {
      name: '百度地图',
      icon: '📍',
      url: `https://api.map.baidu.com/marker?location=${lat},${lng}&title=${encodeURIComponent(name)}&content=${encodeURIComponent(address)}&output=html`,
    },
    {
      name: '腾讯地图',
      icon: '🗺️',
      url: `https://apis.map.qq.com/uri/v1/marker?marker=coord:${lat},${lng};title:${encodeURIComponent(name)};addr:${encodeURIComponent(address)}`,
    },
  ]

  // 复制地址
  const handleCopyAddress = async () => {
    try {
      await navigator.clipboard.writeText(address)
      setIsOpen(false)
      // 可以添加一个提示，比如 toast
      alert('地址已复制到剪贴板')
    } catch (err) {
      console.error('复制失败:', err)
    }
  }

  return (
    <div className={`relative ${className}`} ref={menuRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="text-left hover:text-brandBlue transition-colors cursor-pointer underline decoration-dotted"
      >
        {address || '地址未填写'}
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 mt-2 bg-white border border-border shadow-lg rounded z-50 min-w-[200px]" style={{ borderRadius: '4px' }}>
          <div className="p-2">
            <div className="text-xs text-textSecondary uppercase tracking-wide mb-2 px-2 py-1">
              导航到此处
            </div>
            {navigationLinks.map((link) => (
              <a
                key={link.name}
                href={link.url}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-2 px-3 py-2 hover:bg-gray-50 transition-colors text-sm"
                onClick={() => setIsOpen(false)}
              >
                <span>{link.icon}</span>
                <span>{link.name}</span>
              </a>
            ))}
            <div className="border-t border-border my-1" />
            <button
              onClick={handleCopyAddress}
              className="w-full text-left flex items-center gap-2 px-3 py-2 hover:bg-gray-50 transition-colors text-sm"
            >
              <span>📋</span>
              <span>复制地址</span>
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

