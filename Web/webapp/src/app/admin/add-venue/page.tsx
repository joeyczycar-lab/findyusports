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
  const [previewIndex, setPreviewIndex] = useState<number | null>(null)
  
  const [formData, setFormData] = useState({
    name: '',
    sportType: 'basketball' as 'basketball' | 'football',
    cityCode: '110000',
    districtCode: '',
    address: '',
    lng: 0,
    lat: 0,
    priceMin: '',
    priceMax: '',
    isFree: false, // 是否免费
    venueTypes: [] as string[], // 改为数组，支持多选：'indoor' 和 'outdoor'
    contact: '',
    isPublic: true,
    courtCount: '',
    floorType: [] as string[],
    openHours: '',
    hasLighting: false,
    hasAirConditioning: false,
    hasParking: false,
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

  // 区级数据（根据城市代码）
  const districtOptions: Record<string, Array<{ value: string; label: string }>> = {
    '110000': [ // 北京
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
    '310000': [ // 上海
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
    '440100': [ // 广州
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
      { value: '330102', label: '上城区' },
      { value: '330105', label: '拱墅区' },
      { value: '330106', label: '西湖区' },
      { value: '330108', label: '滨江区' },
      { value: '330109', label: '萧山区' },
      { value: '330110', label: '余杭区' },
      { value: '330111', label: '富阳区' },
      { value: '330112', label: '临安区' },
      { value: '330113', label: '临平区' },
      { value: '330114', label: '钱塘区' },
    ],
    '320100': [ // 南京
      { value: '320102', label: '玄武区' },
      { value: '320104', label: '秦淮区' },
      { value: '320105', label: '建邺区' },
      { value: '320106', label: '鼓楼区' },
      { value: '320111', label: '浦口区' },
      { value: '320113', label: '栖霞区' },
      { value: '320114', label: '雨花台区' },
      { value: '320115', label: '江宁区' },
      { value: '320116', label: '六合区' },
      { value: '320117', label: '溧水区' },
      { value: '320118', label: '高淳区' },
    ],
    '510100': [ // 成都
      { value: '510104', label: '锦江区' },
      { value: '510105', label: '青羊区' },
      { value: '510106', label: '金牛区' },
      { value: '510107', label: '武侯区' },
      { value: '510108', label: '成华区' },
      { value: '510112', label: '龙泉驿区' },
      { value: '510113', label: '青白江区' },
      { value: '510114', label: '新都区' },
      { value: '510115', label: '温江区' },
      { value: '510116', label: '双流区' },
      { value: '510117', label: '郫都区' },
      { value: '510118', label: '新津区' },
    ],
    '420100': [ // 武汉
      { value: '420102', label: '江岸区' },
      { value: '420103', label: '江汉区' },
      { value: '420104', label: '硚口区' },
      { value: '420105', label: '汉阳区' },
      { value: '420106', label: '武昌区' },
      { value: '420107', label: '青山区' },
      { value: '420111', label: '洪山区' },
      { value: '420112', label: '东西湖区' },
      { value: '420113', label: '汉南区' },
      { value: '420114', label: '蔡甸区' },
      { value: '420115', label: '江夏区' },
      { value: '420116', label: '黄陂区' },
      { value: '420117', label: '新洲区' },
    ],
    '120000': [ // 天津
      { value: '120101', label: '和平区' },
      { value: '120102', label: '河东区' },
      { value: '120103', label: '河西区' },
      { value: '120104', label: '南开区' },
      { value: '120105', label: '河北区' },
      { value: '120106', label: '红桥区' },
      { value: '120110', label: '东丽区' },
      { value: '120111', label: '西青区' },
      { value: '120112', label: '津南区' },
      { value: '120113', label: '北辰区' },
      { value: '120114', label: '武清区' },
      { value: '120115', label: '宝坻区' },
      { value: '120116', label: '滨海新区' },
      { value: '120117', label: '宁河区' },
      { value: '120118', label: '静海区' },
      { value: '120119', label: '蓟州区' },
    ],
    '500000': [ // 重庆
      { value: '500101', label: '万州区' },
      { value: '500102', label: '涪陵区' },
      { value: '500103', label: '渝中区' },
      { value: '500104', label: '大渡口区' },
      { value: '500105', label: '江北区' },
      { value: '500106', label: '沙坪坝区' },
      { value: '500107', label: '九龙坡区' },
      { value: '500108', label: '南岸区' },
      { value: '500109', label: '北碚区' },
      { value: '500110', label: '綦江区' },
      { value: '500111', label: '大足区' },
      { value: '500112', label: '渝北区' },
      { value: '500113', label: '巴南区' },
      { value: '500114', label: '黔江区' },
      { value: '500115', label: '长寿区' },
      { value: '500116', label: '江津区' },
      { value: '500117', label: '合川区' },
      { value: '500118', label: '永川区' },
      { value: '500119', label: '南川区' },
      { value: '500120', label: '璧山区' },
      { value: '500151', label: '铜梁区' },
      { value: '500152', label: '潼南区' },
      { value: '500153', label: '荣昌区' },
      { value: '500154', label: '开州区' },
      { value: '500155', label: '梁平区' },
      { value: '500156', label: '武隆区' },
    ],
  }

  // 获取当前城市对应的区级选项
  const currentDistricts = districtOptions[formData.cityCode] || []

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setMessage(null)

    try {
      // 验证地址
      if (!formData.address || formData.address.trim() === '') {
        setMessage({ type: 'error', text: '❌ 请输入详细地址' })
        setLoading(false)
        return
      }

      // 使用默认坐标（后续可以通过地址解析获取）
      // 注意：后端API要求必须有 lng 和 lat，所以使用默认值
      const defaultLng = 116.397428  // 北京天安门默认坐标
      const defaultLat = 39.90923

      const payload: any = {
        name: formData.name,
        sportType: formData.sportType,
        cityCode: formData.cityCode,
        districtCode: formData.districtCode || undefined,
        address: formData.address,
        lng: defaultLng,
        lat: defaultLat,
      }
      // 处理价格：如果选择免费，发送0；否则发送用户输入的价格
      if (formData.isFree) {
        payload.priceMin = 0
        payload.priceMax = 0
      } else {
        if (formData.priceMin) payload.priceMin = parseInt(formData.priceMin)
        if (formData.priceMax) payload.priceMax = parseInt(formData.priceMax)
      }
      // 处理场地类型：
      // - 如果只选了室内，发送 indoor: true
      // - 如果只选了室外，发送 indoor: false
      // - 如果两个都选了，发送 indoor: null（表示既有室内也有室外）
      // - 如果都没选，不发送 indoor 字段（让后端使用默认值）
      if (formData.venueTypes.length === 1) {
        if (formData.venueTypes.includes('indoor')) {
          payload.indoor = true
        } else if (formData.venueTypes.includes('outdoor')) {
          payload.indoor = false
        }
      } else if (formData.venueTypes.length === 2) {
        // 两个都选了，发送 null 表示既有室内也有室外
        payload.indoor = null
      }
      if (formData.contact) payload.contact = formData.contact
      if (formData.isPublic !== undefined) payload.isPublic = formData.isPublic
      if (formData.courtCount) payload.courtCount = parseInt(formData.courtCount)
      if (formData.floorType && formData.floorType.length > 0) payload.floorType = formData.floorType.join('、')
      if (formData.openHours) payload.openHours = formData.openHours
      if (formData.hasLighting !== undefined) payload.hasLighting = formData.hasLighting
      if (formData.hasAirConditioning !== undefined) payload.hasAirConditioning = formData.hasAirConditioning
      if (formData.hasParking !== undefined) payload.hasParking = formData.hasParking

      const data = await fetchJson('/venues', {
        method: 'POST',
        body: JSON.stringify(payload),
      })

      if (data.error) {
        const errorMsg = data.error.message || data.error.code || '添加失败，请检查输入'
        setMessage({ type: 'error', text: `❌ ${errorMsg}` })
        setLoading(false)
        return
      }
      
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
        districtCode: '',
        address: '',
        lng: 0,
        lat: 0,
        priceMin: '',
        priceMax: '',
        isFree: false,
        venueTypes: [],
        contact: '',
        isPublic: true,
        courtCount: '',
        floorType: [],
        openHours: '',
        hasLighting: false,
        hasAirConditioning: false,
        hasParking: false,
      })
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
              onChange={(e) => setFormData({ ...formData, cityCode: e.target.value, districtCode: '' })}
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

          {currentDistricts.length > 0 && (
            <div>
              <label htmlFor="districtCode" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
                区/县 <span className="text-gray-500 text-xs normal-case">(可选)</span>
              </label>
              <select
                id="districtCode"
                value={formData.districtCode}
                onChange={(e) => setFormData({ ...formData, districtCode: e.target.value })}
                className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
                style={{ borderRadius: '4px' }}
              >
                <option value="">请选择区/县</option>
                {currentDistricts.map((district) => (
                  <option key={district.value} value={district.value}>
                    {district.label}
                  </option>
                ))}
              </select>
            </div>
          )}

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

          <div className="space-y-4">
            <div>
              <label className="flex items-center space-x-3 cursor-pointer mb-4">
                <input
                  type="checkbox"
                  checked={formData.isFree}
                  onChange={(e) => {
                    setFormData({ 
                      ...formData, 
                      isFree: e.target.checked,
                      priceMin: e.target.checked ? '' : formData.priceMin,
                      priceMax: e.target.checked ? '' : formData.priceMax
                    })
                  }}
                  className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                  style={{ borderRadius: '4px' }}
                />
                <span className="text-body-sm font-bold uppercase tracking-wide">免费场地</span>
              </label>
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
                  onChange={(e) => setFormData({ ...formData, priceMin: e.target.value, isFree: false })}
                  disabled={formData.isFree}
                  className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900 disabled:bg-gray-100 disabled:cursor-not-allowed"
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
                  onChange={(e) => setFormData({ ...formData, priceMax: e.target.value, isFree: false })}
                  disabled={formData.isFree}
                  className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900 disabled:bg-gray-100 disabled:cursor-not-allowed"
                  style={{ borderRadius: '4px' }}
                  placeholder="例如：100"
                />
              </div>
            </div>
          </div>

          <div className="space-y-4">
            <div>
              <label className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
                场地类型 <span className="text-gray-500 text-xs normal-case">(可选，可多选)</span>
              </label>
              <div className="flex gap-4">
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.venueTypes.includes('indoor')}
                    onChange={(e) => {
                      if (e.target.checked) {
                        // 如果还没有包含，才添加
                        if (!formData.venueTypes.includes('indoor')) {
                          setFormData({ ...formData, venueTypes: [...formData.venueTypes, 'indoor'] })
                        }
                      } else {
                        setFormData({ ...formData, venueTypes: formData.venueTypes.filter(t => t !== 'indoor') })
                      }
                    }}
                    className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                    style={{ borderRadius: '4px' }}
                  />
                  <span className="text-body-sm font-bold uppercase tracking-wide">室内场地</span>
                </label>
                <label className="flex items-center space-x-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.venueTypes.includes('outdoor')}
                    onChange={(e) => {
                      if (e.target.checked) {
                        // 如果还没有包含，才添加
                        if (!formData.venueTypes.includes('outdoor')) {
                          setFormData({ ...formData, venueTypes: [...formData.venueTypes, 'outdoor'] })
                        }
                      } else {
                        setFormData({ ...formData, venueTypes: formData.venueTypes.filter(t => t !== 'outdoor') })
                      }
                    }}
                    className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                    style={{ borderRadius: '4px' }}
                  />
                  <span className="text-body-sm font-bold uppercase tracking-wide">室外场地</span>
                </label>
              </div>
              {formData.venueTypes.length > 0 && (
                <p className="text-xs text-gray-600 mt-2">
                  已选择：{formData.venueTypes.map(t => t === 'indoor' ? '室内场地' : '室外场地').join('、')}
                </p>
              )}
            </div>
            
            <div>
              <label className="flex items-center space-x-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.isPublic}
                  onChange={(e) => setFormData({ ...formData, isPublic: e.target.checked })}
                  className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                  style={{ borderRadius: '4px' }}
                />
                <span className="text-body-sm font-bold uppercase tracking-wide">是否对外开放 <span className="text-gray-500 text-xs normal-case">(可选)</span></span>
              </label>
              <p className="text-xs text-gray-600 mt-2 ml-8">
                💡 提示：勾选表示场地对外开放，未勾选表示仅限内部使用
              </p>
            </div>
          </div>

          <div>
            <label htmlFor="contact" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              联系方式 <span className="text-gray-500 text-xs normal-case">(可选)</span>
            </label>
            <input
              type="text"
              id="contact"
              value={formData.contact}
              onChange={(e) => setFormData({ ...formData, contact: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
              placeholder="例如：13800138000 或 微信号：xxx"
            />
            <p className="text-xs text-gray-600 mt-2">
              💡 提示：可以填写电话、微信或其他联系方式
            </p>
          </div>

          <div>
            <label htmlFor="courtCount" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              场地数量 <span className="text-gray-500 text-xs normal-case">(可选)</span>
            </label>
            <input
              type="number"
              id="courtCount"
              min="1"
              value={formData.courtCount}
              onChange={(e) => setFormData({ ...formData, courtCount: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
              placeholder="例如：4（表示有4个篮球场/足球场）"
            />
            <p className="text-xs text-gray-600 mt-2">
              💡 提示：填写该场地包含的篮球场或足球场数量
            </p>
          </div>

          <div>
            <label className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              地板类型 <span className="text-gray-500 text-xs normal-case">(可选，可多选)</span>
            </label>
            <div className="space-y-2">
              {['木地板', '塑胶', '水泥', '人工草皮', '天然草皮', '其他'].map((type) => (
                <label key={type} className="flex items-center space-x-3 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={formData.floorType.includes(type)}
                    onChange={(e) => {
                      if (e.target.checked) {
                        setFormData({ ...formData, floorType: [...formData.floorType, type] })
                      } else {
                        setFormData({ ...formData, floorType: formData.floorType.filter(t => t !== type) })
                      }
                    }}
                    className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                    style={{ borderRadius: '4px' }}
                  />
                  <span className="text-body-sm font-bold uppercase tracking-wide">{type}</span>
                </label>
              ))}
            </div>
            {formData.floorType.length > 0 && (
              <p className="text-xs text-gray-600 mt-2">
                已选择：{formData.floorType.join('、')}
              </p>
            )}
          </div>

          <div>
            <label htmlFor="openHours" className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              开放时间 <span className="text-gray-500 text-xs normal-case">(可选)</span>
            </label>
            <input
              type="text"
              id="openHours"
              value={formData.openHours}
              onChange={(e) => setFormData({ ...formData, openHours: e.target.value })}
              className="w-full px-4 py-3 border border-gray-900 bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-gray-900"
              style={{ borderRadius: '4px' }}
              placeholder="例如：周一至周五 9:00-22:00，周末 8:00-23:00"
            />
            <p className="text-xs text-gray-600 mt-2">
              💡 提示：填写场地的开放时间
            </p>
          </div>

          <div className="space-y-3">
            <label className="block text-body-sm font-bold mb-2 uppercase tracking-wide">
              设施信息 <span className="text-gray-500 text-xs normal-case">(可选)</span>
            </label>
            <div className="space-y-2">
              <label className="flex items-center space-x-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.hasLighting}
                  onChange={(e) => setFormData({ ...formData, hasLighting: e.target.checked })}
                  className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                  style={{ borderRadius: '4px' }}
                />
                <span className="text-body-sm font-bold uppercase tracking-wide">有灯光</span>
              </label>
              <label className="flex items-center space-x-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.hasAirConditioning}
                  onChange={(e) => setFormData({ ...formData, hasAirConditioning: e.target.checked })}
                  className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                  style={{ borderRadius: '4px' }}
                />
                <span className="text-body-sm font-bold uppercase tracking-wide">有空调</span>
              </label>
              <label className="flex items-center space-x-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.hasParking}
                  onChange={(e) => setFormData({ ...formData, hasParking: e.target.checked })}
                  className="w-5 h-5 border-gray-900 text-gray-900 focus:ring-2 focus:ring-gray-900"
                  style={{ borderRadius: '4px' }}
                />
                <span className="text-body-sm font-bold uppercase tracking-wide">有停车场</span>
              </label>
            </div>
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
                  {selectedImages.map((file, index) => {
                    const objectUrl = URL.createObjectURL(file)
                    return (
                      <button
                        key={index}
                        type="button"
                        className="relative group w-full h-24 border border-gray-300 overflow-hidden"
                        onClick={() => setPreviewIndex(index)}
                      >
                        <img
                          src={objectUrl}
                          alt={`预览 ${index + 1}`}
                          className="w-full h-full object-cover"
                        />
                        <span className="absolute bottom-1 left-1 bg-black/60 text-white text-[10px] px-1.5 py-0.5 rounded">
                          点击放大预览
                        </span>
                        <button
                          type="button"
                          onClick={(e) => {
                            e.stopPropagation()
                            setSelectedImages(selectedImages.filter((_, i) => i !== index))
                          }}
                          className="absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity"
                        >
                          ×
                        </button>
                      </button>
                    )
                  })}
                </div>
              )}
              
              <p className="text-xs text-gray-600">
                💡 提示：支持 JPG、PNG 格式，每张最大 10MB。添加场地成功后会自动上传。
              </p>
            </div>
          </div>

          {/* 图片大图预览（仅本地预览，未上传阶段） */}
          {previewIndex !== null && selectedImages[previewIndex] && (
            <div
              className="fixed inset-0 bg-black/70 z-50 flex items-center justify-center px-4"
              onClick={() => setPreviewIndex(null)}
            >
              <div
                className="relative max-w-4xl max-h-[90vh] w-full"
                onClick={(e) => e.stopPropagation()}
              >
                <button
                  type="button"
                  className="absolute -top-10 right-0 text-white text-sm px-3 py-1 border border-white/60 rounded-full hover:bg-white hover:text-black transition-colors"
                  onClick={() => setPreviewIndex(null)}
                >
                  关闭预览
                </button>
                <img
                  src={URL.createObjectURL(selectedImages[previewIndex])}
                  alt="图片预览"
                  className="w-full max-h-[90vh] object-contain bg-black"
                />
              </div>
            </div>
          )}

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

      {/* 图片放大预览弹层 */}
      {previewIndex !== null && selectedImages[previewIndex] && (
        <div
          className="fixed inset-0 z-50 bg-black/70 flex items-center justify-center"
          onClick={() => setPreviewIndex(null)}
        >
          <div
            className="relative max-w-3xl max-h-[90vh] w-full px-4"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              type="button"
              className="absolute -top-8 right-0 text-white text-sm px-3 py-1 bg-black/60 rounded-full"
              onClick={() => setPreviewIndex(null)}
            >
              关闭预览
            </button>
            <div className="w-full h-[60vh] md:h-[70vh] bg-black rounded overflow-hidden flex items-center justify-center">
              <img
                src={URL.createObjectURL(selectedImages[previewIndex])}
                alt={`放大预览 ${previewIndex + 1}`}
                className="max-w-full max-h-full object-contain"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

