"use client"
import { useState } from 'react'

export type Filters = {
  city?: string
  sport?: 'basketball' | 'football'
  minPrice?: number
  maxPrice?: number
  indoor?: boolean
}

type Props = {
  value: Filters
  onChange: (next: Filters) => void
}

export default function FiltersBar({ value, onChange }: Props) {
  const [city, setCity] = useState(value.city || '')
  const [sport, setSport] = useState<Filters['sport']>(value.sport ?? 'basketball')
  const [minPrice, setMinPrice] = useState<string>(value.minPrice?.toString() || '')
  const [maxPrice, setMaxPrice] = useState<string>(value.maxPrice?.toString() || '')
  const [indoor, setIndoor] = useState<boolean>(!!value.indoor)

  function emit() {
    onChange({
      city: city || undefined,
      sport,
      minPrice: minPrice ? Number(minPrice) : undefined,
      maxPrice: maxPrice ? Number(maxPrice) : undefined,
      indoor: indoor || undefined,
    })
  }

  // 初次挂载时确保发出一次带默认值的筛选
  // 默认运动类型选中第一个（篮球）
  if (!value.sport && sport !== 'basketball') {
    setSport('basketball')
    onChange({ ...value, sport: 'basketball' })
  }

  return (
    <div className="flex flex-wrap gap-2 items-center mb-3">
      <input value={city} onChange={(e)=>setCity(e.target.value)} onBlur={emit} placeholder="城市代码(如110000)" className="h-10 px-3 border border-border rounded-card" />
      <select value={sport || 'basketball'} onChange={(e)=>{ setSport((e.target.value||undefined) as any); emit() }} className="h-10 px-2 border border-border rounded-card">
        <option value="basketball">篮球</option>
        <option value="football">足球</option>
      </select>
      <input value={minPrice} onChange={(e)=>setMinPrice(e.target.value)} onBlur={emit} inputMode="numeric" placeholder="最低价" className="h-10 w-24 px-3 border border-border rounded-card" />
      <input value={maxPrice} onChange={(e)=>setMaxPrice(e.target.value)} onBlur={emit} inputMode="numeric" placeholder="最高价" className="h-10 w-24 px-3 border border-border rounded-card" />
      <label className="flex items-center gap-2 text-sm">
        <input type="checkbox" checked={indoor} onChange={(e)=>{ setIndoor(e.target.checked); emit() }} /> 室内
      </label>
      <button className="h-10 px-4 rounded-card border border-border" onClick={emit}>应用</button>
    </div>
  )
}


