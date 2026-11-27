/**
 * 高德 Web 服务地理编码：地址 → 经纬度（GCJ-02）。
 * Key 从环境变量 AMAP_WEB_KEY 读取，仅后端使用，不进入前端。
 */

export interface GeocodeResult {
  lng: number
  lat: number
  adcode?: string
  formatted?: string
  district?: string
}

/** 简单城市名/代码 → 城市约束参数，提升解析命中率 */
function cityHint(address: string, cityCode?: string): string | undefined {
  if (cityCode && /^\d{6}$/.test(cityCode)) return cityCode
  // 地址里已含省/市信息时不必再传
  return undefined
}

export async function geocodeAddress(
  address: string,
  cityCode?: string,
): Promise<GeocodeResult | null> {
  const key = process.env.AMAP_WEB_KEY?.trim()
  const addr = String(address || '').trim()
  if (!key || !addr) return null

  try {
    const params = new URLSearchParams({ key, address: addr })
    const city = cityHint(addr, cityCode)
    if (city) params.set('city', city)

    const res = await fetch(`https://restapi.amap.com/v3/geocode/geo?${params.toString()}`, {
      signal: AbortSignal.timeout(8000),
    })
    const data = await res.json()
    if (String(data.status) !== '1' || !Array.isArray(data.geocodes) || data.geocodes.length === 0) {
      console.warn(`⚠️ 地理编码未命中: ${addr}`, data.info || '')
      return null
    }
    const g = data.geocodes[0]
    const [lng, lat] = String(g.location || '').split(',').map(Number)
    if (!Number.isFinite(lng) || !Number.isFinite(lat)) return null
    return {
      lng,
      lat,
      adcode: g.adcode,
      formatted: g.formatted_address,
      district: g.district,
    }
  } catch (error) {
    console.warn(`⚠️ 地理编码失败: ${addr}`, error instanceof Error ? error.message : String(error))
    return null
  }
}
