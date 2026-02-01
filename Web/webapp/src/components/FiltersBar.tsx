"use client"
import { useState } from 'react'

export type Filters = {
  city?: string
  sport?: 'basketball' | 'football'
  /** 价格类型：全部 / 免费 / 收费 */
  priceType?: 'all' | 'free' | 'paid'
  indoor?: boolean
}

type Props = {
  value: Filters
  onChange: (next: Filters) => void
}

// 城市列表
const CITIES = [
  { value: '', label: '全部城市' },
  { value: '110000', label: '北京' },
  { value: '310000', label: '上海' },
  { value: '440100', label: '广州' },
  { value: '440300', label: '深圳' },
  { value: '320100', label: '南京' },
  { value: '330100', label: '杭州' },
  { value: '510100', label: '成都' },
  { value: '420100', label: '武汉' },
  { value: '610100', label: '西安' },
  { value: '500000', label: '重庆' },
  { value: '120000', label: '天津' },
  { value: '370100', label: '济南' },
  { value: '350100', label: '福州' },
  { value: '360100', label: '南昌' },
  { value: '450100', label: '南宁' },
  { value: '530100', label: '昆明' },
  { value: '520100', label: '贵阳' },
  { value: '430100', label: '长沙' },
  { value: '410100', label: '郑州' },
]

export default function FiltersBar({ value, onChange }: Props) {
  const [city, setCity] = useState(value.city || '')
  const [sport, setSport] = useState<Filters['sport']>(value.sport ?? 'basketball')
  const [priceType, setPriceType] = useState<Filters['priceType']>(value.priceType ?? 'all')
  const [indoor, setIndoor] = useState<boolean>(!!value.indoor)

  function emit() {
    onChange({
      city: city || undefined,
      sport,
      priceType: priceType === 'all' ? undefined : priceType,
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
    <div className="flex flex-wrap gap-3 items-center mb-6">
      <select 
        value={city} 
        onChange={(e) => { setCity(e.target.value); emit() }} 
        className="h-12 px-4 border border-border bg-white text-body focus:outline-none focus:ring-2 focus:ring-black"
      >
        {CITIES.map(c => (
          <option key={c.value} value={c.value}>{c.label}</option>
        ))}
      </select>
      <select 
        value={sport || 'basketball'} 
        onChange={(e)=>{ setSport((e.target.value||undefined) as any); emit() }} 
        className="h-12 px-4 border border-border bg-white text-body focus:outline-none focus:ring-2 focus:ring-black"
      >
        <option value="basketball">篮球</option>
        <option value="football">足球</option>
      </select>
      <select 
        value={priceType || 'all'} 
        onChange={(e)=>{ setPriceType((e.target.value as Filters['priceType']) || 'all'); emit() }} 
        className="h-12 px-4 border border-border bg-white text-body focus:outline-none focus:ring-2 focus:ring-black"
      >
        <option value="all">全部</option>
        <option value="free">免费</option>
        <option value="paid">收费</option>
      </select>
      <label className="flex items-center gap-2 text-body-sm uppercase tracking-wide">
        <input 
          type="checkbox" 
          checked={indoor} 
          onChange={(e)=>{ setIndoor(e.target.checked); emit() }} 
          className="accent-black"
        /> 
        室内
      </label>
      <button className="btn-secondary h-12 px-6" onClick={emit} style={{ borderRadius: '4px' }}>应用</button>
    </div>
  )
}


