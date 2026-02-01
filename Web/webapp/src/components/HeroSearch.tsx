'use client'

import { useState } from 'react'

export default function HeroSearch() {
  const [keyword, setKeyword] = useState('')

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    if (!keyword.trim()) {
      e.preventDefault()
      window.location.href = '/map'
      return
    }
    // 有关键词时不阻止提交，让浏览器用 GET 跳转到 /map?keyword=xxx，手机端最稳定
  }

  return (
    <form action="/map" method="get" onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-2">
      <input
        name="keyword"
        type="text"
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
        className="flex-1 bg-white text-black px-4 py-3 text-body border-0 focus:outline-none focus:ring-2 focus:ring-white min-h-[44px]"
        placeholder="搜索城市、关键词…"
        style={{
          fontSize: '16px',
          paddingLeft: '1rem',
          paddingRight: '1rem',
          paddingTop: '0.75rem',
          paddingBottom: '0.75rem',
          WebkitAppearance: 'none',
        }}
        autoComplete="off"
        autoCapitalize="off"
        enterKeyHint="search"
      />
      <button
        type="submit"
        className="btn-primary whitespace-nowrap flex items-center justify-center"
        style={{
          borderRadius: '4px',
          lineHeight: '1',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          paddingTop: '8px',
          paddingBottom: '8px',
          fontSize: '0.875rem',
          paddingLeft: '1rem',
          paddingRight: '1rem',
        }}
      >
        开始探索
      </button>
    </form>
  )
}
