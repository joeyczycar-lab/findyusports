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
  const [copied, setCopied] = useState(false)
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

  // 导航链接 - 参考美团的样式
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
      setCopied(true)
      setTimeout(() => {
        setCopied(false)
        setIsOpen(false)
      }, 1500)
    } catch (err) {
      console.error('复制失败:', err)
    }
  }

  return (
    <div className={`relative inline-block ${className}`} ref={menuRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="text-left hover:text-brandBlue transition-colors cursor-pointer inline-flex items-center gap-1 group"
      >
        <span className="underline decoration-dotted decoration-gray-400 group-hover:decoration-brandBlue">
          {address || '地址未填写'}
        </span>
        <span className="text-xs text-textSecondary">▼</span>
      </button>

      {isOpen && (
        <div 
          className="absolute top-full left-0 mt-2 bg-white border border-gray-200 shadow-xl z-50 min-w-[220px]"
          style={{ borderRadius: '8px', boxShadow: '0 4px 12px rgba(0,0,0,0.15)' }}
        >
          <div className="py-2">
            <div className="px-4 py-2 text-xs text-textSecondary uppercase tracking-wide border-b border-gray-100">
              导航到此处
            </div>
            {navigationLinks.map((link, index) => (
              <a
                key={link.name}
                href={link.url}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-sm text-gray-700"
                onClick={() => setIsOpen(false)}
                style={{ 
                  borderBottom: index < navigationLinks.length - 1 ? '1px solid #f5f5f5' : 'none' 
                }}
              >
                <span className="text-lg">{link.icon}</span>
                <span className="flex-1">{link.name}</span>
                <span className="text-xs text-gray-400">→</span>
              </a>
            ))}
            <div className="border-t border-gray-100 my-1" />
            <button
              onClick={handleCopyAddress}
              className="w-full text-left flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-sm text-gray-700"
            >
              <span className="text-lg">📋</span>
              <span className="flex-1">{copied ? '已复制' : '复制地址'}</span>
              {copied && <span className="text-xs text-green-600">✓</span>}
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

