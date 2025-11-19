let amapLoadingPromise: Promise<typeof window.AMap> | null = null

export function loadAMap(): Promise<typeof window.AMap> {
  if (typeof window === 'undefined') {
    return Promise.reject(new Error('AMap can only be loaded in the browser'))
  }
  if (window.AMap) return Promise.resolve(window.AMap)
  if (amapLoadingPromise) return amapLoadingPromise

  const key = process.env.NEXT_PUBLIC_AMAP_KEY
  if (!key) {
    return Promise.reject(new Error('Missing NEXT_PUBLIC_AMAP_KEY'))
  }

  amapLoadingPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.src = `https://webapi.amap.com/maps?v=2.0&key=${encodeURIComponent(key)}&plugin=AMap.Geolocation,AMap.ToolBar,AMap.MarkerCluster`
    script.async = true
    script.onload = () => {
      if (window.AMap) resolve(window.AMap)
      else reject(new Error('AMap loaded but window.AMap not found'))
    }
    script.onerror = () => reject(new Error('Failed to load AMap script'))
    document.head.appendChild(script)
  })

  return amapLoadingPromise
}


