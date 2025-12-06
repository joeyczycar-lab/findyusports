'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function AddVenuePage() {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)
  
  const [formData, setFormData] = useState({
    name: '',
    sportType: 'basketball' as 'basketball' | 'football',
    cityCode: '110000',
    address: '',
    lng: '',
    lat: '',
    priceMin: '',
    priceMax: '',
    indoor: false,
  })

  const cityOptions = [
    { value: '110000', label: '北京' },
    { value: '120000', label: '天津' },
    { value: '310000', label: '上海' },
    { value: '500000', label: '重庆' },
    { value: '440100', label: '广州' },
    { value: '440300', label: '深圳' },
    { value: '330100', label: '杭州' },
    { value: '320100', label: '南京' },
    { value: '510100', label: '成都' },
    { value: '420100', label: '武汉' },
  ]

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setMessage(null)

    try {
      const apiBase = process.env.NEXT_PUBLIC_API_BASE || 'http://localhost:4000'

      const payload: any = {
        name: formData.name,
        sportType: formData.sportType,
        cityCode: formData.cityCode,
        lng: parseFloat(formData.lng),
        lat: parseFloat(formData.lat),
      }

      if (formData.address) payload.address = formData.address
      if (formData.priceMin) payload.priceMin = parseInt(formData.priceMin)
      if (formData.priceMax) payload.priceMax = parseInt(formData.priceMax)
      if (formData.indoor !== undefined) payload.indoor = formData.indoor

      const response = await fetch(`${apiBase}/venues`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      })

      const data = await response.json()

      if (response.ok && !data.error) {
        setMessage({ type: 'success', text: `✅ 场地 "${formData.name}" 添加成功！ID: ${data.id}` })
        // 清空表单
        setFormData({
          name: '',
          sportType: 'basketball',
          cityCode: '110000',
          address: '',
          lng: '',
          lat: '',
          priceMin: '',
          priceMax: '',
          indoor: false,
        })
      } else {
        const errorMsg = data.error?.message || data.message || '添加失败，请检查输入'
        setMessage({ type: 'error', text: `❌ ${errorMsg}` })
      }
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : '网络错误，请检查后端服务是否正常运行'
      setMessage({ type: 'error', text: `❌ ${errorMsg}` })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="container-page py-12">
      <div className="max-w-2xl mx-auto">
        <h1 className="text-display mb-8">添加场地</h1>

        {message && (
          <div
            className={`mb-6 p-4 rounded-none border ${
              message.type === 'success'
                ? 'bg-gray-100 border-gray-900 text-gray-900'
                : 'bg-red-50 border-red-500 text-red-900'
            }`}
          >
            {message.text}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="name" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              场地名称 <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              id="name"
              required
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              placeholder="例如：朝阳体育中心篮球场"
            />
          </div>

          <div>
            <label htmlFor="sportType" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              运动类型 <span className="text-red-500">*</span>
            </label>
            <select
              id="sportType"
              required
              value={formData.sportType}
              onChange={(e) => setFormData({ ...formData, sportType: e.target.value as 'basketball' | 'football' })}
              className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
            >
              <option value="basketball">篮球</option>
              <option value="football">足球</option>
            </select>
          </div>

          <div>
            <label htmlFor="cityCode" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              城市 <span className="text-red-500">*</span>
            </label>
            <select
              id="cityCode"
              required
              value={formData.cityCode}
              onChange={(e) => setFormData({ ...formData, cityCode: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
            >
              {cityOptions.map((city) => (
                <option key={city.value} value={city.value}>
                  {city.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label htmlFor="address" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              详细地址
            </label>
            <input
              type="text"
              id="address"
              value={formData.address}
              onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              placeholder="例如：北京市朝阳区朝阳路1号"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label htmlFor="lng" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
                经度 (lng) <span className="text-red-500">*</span>
              </label>
              <input
                type="number"
                id="lng"
                required
                step="any"
                value={formData.lng}
                onChange={(e) => setFormData({ ...formData, lng: e.target.value })}
                className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
                placeholder="例如：116.45"
              />
              <p className="text-caption text-gray-400 mt-1">
                <a
                  href="https://lbs.amap.com/tools/picker"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="underline hover:text-gray-900"
                >
                  获取坐标 →
                </a>
              </p>
            </div>
            <div>
              <label htmlFor="lat" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
                纬度 (lat) <span className="text-red-500">*</span>
              </label>
              <input
                type="number"
                id="lat"
                required
                step="any"
                value={formData.lat}
                onChange={(e) => setFormData({ ...formData, lat: e.target.value })}
                className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
                placeholder="例如：39.92"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label htmlFor="priceMin" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
                最低价格 (元/小时)
              </label>
              <input
                type="number"
                id="priceMin"
                min="0"
                value={formData.priceMin}
                onChange={(e) => setFormData({ ...formData, priceMin: e.target.value })}
                className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
                placeholder="例如：50"
              />
            </div>
            <div>
              <label htmlFor="priceMax" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
                最高价格 (元/小时)
              </label>
              <input
                type="number"
                id="priceMax"
                min="0"
                value={formData.priceMax}
                onChange={(e) => setFormData({ ...formData, priceMax: e.target.value })}
                className="w-full px-4 py-3 border border-gray-900 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
                placeholder="例如：100"
              />
            </div>
          </div>

          <div>
            <label className="flex items-center space-x-3 cursor-pointer">
              <input
                type="checkbox"
                checked={formData.indoor}
                onChange={(e) => setFormData({ ...formData, indoor: e.target.checked })}
                className="w-5 h-5 border-gray-900 rounded-none text-gray-900 focus:ring-2 focus:ring-gray-900"
              />
              <span className="text-body-sm font-bold uppercase tracking-wide">室内场地</span>
            </label>
          </div>

          <div className="flex space-x-4 pt-4">
            <button
              type="submit"
              disabled={loading}
              className="btn-primary flex-1 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? '添加中...' : '添加场地'}
            </button>
            <button
              type="button"
              onClick={() => router.push('/')}
              className="btn-secondary"
            >
              返回首页
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

