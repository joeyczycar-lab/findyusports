'use client'

import { useEffect, useState } from 'react'
import { useIsMobile } from '@/hooks/useIsMobile'

const STORAGE_KEY = 'findyu_onboarding_seen_v1'

const SLIDES = [
  {
    image: '/onboarding-1.png',
    title: '不辜负每一片热爱',
    subtitle: '哪里都有你的主场。',
  },
  {
    image: '/onboarding-2.png',
    title: '不辜负每一片热爱',
    subtitle: '用地图找到好场地，记录每一次挥汗。',
  },
  {
    image: '/onboarding-3.png',
    title: 'LIVE · Don\'t just exist',
    subtitle: '不只是在场上存在，而是真正享受比赛。',
  },
]

export default function MobileOnboarding() {
  const isMobile = useIsMobile()
  const [visible, setVisible] = useState(false)
  const [index, setIndex] = useState(0)

  // 首次进入才显示一次
  useEffect(() => {
    if (!isMobile) return
    if (typeof window === 'undefined') return
    const seen = window.localStorage.getItem(STORAGE_KEY)
    if (!seen) {
      setVisible(true)
    }
  }, [isMobile])

  // 自动轮播
  useEffect(() => {
    if (!visible) return
    const timer = setInterval(() => {
      setIndex((prev) => (prev + 1) % SLIDES.length)
    }, 4000)
    return () => clearInterval(timer)
  }, [visible])

  const handleClose = () => {
    if (typeof window !== 'undefined') {
      window.localStorage.setItem(STORAGE_KEY, '1')
    }
    setVisible(false)
  }

  if (!visible) return null

  const slide = SLIDES[index]

  return (
    <div
      className="fixed inset-0 z-[100000] flex flex-col bg-black text-white"
      style={{ touchAction: 'none' }}
    >
      {/* 背景图 */}
      <div className="absolute inset-0">
        <img
          src={slide.image}
          alt={slide.title}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black via-black/40 to-transparent" />
      </div>

      {/* 底部文案 + 按钮 */}
      <div className="relative mt-auto px-6 pb-10 pt-8 space-y-4">
        <p className="text-sm opacity-80">FY体育</p>
        <h1 className="text-2xl font-bold leading-snug">{slide.title}</h1>
        <p className="text-sm opacity-80">{slide.subtitle}</p>

        <div className="mt-5 flex flex-col gap-3">
          <button
            type="button"
            onClick={handleClose}
            className="w-full py-3 rounded-full bg-white text-black text-sm font-semibold"
          >
            立即进入 FY体育
          </button>
          <button
            type="button"
            onClick={handleClose}
            className="w-full py-3 rounded-full border border-white/70 text-sm font-semibold bg-black/40"
          >
            以访客身份继续
          </button>
        </div>

        <p className="text-center text-sm text-white/90 mt-4">
          已经是 FY体育 会员？{' '}
          <button
            type="button"
            onClick={() => {
              handleClose()
              if (typeof window !== 'undefined') {
                window.dispatchEvent(new CustomEvent('findyu-open-login'))
              }
            }}
            className="underline font-medium"
          >
            登录
          </button>
        </p>

        {/* 指示点 */}
        <div className="mt-5 flex justify-center gap-2">
          {SLIDES.map((_, i) => (
            <span
              key={i}
              className="h-1.5 rounded-full"
              style={{
                width: i === index ? 18 : 6,
                backgroundColor: i === index ? '#ffffff' : 'rgba(249,250,251,0.5)',
                transition: 'all 0.2s ease-out',
              }}
            />
          ))}
        </div>
      </div>
    </div>
  )
}

