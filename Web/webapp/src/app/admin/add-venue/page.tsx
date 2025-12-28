'use client'

import { useState, useRef } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { fetchJson, getApiBase } from '@/lib/api'
import { getAuthState } from '@/lib/auth'
import LoginModal from '@/components/LoginModal'
import NavigationMenu from '@/components/NavigationMenu'

export default function AddVenuePage() {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)
  const [uploadingImages, setUploadingImages] = useState(false)
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [selectedImages, setSelectedImages] = useState<File[]>([])
  
  const [formData, setFormData] = useState({
    name: '',
    sportType: 'basketball' as 'basketball' | 'football',
    cityCode: '110000',
    address: '',
    lng: 0,
    lat: 0,
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
      const apiBase = getApiBase()

      // 验证地址
      if (!formData.address || formData.address.trim() === '') {
        setMessage({ type: 'error', text: '❌ 请输入详细地址' })
        setLoading(false)
        return
      }

      const payload: any = {
        name: formData.name,
        sportType: formData.sportType,
        cityCode: formData.cityCode,
        lng: formData.lng,
        lat: formData.lat,
      }

      payload.address = formData.address
      // 如果没有坐标，使用默认坐标（后续可以通过地址解析获取）
      if (!formData.lng || !formData.lat || formData.lng === 0 || formData.lat === 0) {
        // 使用北京的默认坐标作为占位符
        payload.lng = 116.397428
        payload.lat = 39.90923
      } else {
        payload.lng = formData.lng
        payload.lat = formData.lat
      }
      if (formData.priceMin) payload.priceMin = parseInt(formData.priceMin)
      if (formData.priceMax) payload.priceMax = parseInt(formData.priceMax)
      if (formData.indoor !== undefined) payload.indoor = formData.indoor

      const data = await fetchJson('/venues', {
        method: 'POST',
        body: JSON.stringify(payload),
      })

      if (!data.error) {
        const venueId = data.id
        
        // 如果有选中的图片，自动上传
        if (selectedImages.length > 0) {
          setUploadingImages(true)
          try {
            const authState = getAuthState()
            if (!authState.isAuthenticated) {
              setIsLoginModalOpen(true)
              setMessage({ type: 'success', text: `✅ 场地 "${formData.name}" 添加成功！ID: ${venueId}\n📸 请先登录后再上传图片。` })
            } else {
              // 上传所有选中的图片
              const uploadPromises = selectedImages.map(async (file) => {
                const formData = new FormData()
                formData.append('file', file)
                return fetchJson(`/venues/${venueId}/upload`, {
                  method: 'POST',
                  body: formData
                })
              })
              
              await Promise.all(uploadPromises)
              setMessage({ type: 'success', text: `✅ 场地 "${formData.name}" 添加成功！ID: ${venueId}\n📸 已成功上传 ${selectedImages.length} 张图片。\n\n点击下方按钮查看所有场地。` })
              setSelectedImages([])
            }
          } catch (error: any) {
            setMessage({ type: 'success', text: `✅ 场地 "${formData.name}" 添加成功！ID: ${venueId}\n⚠️ 图片上传失败：${error.message || '请稍后在场地详情页面上传图片。'}\n\n点击下方按钮查看所有场地。` })
          } finally {
            setUploadingImages(false)
          }
        } else {
          setMessage({ type: 'success', text: `✅ 场地 "${formData.name}" 添加成功！ID: ${venueId}\n📸 提示：您可以在场地详情页面上传场地图片。\n\n点击下方按钮查看所有场地。` })
        }
        
        // 清空表单
        setFormData({
          name: '',
          sportType: 'basketball',
          cityCode: '110000',
          address: '',
          lng: 0,
          lat: 0,
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
            className={`mb-6 p-4 border ${
              message.type === 'success'
                ? 'bg-gray-100 border-gray-900 text-gray-900'
                : 'bg-red-50 border-red-500 text-red-900'
            }`}
            style={{ borderRadius: '4px' }}
          >
            <div className="whitespace-pre-line mb-3">{message.text}</div>
            {message.type === 'success' && (
              <div className="flex gap-3 mt-4">
                <Link
                  href="/admin/venues"
                  className="bg-black text-white px-4 py-2 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors inline-block"
                  style={{ borderRadius: '4px' }}
                >
                  📋 查看所有场地
                </Link>
                <Link
                  href="/map"
                  className="bg-gray-200 text-black px-4 py-2 text-sm font-bold uppercase tracking-wider hover:bg-gray-300 transition-colors inline-block"
                  style={{ borderRadius: '4px' }}
                >
                  🗺️ 在地图上查看
                </Link>
              </div>
            )}
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
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
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
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
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
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
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
              详细地址 <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              id="address"
              required
              value={formData.address}
              onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
              placeholder="例如：北京市朝阳区朝阳路1号"
            />
            <p className="text-xs text-gray-600 mt-2">
              💡 提示：请输入场地的详细地址，系统会自动获取坐标信息
            </p>
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
                className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
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
                className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
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
                className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                style={{ borderRadius: '4px' }}
              />
              <span className="text-body-sm font-bold uppercase tracking-wide">室内场地</span>
            </label>
          </div>

          <div>
            <label className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              上传图片 <span className="text-gray-500 text-xs normal-case">(可选)</span>
            </label>
            <div className="space-y-3">
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                multiple
                onChange={(e) => {
                  const files = Array.from(e.target.files || [])
                  // 验证文件
                  const validFiles = files.filter(file => {
                    if (!file.type.startsWith('image/')) {
                      setMessage({ type: 'error', text: '❌ 请选择图片文件' })
                      return false
                    }
                    if (file.size > 10 * 1024 * 1024) {
                      setMessage({ type: 'error', text: '❌ 图片大小不能超过10MB' })
                      return false
                    }
                    return true
                  })
                  setSelectedImages(validFiles)
                  if (validFiles.length > 0) {
                    setMessage(null)
                  }
                }}
                className="hidden"
              />
              
              <button
                type="button"
                onClick={() => {
                  const authState = getAuthState()
                  if (!authState.isAuthenticated) {
                    setIsLoginModalOpen(true)
                    return
                  }
                  fileInputRef.current?.click()
                }}
                className="w-full h-14 px-4 border-2 border-gray-900 hover:bg-gray-900 hover:text-white bg-white text-black font-bold transition-colors flex items-center justify-center gap-3 text-base"
                style={{
                  borderRadius: '4px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  visibility: 'visible',
                  opacity: 1,
                  zIndex: 1
                }}
              >
                <span className="text-xl">📷</span>
                <span>{selectedImages.length > 0 ? `已选择 ${selectedImages.length} 张图片（点击可重新选择）` : '📤 点击上传图片（支持多选）'}</span>
              </button>
              
              {selectedImages.length > 0 && (
                <div className="grid grid-cols-4 gap-2">
                  {selectedImages.map((file, index) => (
                    <div key={index} className="relative group">
                      <img
                        src={URL.createObjectURL(file)}
                        alt={`预览 ${index + 1}`}
                        className="w-full h-24 object-cover border border-gray-300"
                      />
                      <button
                        type="button"
                        onClick={() => {
                          setSelectedImages(selectedImages.filter((_, i) => i !== index))
                        }}
                        className="absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        ×
                      </button>
                    </div>
                  ))}
                </div>
              )}
              
              <p className="text-xs text-gray-600">
                💡 提示：支持 JPG、PNG 格式，每张最大 10MB。添加场地成功后会自动上传。
              </p>
            </div>
          </div>

          <div className="flex space-x-4 pt-4">
            <button
              type="submit"
              disabled={loading || uploadingImages}
              className="btn-primary flex-1 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? '添加中...' : uploadingImages ? '上传图片中...' : '添加场地'}
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
      
      <LoginModal
        isOpen={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        onSuccess={() => {
          setIsLoginModalOpen(false)
          // 登录成功后，可以继续上传图片
        }}
      />
    </div>
  )
}

