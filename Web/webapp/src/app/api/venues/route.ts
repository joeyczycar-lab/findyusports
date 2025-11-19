import { NextRequest } from 'next/server'

type LngLat = [number, number]

function parseBounds(req: NextRequest) {
  const ne = req.nextUrl.searchParams.get('ne') // lng,lat
  const sw = req.nextUrl.searchParams.get('sw') // lng,lat
  if (!ne || !sw) return null
  const [neLng, neLat] = ne.split(',').map(Number)
  const [swLng, swLat] = sw.split(',').map(Number)
  if ([neLng, neLat, swLng, swLat].some((n) => Number.isNaN(n))) return null
  return { northeast: [neLng, neLat] as LngLat, southwest: [swLng, swLat] as LngLat }
}

function randomInRange(min: number, max: number) {
  return Math.random() * (max - min) + min
}

export async function GET(req: NextRequest) {
  const bounds = parseBounds(req)
  // mock: 若无边界，默认北京周边
  const ne = bounds?.northeast ?? [116.55, 39.98]
  const sw = bounds?.southwest ?? [116.30, 39.84]

  const count = 20
  const data = Array.from({ length: count }).map((_, i) => {
    const lng = randomInRange(sw[0], ne[0])
    const lat = randomInRange(sw[1], ne[1])
    return {
      id: `${Date.now()}_${i}`,
      name: `示例场地 ${i + 1}`,
      sportType: i % 2 === 0 ? 'basketball' : 'football',
      rating: Number((Math.random() * 2 + 3).toFixed(1)),
      price: Math.random() > 0.5 ? 0 : Math.floor(Math.random() * 80) + 20,
      indoor: Math.random() > 0.6 ? false : true,
      location: [lng, lat] as LngLat,
      distanceKm: Number((Math.random() * 8 + 0.5).toFixed(1)),
    }
  })

  return Response.json({ items: data })
}


