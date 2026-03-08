'use client'

import Link from 'next/link'
import { MapPin, Search, Menu, LogIn } from 'lucide-react'
import { useState, useEffect } from 'react'
import { getAuthState, setAuthState as persistAuthState, clearAuthState, getAuthHeader, User } from '@/lib/auth'
import LoginModal from './LoginModal'
import UserMenu from './UserMenu'

export default function Nav() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false)
  const [authState, setAuthState] = useState({ user: null, token: null, isAuthenticated: false })
  const [mounted, setMounted] = useState(false)
  const [searchKeyword, setSearchKeyword] = useState('')

  useEffect(() => {
    // 确保组件已挂载
    setMounted(true)
    // 检查认证状态（只在客户端执行）
    if (typeof window !== 'undefined') {
      const state = getAuthState()
      setAuthState(state)
      // 已登录时从后端拉取最新用户信息（延迟执行，避免阻塞首屏）
      let profileTimeout: ReturnType<typeof setTimeout> | undefined
      if (state.isAuthenticated && state.token) {
        profileTimeout = setTimeout(() => {
          fetch('/api/auth/profile', { headers: getAuthHeader(), cache: 'default' })
            .then((r) => r.json())
            .then((data: { user?: User }) => {
              if (data?.user && state.token) {
                persistAuthState(data.user, state.token)
                setAuthState({ user: data.user, token: state.token, isAuthenticated: true })
              }
            })
            .catch(() => {})
        }, 300)
      }

      // 强制确保导航栏和按钮可见，移除重复的导航栏
      const ensureVisible = () => {
        // 查找所有导航栏
        const headers = Array.from(document.querySelectorAll('header#main-nav-header, header')).filter(h => h instanceof HTMLElement) as HTMLElement[]
        
        // 找到React导航栏（有.container-page或nav元素）
        const reactNav = headers.find(header => 
          header.querySelector('.container-page') || header.querySelector('nav')
        )
        
        // 移除所有非React导航栏
        headers.forEach(header => {
          if (header !== reactNav) {
            const hasReactContent = header.querySelector('.container-page') || header.querySelector('nav')
            if (!hasReactContent) {
              header.remove()
            }
          }
        })
        
        // 确保React导航栏可见
        const header = reactNav || document.querySelector('#main-nav-header') || document.querySelector('header')
        if (header && header instanceof HTMLElement) {
          // 只设置顶栏样式，不强制 height，避免裁切移动端下拉菜单
          header.style.setProperty('position', 'fixed', 'important')
          header.style.setProperty('top', '0', 'important')
          header.style.setProperty('left', '0', 'important')
          header.style.setProperty('right', '0', 'important')
          header.style.setProperty('width', '100%', 'important')
          header.style.setProperty('min-height', '64px', 'important')
          header.style.setProperty('z-index', '99999', 'important')
          header.style.setProperty('display', 'flex', 'important')
          header.style.setProperty('flex-direction', 'column', 'important')
          header.style.setProperty('visibility', 'visible', 'important')
          header.style.setProperty('opacity', '1', 'important')
          header.style.setProperty('background-color', '#ffffff', 'important')
          header.style.setProperty('border-bottom', '2px solid #000000', 'important')
          header.style.setProperty('box-shadow', '0 4px 6px rgba(0,0,0,0.1)', 'important')
          header.style.setProperty('overflow', 'visible', 'important')
          
          // 强制设置所有添加场地按钮样式
          const buttons = header.querySelectorAll('a[href="/admin/add-venue"]')
          buttons.forEach(button => {
            if (button instanceof HTMLElement) {
              button.style.setProperty('background-color', '#000000', 'important')
              button.style.setProperty('color', '#ffffff', 'important')
              button.style.setProperty('display', 'inline-flex', 'important')
              button.style.setProperty('visibility', 'visible', 'important')
              button.style.setProperty('opacity', '1', 'important')
              button.style.setProperty('text-decoration', 'none', 'important')
              button.style.setProperty('padding', '8px 16px', 'important')
              button.style.setProperty('font-weight', 'bold', 'important')
              button.style.setProperty('border-radius', '4px', 'important')
              button.style.setProperty('-webkit-border-radius', '4px', 'important')
              button.style.setProperty('-moz-border-radius', '4px', 'important')
            }
          })
          
          // 强制设置所有链接和按钮的圆角
          const allLinks = header.querySelectorAll('a, button')
          allLinks.forEach(el => {
            if (el instanceof HTMLElement) {
              el.style.setProperty('border-radius', '4px', 'important')
              el.style.setProperty('-webkit-border-radius', '4px', 'important')
              el.style.setProperty('-moz-border-radius', '4px', 'important')
            }
          })
        }
      }
      
      // 立即执行
      ensureVisible()
      // 延迟执行，确保React已完全渲染
      setTimeout(ensureVisible, 50)
      setTimeout(ensureVisible, 100)
      setTimeout(ensureVisible, 300)
      setTimeout(ensureVisible, 500)
      setTimeout(ensureVisible, 1000)
      
      // 持续监控（每500ms检查一次）
      const interval = setInterval(ensureVisible, 500)

      return () => {
        clearInterval(interval)
        if (profileTimeout) clearTimeout(profileTimeout)
      }
    }
  }, [])

  // 引导页点击「登录」时打开登录弹窗
  useEffect(() => {
    const openLogin = () => setIsLoginModalOpen(true)
    window.addEventListener('findyu-open-login', openLogin)
    return () => window.removeEventListener('findyu-open-login', openLogin)
  }, [])

  const handleLoginSuccess = (user: User, token: string) => {
    setAuthState({ user, token, isAuthenticated: true })
  }

  const handleLogout = () => {
    clearAuthState()
    setAuthState({ user: null, token: null, isAuthenticated: false })
  }

  // 强制显示样式（移动端不设 overflow:hidden，避免下拉菜单被裁切）
  const forceVisibleStyle: React.CSSProperties = {
    position: 'fixed',
    top: '0px',
    left: '0px',
    right: '0px',
    width: '100%',
    minHeight: '64px',
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'stretch',
    backgroundColor: '#ffffff',
    borderBottom: '2px solid #000000',
    boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
    zIndex: 99999,
    overflow: 'visible',
    margin: 0,
    padding: 0,
    paddingTop: 'env(safe-area-inset-top, 0px)',
    visibility: 'visible',
    opacity: 1,
    WebkitTransform: 'translateZ(0)',
    transform: 'translateZ(0)'
  }

  return (
    <>
      <style
        dangerouslySetInnerHTML={{
          __html: `
          header#main-nav-header {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            width: 100% !important;
            min-height: 64px !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: stretch !important;
            background-color: #ffffff !important;
            border-bottom: 2px solid #000000 !important;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1) !important;
            z-index: 99999 !important;
            overflow: visible !important;
            margin: 0 !important;
            padding: 0 !important;
            padding-top: env(safe-area-inset-top, 0) !important;
            visibility: visible !important;
            opacity: 1 !important;
          }
          /* 移动端强制隐藏中间三个导航链接，避免错位重叠 */
          @media (max-width: 1023px) {
            header#main-nav-header .nav-desktop-only {
              display: none !important;
              visibility: hidden !important;
            }
          }
          /* 只在桌面端高亮“添加场地”按钮，避免移动端样式冲突 */
          @media (min-width: 1024px) {
            header#main-nav-header a[href="/admin/add-venue"],
            header#main-nav-header a[href="/admin/add-venue"]:link,
            header#main-nav-header a[href="/admin/add-venue"]:visited,
            header#main-nav-header a[href="/admin/add-venue"]:hover,
            header#main-nav-header a[href="/admin/add-venue"]:focus,
            header#main-nav-header a[href="/admin/add-venue"]:active {
              background-color: #000000 !important;
              color: #ffffff !important;
              visibility: visible !important;
              opacity: 1 !important;
              text-decoration: none !important;
              padding: 8px 16px !important;
              font-weight: bold !important;
              border-radius: 4px !important;
              -webkit-border-radius: 4px !important;
              -moz-border-radius: 4px !important;
            }
          }
          header#main-nav-header a,
          header#main-nav-header a:link,
          header#main-nav-header a:visited,
          header#main-nav-header a:hover,
          header#main-nav-header a:focus,
          header#main-nav-header a:active,
          header#main-nav-header button,
          header#main-nav-header button:hover,
          header#main-nav-header button:focus,
          header#main-nav-header button:active,
          header#main-nav-header .link-nike,
          header#main-nav-header .link-nike:hover,
          header#main-nav-header .link-nike:focus {
            visibility: visible !important;
            opacity: 1 !important;
            border-radius: 4px !important;
            -webkit-border-radius: 4px !important;
            -moz-border-radius: 4px !important;
          }
        `,
        }}
      />
      <header 
        id="main-nav-header"
        style={{
          ...forceVisibleStyle,
          position: 'fixed' as const,
          top: '0px',
          left: '0px',
          right: '0px',
          width: '100%',
          height: 'auto',
          minHeight: '64px',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'stretch',
          backgroundColor: '#ffffff',
          borderBottom: '2px solid #000000',
          zIndex: 999999,
          visibility: 'visible',
          opacity: 1,
          padding: '0 1rem',
          margin: 0,
          boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
        }}
      >
        {/* 顶栏：Logo + 中间导航 + 右侧操作，固定高度，避免移动端重叠 */}
        <div 
          className="container-page flex items-center justify-between shrink-0"
          style={{ height: '64px', minHeight: '64px', width: '100%', padding: '0 1rem', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}
        >
          {/* 左侧 Logo */}
          <Link href="/" className="flex items-center" style={{ color: '#000000', textDecoration: 'none', display: 'flex', alignItems: 'center' }}>
            <img 
              src="/logo.png" 
              alt="Find遇 Logo" 
              style={{ height: '32px', width: 'auto', display: 'block' }}
            />
          </Link>
          
          {/* 中间导航菜单 - 仅桌面端显示，移动端完全隐藏（不写 display 以免覆盖 hidden） */}
          <nav className="nav-desktop-only hidden lg:flex items-center gap-8" style={{ position: 'relative', zIndex: 100000 }}>
            <Link 
              href="/map?sport=basketball" 
              className="text-black hover:underline transition-colors"
              style={{ 
                color: '#000000', 
                textDecoration: 'none',
                fontSize: '14px',
                fontWeight: '400',
                letterSpacing: '0.01em'
              }}
            >
              篮球场地
            </Link>
            <Link 
              href="/map?sport=football" 
              className="text-black hover:underline transition-colors"
              style={{ 
                color: '#000000', 
                textDecoration: 'none',
                fontSize: '14px',
                fontWeight: '400',
                letterSpacing: '0.01em'
              }}
            >
              足球场地
            </Link>
            <Link 
              href="/map" 
              className="text-black hover:underline transition-colors"
              style={{ 
                color: '#000000', 
                textDecoration: 'none',
                fontSize: '14px',
                fontWeight: '400',
                letterSpacing: '0.01em'
              }}
            >
              地图探索
            </Link>
            <Link 
              href="/admin/add-venue" 
              className="text-black hover:underline transition-colors"
              style={{ fontSize: '14px', fontWeight: '400', letterSpacing: '0.01em' }}
            >
              添加场地
            </Link>
          </nav>

          {/* 右侧：搜索栏 + 用户菜单（移动端单行：Logo + 圆角搜索 + 菜单，Nike 风格） */}
          <div className="flex items-center gap-2 md:gap-4 min-w-0" style={{ display: 'flex', alignItems: 'center' }}>
            {/* 移动端：仅保留搜索图标，点击进入地图页搜索 */}
            <button
              type="button"
              className="md:hidden shrink-0 p-1.5 text-black"
              style={{ background: 'none', border: 'none', cursor: 'pointer' }}
              aria-label="搜索场地"
              onClick={() => {
                if (typeof window !== 'undefined') {
                  window.location.href = '/map'
                }
              }}
            >
              <Search className="h-5 w-5" />
            </button>

            {/* 搜索栏 - 仅桌面端显示，移动端只显示图标 */}
            <form
              onSubmit={(e) => {
                e.preventDefault()
                const form = e.currentTarget
                const input = form.querySelector<HTMLInputElement>('input[name="nav-search-keyword"]')
                const kw = (input?.value ?? searchKeyword).trim()
                if (kw) {
                  window.location.href = `/map?keyword=${encodeURIComponent(kw)}`
                } else {
                  window.location.href = '/map'
                }
              }}
              className="hidden md:flex items-center gap-2 bg-gray-100 min-w-0 rounded-full hover:bg-gray-200 transition-colors"
              style={{
                backgroundColor: '#f3f3f3',
                padding: '8px 14px',
                borderRadius: '9999px',
                cursor: 'text',
                minHeight: '40px',
                width: '100%',
                maxWidth: '170px',
              }}
            >
              <button
                type="submit"
                className="shrink-0 p-0 border-0 bg-transparent cursor-pointer flex items-center justify-center"
                style={{ color: '#6b7280' }}
                aria-label="搜索"
              >
                <Search className="h-4 w-4 md:h-4" />
              </button>
              <input
                name="nav-search-keyword"
                type="text"
                value={searchKeyword}
                onChange={(e) => setSearchKeyword(e.target.value)}
                placeholder="搜索场地"
                className="bg-transparent border-0 outline-0 flex-1 min-w-0 text-sm"
                style={{
                  backgroundColor: 'transparent',
                  border: 'none',
                  outline: 'none',
                  color: '#000000',
                  flex: 1,
                  minWidth: 0
                }}
                autoComplete="off"
                aria-label="搜索关键词"
              />
            </form>

            {/* 网页端：下载 APP 二维码（悬停显示） */}
            <div className="hidden md:block shrink-0 relative group">
              <button
                type="button"
                className="text-black text-sm font-medium hover:underline"
                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: '0 4px' }}
              >
                下载APP
              </button>
              <div
                className="absolute right-0 top-full mt-2 py-3 px-4 bg-white rounded-lg shadow-lg border border-gray-200 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all z-[100001]"
                style={{ minWidth: '140px' }}
              >
                <img
                  src="/app-download-qrcode.png"
                  alt="扫码下载 FY体育 APP"
                  className="w-28 h-28 object-contain mx-auto"
                  onError={(e) => {
                    const target = e.currentTarget
                    if (target.src !== '/wechat-qrcode.jpg') {
                      target.src = '/wechat-qrcode.jpg'
                      target.alt = '扫码添加微信'
                    }
                  }}
                />
                <p className="text-center text-xs text-gray-600 mt-2">扫码下载 APP</p>
              </div>
            </div>

            {/* 用户菜单（仅已登录时显示头像，下方移动端菜单保留登录入口） */}
            {authState.isAuthenticated && (
              <div className="shrink-0 hidden md:block" style={{ position: 'relative', zIndex: 100000 }}>
                <UserMenu user={authState.user!} onLogout={handleLogout} />
              </div>
            )}

            {/* 移动端菜单按钮（Nike 风格单行顶栏） */}
            <div className="md:hidden shrink-0">
              <button
                onClick={() => setIsMenuOpen(!isMenuOpen)}
                className="text-black p-1"
                style={{ background: 'none', border: 'none', cursor: 'pointer' }}
                aria-label="菜单"
              >
                <Menu className="h-6 w-6" />
              </button>
            </div>
          </div>
        </div>

        {/* 移动端下拉菜单 */}
        {isMenuOpen && (
          <div 
            className="md:hidden border-t border-gray-200 bg-white"
            style={{ flexShrink: 0, padding: '1rem', paddingBottom: '1.5rem' }}
          >
            <div className="flex flex-col gap-3 text-left">
              {authState.isAuthenticated && (
                <Link
                  href="/user"
                  className="block py-2 text-black font-medium"
                  onClick={() => setIsMenuOpen(false)}
                >
                  个人设置
                </Link>
              )}
              <Link
                href="/map?sport=basketball"
                className="block py-2 text-black font-medium"
                onClick={() => setIsMenuOpen(false)}
              >
                篮球场地
              </Link>
              <Link
                href="/map?sport=football"
                className="block py-2 text-black font-medium"
                onClick={() => setIsMenuOpen(false)}
              >
                足球场地
              </Link>
              <Link
                href="/map"
                className="block py-2 text-black font-medium"
                onClick={() => setIsMenuOpen(false)}
              >
                地图探索
              </Link>
              {authState.isAuthenticated ? (
                <div className="pt-3 border-t border-gray-200">
                  <div className="text-sm text-gray-600 mb-2">
                    {authState.user?.nickname || authState.user?.phone}
                  </div>
                  <button
                    type="button"
                    onClick={() => {
                      handleLogout()
                      setIsMenuOpen(false)
                    }}
                    className="text-black font-medium"
                  >
                    退出登录
                  </button>
                </div>
              ) : (
                <button
                  type="button"
                  onClick={() => {
                    setIsLoginModalOpen(true)
                    setIsMenuOpen(false)
                  }}
                  className="block w-full py-2 text-left text-black font-medium"
                >
                  登录 / 注册
                </button>
              )}
            </div>
          </div>
        )}
      </header>

      <LoginModal
        isOpen={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        onSuccess={handleLoginSuccess}
      />
    </>
  )
}


