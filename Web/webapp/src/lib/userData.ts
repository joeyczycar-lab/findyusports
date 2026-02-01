// 本地存储：收藏场地、浏览记录（未登录时也可使用，登录后可考虑同步到后端）

const FAVORITES_KEY = 'venue_favorites'
const HISTORY_KEY = 'venue_browse_history'
const HISTORY_MAX = 50

export interface FavoriteItem {
  id: string
  name: string
  sportType?: 'basketball' | 'football'
}

export interface HistoryItem {
  id: string
  name: string
  sportType?: 'basketball' | 'football'
  visitedAt: number
}

export function getFavorites(): FavoriteItem[] {
  if (typeof window === 'undefined') return []
  try {
    const raw = localStorage.getItem(FAVORITES_KEY)
    if (!raw) return []
    const arr = JSON.parse(raw)
    return Array.isArray(arr) ? arr : []
  } catch {
    return []
  }
}

function setFavorites(items: FavoriteItem[]) {
  if (typeof window === 'undefined') return
  try {
    localStorage.setItem(FAVORITES_KEY, JSON.stringify(items))
  } catch {}
}

export function getFavoriteIds(): string[] {
  return getFavorites().map((x) => x.id)
}

export function isFavorite(venueId: string): boolean {
  return getFavorites().some((x) => x.id === String(venueId))
}

export function toggleFavorite(venueId: string, name: string, sportType?: 'basketball' | 'football'): boolean {
  const list = getFavorites()
  const id = String(venueId)
  const idx = list.findIndex((x) => x.id === id)
  if (idx >= 0) {
    list.splice(idx, 1)
    setFavorites(list)
    return false
  }
  list.unshift({ id, name, sportType })
  setFavorites(list)
  return true
}

export function addFavorite(venueId: string, name: string, sportType?: 'basketball' | 'football') {
  const list = getFavorites()
  const id = String(venueId)
  if (list.some((x) => x.id === id)) return
  list.unshift({ id, name, sportType })
  setFavorites(list)
}

export function removeFavorite(venueId: string) {
  setFavorites(getFavorites().filter((x) => x.id !== String(venueId)))
}

export function getBrowseHistory(): HistoryItem[] {
  if (typeof window === 'undefined') return []
  try {
    const raw = localStorage.getItem(HISTORY_KEY)
    if (!raw) return []
    const arr = JSON.parse(raw)
    return Array.isArray(arr) ? arr : []
  } catch {
    return []
  }
}

export function addBrowseHistory(item: { id: string; name: string; sportType?: 'basketball' | 'football' }) {
  if (typeof window === 'undefined') return
  try {
    const list = getBrowseHistory()
    const id = String(item.id)
    const next: HistoryItem = { id, name: item.name, sportType: item.sportType, visitedAt: Date.now() }
    const filtered = list.filter((x) => x.id !== id)
    filtered.unshift(next)
    const trimmed = filtered.slice(0, HISTORY_MAX)
    localStorage.setItem(HISTORY_KEY, JSON.stringify(trimmed))
  } catch {}
}

export function clearBrowseHistory() {
  if (typeof window === 'undefined') return
  try {
    localStorage.removeItem(HISTORY_KEY)
  } catch {}
}
