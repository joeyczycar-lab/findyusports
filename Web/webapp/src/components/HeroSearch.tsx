'use client'

import { useRouter } from 'next/navigation'

export default function HeroSearch() {
  const router = useRouter()

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    const form = e.currentTarget
    const input = form.querySelector<HTMLInputElement>('input[name="keyword"]')
    const kw = (input?.value ?? '').trim()
    if (kw) {
      router.push(`/map?keyword=${encodeURIComponent(kw)}`)
    } else {
      router.push('/map')
    }
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-2">
      <input
        name="keyword"
        type="text"
        className="flex-1 bg-white text-black px-4 py-3 text-body border-0 focus:outline-none focus:ring-2 focus:ring-white"
        placeholder="搜索城市、关键词…"
        style={{
          fontSize: '0.875rem',
          paddingLeft: '1rem',
          paddingRight: '1rem',
          paddingTop: '0.75rem',
          paddingBottom: '0.75rem',
        }}
        autoComplete="off"
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
