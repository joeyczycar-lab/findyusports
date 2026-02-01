'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { User, Heart, History, Lock, Phone, Camera, Award, Star } from 'lucide-react'
import { getAuthState, setAuthState, getAuthHeader } from '@/lib/auth'
import {
  getFavorites,
  getBrowseHistory,
  removeFavorite,
  clearBrowseHistory,
  type FavoriteItem,
  type HistoryItem,
} from '@/lib/userData'
import { fetchJson } from '@/lib/api'

export default function UserCenterPage() {
  const [mounted, setMounted] = useState(false)
  const [authState, setAuthStateLocal] = useState(getAuthState())
  const [favorites, setFavorites] = useState<FavoriteItem[]>([])
  const [history, setHistory] = useState<HistoryItem[]>([])
  const [pwMsg, setPwMsg] = useState<{ type: 'ok' | 'err'; text: string } | null>(null)
  const [phoneMsg, setPhoneMsg] = useState<{ type: 'ok' | 'err'; text: string } | null>(null)
  const [avatarMsg, setAvatarMsg] = useState<{ type: 'ok' | 'err'; text: string } | null>(null)
  const [pwLoading, setPwLoading] = useState(false)
  const [phoneLoading, setPhoneLoading] = useState(false)
  const [avatarLoading, setAvatarLoading] = useState(false)
  const [currentPassword, setCurrentPassword] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [newPhone, setNewPhone] = useState('')
  const [phonePassword, setPhonePassword] = useState('')

  const refreshAuth = () => {
    setAuthStateLocal(getAuthState())
  }

  useEffect(() => {
    setMounted(true)
    const state = getAuthState()
    setAuthStateLocal(state)
    setFavorites(getFavorites())
    setHistory(getBrowseHistory())
    // 已登录时从后端拉取最新用户信息，使电脑上的修改在手机端可见
    if (state.isAuthenticated && state.token) {
      fetchJson<{ user?: typeof state.user }>('/auth/profile')
        .then((data) => {
          if (data?.user && state.token) {
            setAuthState(data.user, state.token)
            setAuthStateLocal({ user: data.user, token: state.token, isAuthenticated: true })
          }
        })
        .catch(() => {})
    }
  }, [])

  useEffect(() => {
    if (!mounted) return
    const hash = window.location.hash?.replace('#', '')
    if (hash) {
      const el = document.getElementById(hash)
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  }, [mounted])

  const refreshLists = () => {
    setFavorites(getFavorites())
    setHistory(getBrowseHistory())
  }

  const handleRemoveFavorite = (id: string) => {
    removeFavorite(id)
    refreshLists()
  }

  const handleClearHistory = () => {
    clearBrowseHistory()
    setHistory([])
  }

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!authState.token || !currentPassword.trim() || !newPassword.trim()) {
      setPwMsg({ type: 'err', text: '请填写当前密码和新密码' })
      return
    }
    setPwMsg(null)
    setPwLoading(true)
    try {
      const res = await fetchJson<{ error?: { message?: string } }>('/auth/change-password', {
        method: 'PUT',
        body: JSON.stringify({ currentPassword: currentPassword.trim(), newPassword: newPassword.trim() }),
      })
      if (res?.error?.message) {
        setPwMsg({ type: 'err', text: res.error.message })
        return
      }
      setPwMsg({ type: 'ok', text: '密码已修改' })
      setCurrentPassword('')
      setNewPassword('')
    } catch (err: any) {
      setPwMsg({ type: 'err', text: err?.message || '修改失败' })
    } finally {
      setPwLoading(false)
    }
  }

  const handleChangePhone = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!authState.token || !newPhone.trim() || !phonePassword.trim()) {
      setPhoneMsg({ type: 'err', text: '请填写新手机号和当前密码' })
      return
    }
    setPhoneMsg(null)
    setPhoneLoading(true)
    try {
      const res = await fetchJson<{ error?: { message?: string }; phone?: string }>('/auth/change-phone', {
        method: 'PUT',
        body: JSON.stringify({ newPhone: newPhone.trim(), password: phonePassword.trim() }),
      })
      if (res?.error?.message) {
        setPhoneMsg({ type: 'err', text: res.error.message })
        return
      }
      const user = (res as any)?.id != null ? (res as any) : (res as any)?.user ?? authState.user
      if (user && authState.token) setAuthState(user, authState.token)
      setPhoneMsg({ type: 'ok', text: '手机号已修改' })
      setNewPhone('')
      setPhonePassword('')
      refreshAuth()
    } catch (err: any) {
      setPhoneMsg({ type: 'err', text: err?.message || '修改失败' })
    } finally {
      setPhoneLoading(false)
    }
  }

  const handleUploadAvatar = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !authState.token) return
    if (!file.type.startsWith('image/')) {
      setAvatarMsg({ type: 'err', text: '请选择图片文件' })
      return
    }
    setAvatarMsg(null)
    setAvatarLoading(true)
    try {
      const formData = new FormData()
      formData.append('file', file)
      // 使用绝对路径 /api/auth/upload-avatar 确保请求到 Next.js API 路由，避免 "Cannot POST /auth/upload-avatar"
      const r = await fetch('/api/auth/upload-avatar', {
        method: 'POST',
        headers: getAuthHeader(),
        body: formData,
      })
      const res = await r.json().catch(() => ({}))
      if (!r.ok) {
        const msg = (res as any)?.error?.message || (res as any)?.message || `上传失败 ${r.status}`
        setAvatarMsg({ type: 'err', text: msg })
        return
      }
      if (res?.error?.message) {
        setAvatarMsg({ type: 'err', text: res.error.message })
        return
      }
      const user = (res as any)?.id != null ? (res as any) : (res as any)?.user ?? authState.user
      if (user && authState.token) {
        setAuthState(user, authState.token)
        refreshAuth()
      }
      setAvatarMsg({ type: 'ok', text: '头像已更新' })
    } catch (err: any) {
      setAvatarMsg({ type: 'err', text: err?.message || '上传失败' })
    } finally {
      setAvatarLoading(false)
      e.target.value = ''
    }
  }

  const formatTime = (ts: number) => {
    const d = new Date(ts)
    const now = new Date()
    const diff = now.getTime() - ts
    if (diff < 60000) return '刚刚'
    if (diff < 3600000) return `${Math.floor(diff / 60000)} 分钟前`
    if (diff < 86400000) return `${Math.floor(diff / 3600000)} 小时前`
    if (diff < 604800000) return `${Math.floor(diff / 86400000)} 天前`
    return d.toLocaleDateString('zh-CN')
  }

  if (!mounted) {
    return (
      <main className="container-page py-12">
        <div className="text-textSecondary">加载中…</div>
      </main>
    )
  }

  return (
    <main className="container-page py-8 md:py-12 bg-white max-w-3xl mx-auto">
      <h1 className="text-heading font-bold mb-8 tracking-tight">个人设置</h1>

      {/* 手机/电脑同步说明 */}
      <div className="mb-8 p-4 bg-amber-50 border border-amber-200 rounded-lg text-sm text-amber-800">
        <p className="font-medium mb-1">关于手机与电脑同步</p>
        <p className="text-amber-700">
          登录状态、收藏与浏览记录<strong>仅保存在当前设备</strong>。在手机或电脑上使用请<strong>分别登录同一账号</strong>；收藏与浏览记录暂不会跨设备同步，后续将支持。
        </p>
      </div>

      {/* 个人信息：头像、昵称、手机、积分、VIP */}
      <section id="profile" className="mb-10 scroll-mt-4">
        <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
          <User size={20} />
          个人信息
        </h2>
        <div className="border border-gray-200 rounded-lg p-5 bg-gray-50/50">
          {authState.isAuthenticated && authState.user ? (
            <div className="space-y-4">
              <div className="flex items-center gap-4">
                <label className="relative cursor-pointer">
                  {authState.user.avatar ? (
                    <img
                      src={authState.user.avatar}
                      alt=""
                      className="w-16 h-16 rounded-full object-cover"
                    />
                  ) : (
                    <div className="w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center">
                      <User size={32} className="text-blue-600" />
                    </div>
                  )}
                  <input
                    type="file"
                    accept="image/*"
                    className="sr-only"
                    disabled={avatarLoading}
                    onChange={handleUploadAvatar}
                  />
                  <span className="absolute bottom-0 right-0 bg-black text-white rounded-full p-1.5">
                    <Camera size={14} />
                  </span>
                </label>
                <div>
                  <div className="font-medium text-gray-900">
                    {authState.user.nickname || authState.user.phone || '用户'}
                  </div>
                  <div className="text-sm text-gray-500">{authState.user.phone}</div>
                  <div className="flex items-center gap-3 mt-1 text-sm">
                    <span className="flex items-center gap-1">
                      <Award size={16} className="text-amber-500" />
                      积分 {authState.user.points ?? 0}
                    </span>
                    {(authState.user.vipLevel ?? 0) >= 1 && (
                      <span className="flex items-center gap-1 text-amber-600 font-medium">
                        <Star size={16} /> VIP{authState.user.vipLevel}
                      </span>
                    )}
                  </div>
                  {avatarMsg && (
                    <p className={`text-sm mt-1 ${avatarMsg.type === 'ok' ? 'text-green-600' : 'text-red-600'}`}>
                      {avatarMsg.text}
                    </p>
                  )}
                </div>
              </div>
              <p className="text-xs text-gray-500">上传一个场地加 1 分。点击头像可更换。</p>
            </div>
          ) : (
            <p className="text-body text-textSecondary">
              未登录。登录后可同步个人设置。
            </p>
          )}
        </div>
      </section>

      {/* 修改密码 */}
      {authState.isAuthenticated && authState.user && (
        <section id="change-password" className="mb-10 scroll-mt-4">
          <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
            <Lock size={20} />
            修改密码
          </h2>
          <div className="border border-gray-200 rounded-lg p-5 bg-gray-50/50">
            <form onSubmit={handleChangePassword} className="space-y-3 max-w-sm">
              <input
                type="password"
                placeholder="当前密码"
                value={currentPassword}
                onChange={(e) => setCurrentPassword(e.target.value)}
                className="w-full h-11 px-3 border border-gray-200 rounded focus:outline-none focus:ring-2 focus:ring-black"
              />
              <input
                type="password"
                placeholder="新密码（6–20 位）"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                className="w-full h-11 px-3 border border-gray-200 rounded focus:outline-none focus:ring-2 focus:ring-black"
              />
              <button
                type="submit"
                disabled={pwLoading}
                className="h-11 px-4 bg-black text-white text-sm font-medium rounded hover:bg-gray-800 disabled:opacity-50"
              >
                {pwLoading ? '提交中…' : '确认修改'}
              </button>
              {pwMsg && (
                <p className={`text-sm ${pwMsg.type === 'ok' ? 'text-green-600' : 'text-red-600'}`}>{pwMsg.text}</p>
              )}
            </form>
          </div>
        </section>
      )}

      {/* 修改手机号 */}
      {authState.isAuthenticated && authState.user && (
        <section id="change-phone" className="mb-10 scroll-mt-4">
          <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
            <Phone size={20} />
            修改手机号
          </h2>
          <div className="border border-gray-200 rounded-lg p-5 bg-gray-50/50">
            <form onSubmit={handleChangePhone} className="space-y-3 max-w-sm">
              <input
                type="tel"
                placeholder="新手机号"
                value={newPhone}
                onChange={(e) => setNewPhone(e.target.value)}
                className="w-full h-11 px-3 border border-gray-200 rounded focus:outline-none focus:ring-2 focus:ring-black"
              />
              <input
                type="password"
                placeholder="当前密码（验证身份）"
                value={phonePassword}
                onChange={(e) => setPhonePassword(e.target.value)}
                className="w-full h-11 px-3 border border-gray-200 rounded focus:outline-none focus:ring-2 focus:ring-black"
              />
              <button
                type="submit"
                disabled={phoneLoading}
                className="h-11 px-4 bg-black text-white text-sm font-medium rounded hover:bg-gray-800 disabled:opacity-50"
              >
                {phoneLoading ? '提交中…' : '确认修改'}
              </button>
              {phoneMsg && (
                <p className={`text-sm ${phoneMsg.type === 'ok' ? 'text-green-600' : 'text-red-600'}`}>{phoneMsg.text}</p>
              )}
            </form>
          </div>
        </section>
      )}

      {/* 积分与 VIP 说明 */}
      {authState.isAuthenticated && authState.user && (
        <section id="points-vip" className="mb-10 scroll-mt-4">
          <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
            <Award size={20} />
            积分与 VIP
          </h2>
          <div className="border border-gray-200 rounded-lg p-5 bg-gray-50/50">
            <p className="text-body text-gray-700">
              当前积分：<strong>{authState.user.points ?? 0}</strong>
              {(authState.user.vipLevel ?? 0) >= 1 && (
                <span className="ml-2 text-amber-600 font-medium">· VIP{authState.user.vipLevel}</span>
              )}
            </p>
            <p className="text-sm text-gray-500 mt-2">上传一个场地加 1 分。</p>
            <div className="mt-4 text-sm">
              <div className="font-medium text-gray-700 mb-2">VIP 等级与积分</div>
              <ul className="space-y-1 text-gray-600">
                <li>VIP1：20 积分</li>
                <li>VIP2：50 积分</li>
                <li>VIP3：100 积分</li>
                <li>VIP4：200 积分</li>
                <li>VIP5：500 积分</li>
              </ul>
            </div>
          </div>
        </section>
      )}

      {/* 收藏场地 */}
      <section id="favorites" className="mb-10 scroll-mt-4">
        <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
          <Heart size={20} />
          收藏场地
        </h2>
        <div className="border border-gray-200 rounded-lg overflow-hidden">
          {favorites.length === 0 ? (
            <div className="p-6 text-center text-textSecondary text-body-sm">
              暂无收藏，去
              <Link href="/map" className="text-black underline ml-1">地图</Link>
              发现场地并收藏
            </div>
          ) : (
            <ul className="divide-y divide-gray-100">
              {favorites.map((item) => (
                <li key={item.id} className="flex items-center justify-between gap-3 px-4 py-3 hover:bg-gray-50">
                  <Link href={`/venues/${item.id}`} className="flex-1 min-w-0">
                    <span className="font-medium text-gray-900 block truncate">{item.name}</span>
                    <span className="text-xs text-gray-500">
                      {item.sportType === 'basketball' ? '篮球' : item.sportType === 'football' ? '足球' : ''}
                    </span>
                  </Link>
                  <button
                    type="button"
                    onClick={() => handleRemoveFavorite(item.id)}
                    className="text-sm text-gray-500 hover:text-red-600 shrink-0"
                  >
                    取消收藏
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      </section>

      {/* 浏览记录 */}
      <section id="history" className="scroll-mt-4">
        <h2 className="flex items-center gap-2 text-heading-sm font-bold mb-4 tracking-tight">
          <History size={20} />
          浏览记录
        </h2>
        <div className="border border-gray-200 rounded-lg overflow-hidden">
          {history.length === 0 ? (
            <div className="p-6 text-center text-textSecondary text-body-sm">
              暂无浏览记录
            </div>
          ) : (
            <>
              <div className="flex justify-end px-4 py-2 bg-gray-50 border-b border-gray-100">
                <button
                  type="button"
                  onClick={handleClearHistory}
                  className="text-sm text-gray-500 hover:text-gray-700"
                >
                  清空记录
                </button>
              </div>
              <ul className="divide-y divide-gray-100">
                {history.map((item) => (
                  <li key={`${item.id}-${item.visitedAt}`} className="px-4 py-3 hover:bg-gray-50">
                    <Link href={`/venues/${item.id}`} className="block">
                      <span className="font-medium text-gray-900 block truncate">{item.name}</span>
                      <span className="text-xs text-gray-500">
                        {item.sportType === 'basketball' ? '篮球' : item.sportType === 'football' ? '足球' : ''}
                        {' · '}
                        {formatTime(item.visitedAt)}
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
            </>
          )}
        </div>
      </section>
    </main>
  )
}
