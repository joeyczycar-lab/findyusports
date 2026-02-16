"use client"
import { useState, useEffect } from 'react'

export type Filters = {
  city?: string
  sport?: 'basketball' | 'football'
  /** 次级区域（区/县）代码 */
  districtCode?: string
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

// 按城市代码列出的次级区域（区/县），代码与 venue.districtCode 一致
const DISTRICTS_BY_CITY: Record<string, Array<{ value: string; label: string }>> = {
  '310000': [ // 上海
    { value: '', label: '全部区域' },
    { value: '310101', label: '黄浦区' },
    { value: '310104', label: '徐汇区' },
    { value: '310105', label: '长宁区' },
    { value: '310106', label: '静安区' },
    { value: '310107', label: '普陀区' },
    { value: '310109', label: '虹口区' },
    { value: '310110', label: '杨浦区' },
    { value: '310112', label: '闵行区' },
    { value: '310113', label: '宝山区' },
    { value: '310114', label: '嘉定区' },
    { value: '310115', label: '浦东新区' },
    { value: '310116', label: '金山区' },
    { value: '310117', label: '松江区' },
    { value: '310118', label: '青浦区' },
    { value: '310120', label: '奉贤区' },
    { value: '310151', label: '崇明区' },
  ],
  '110000': [ // 北京
    { value: '', label: '全部区域' },
    { value: '110101', label: '东城区' },
    { value: '110102', label: '西城区' },
    { value: '110105', label: '朝阳区' },
    { value: '110106', label: '丰台区' },
    { value: '110107', label: '石景山区' },
    { value: '110108', label: '海淀区' },
    { value: '110109', label: '门头沟区' },
    { value: '110111', label: '房山区' },
    { value: '110112', label: '通州区' },
    { value: '110113', label: '顺义区' },
    { value: '110114', label: '昌平区' },
    { value: '110115', label: '大兴区' },
    { value: '110116', label: '怀柔区' },
    { value: '110117', label: '平谷区' },
    { value: '110118', label: '密云区' },
    { value: '110119', label: '延庆区' },
  ],
  '440100': [ // 广州
    { value: '', label: '全部区域' },
    { value: '440103', label: '荔湾区' },
    { value: '440104', label: '越秀区' },
    { value: '440105', label: '海珠区' },
    { value: '440106', label: '天河区' },
    { value: '440111', label: '白云区' },
    { value: '440112', label: '黄埔区' },
    { value: '440113', label: '番禺区' },
    { value: '440114', label: '花都区' },
    { value: '440115', label: '南沙区' },
    { value: '440117', label: '从化区' },
    { value: '440118', label: '增城区' },
  ],
  '440300': [ // 深圳
    { value: '', label: '全部区域' },
    { value: '440303', label: '罗湖区' },
    { value: '440304', label: '福田区' },
    { value: '440305', label: '南山区' },
    { value: '440306', label: '宝安区' },
    { value: '440307', label: '龙岗区' },
    { value: '440308', label: '盐田区' },
    { value: '440309', label: '龙华区' },
    { value: '440310', label: '坪山区' },
    { value: '440311', label: '光明区' },
  ],
  '330100': [ // 杭州
    { value: '', label: '全部区域' },
    { value: '330102', label: '上城区' },
    { value: '330103', label: '拱墅区' },
    { value: '330104', label: '西湖区' },
    { value: '330105', label: '滨江区' },
    { value: '330106', label: '萧山区' },
    { value: '330108', label: '余杭区' },
    { value: '330109', label: '临安区' },
    { value: '330110', label: '临平区' },
    { value: '330111', label: '富阳区' },
  ],
}

export default function FiltersBar({ value, onChange }: Props) {
  const [city, setCity] = useState(value.city || '')
  const [districtCode, setDistrictCode] = useState(value.districtCode || '')
  const [priceType, setPriceType] = useState<Filters['priceType']>(value.priceType ?? 'all')
  const [indoor, setIndoor] = useState<boolean>(!!value.indoor)

  const districtOptions = (city && DISTRICTS_BY_CITY[city]) ? DISTRICTS_BY_CITY[city] : [{ value: '', label: '先选城市' }]

  useEffect(() => {
    setCity(value.city || '')
    setDistrictCode(value.districtCode || '')
    setPriceType(value.priceType ?? 'all')
    setIndoor(!!value.indoor)
  }, [value.city, value.districtCode, value.priceType, value.indoor])

  useEffect(() => {
    if (districtCode && (!city || !DISTRICTS_BY_CITY[city]?.some(d => d.value === districtCode))) {
      setDistrictCode('')
    }
  }, [city, districtCode])

  function emit() {
    onChange({
      city: city || undefined,
      sport: value.sport,
      districtCode: districtCode || undefined,
      priceType: priceType === 'all' ? undefined : priceType,
      indoor: indoor || undefined,
    })
  }

  return (
    <div className="flex flex-wrap gap-3 items-center mb-6">
      <select
        value={city}
        onChange={(e) => {
          const newCity = e.target.value || undefined
          setCity(e.target.value)
          setDistrictCode('')
          onChange({
            ...value,
            city: newCity,
            districtCode: undefined,
          })
        }}
        className="h-12 px-4 border border-border bg-white text-body focus:outline-none focus:ring-2 focus:ring-black"
      >
        {CITIES.map(c => (
          <option key={c.value} value={c.value}>{c.label}</option>
        ))}
      </select>
      <select
        value={districtCode}
        onChange={(e) => {
          const v = e.target.value || undefined
          setDistrictCode(e.target.value)
          onChange({ ...value, districtCode: v })
        }}
        className="h-12 px-4 border border-border bg-white text-body focus:outline-none focus:ring-2 focus:ring-black"
        title="次级区域筛选"
      >
        {districtOptions.map(d => (
          <option key={d.value || 'all'} value={d.value}>{d.label}</option>
        ))}
      </select>
      <select
        value={priceType || 'all'}
        onChange={(e) => { setPriceType((e.target.value as Filters['priceType']) || 'all'); emit() }}
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
          onChange={(e) => { setIndoor(e.target.checked); emit() }}
          className="accent-black"
        />
        室内
      </label>
      <button className="btn-secondary h-12 px-6" onClick={emit} style={{ borderRadius: '4px' }}>应用</button>
    </div>
  )
}
