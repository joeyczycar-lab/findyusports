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
      // 已登录时从后端拉取最新用户信息，使电脑上的修改在手机端可见
      if (state.isAuthenticated && state.token) {
        fetch('/api/auth/profile', { headers: getAuthHeader(), cache: 'no-store' })
          .then((r) => r.json())
          .then((data: { user?: User }) => {
            if (data?.user && state.token) {
              persistAuthState(data.user, state.token)
              setAuthState({ user: data.user, token: state.token, isAuthenticated: true })
            }
          })
          .catch(() => {})
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
      
      return () => clearInterval(interval)
    }
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
          </nav>

          {/* 右侧：搜索栏 + 用户菜单 */}
          <div className="flex items-center gap-4" style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
            {/* 搜索栏 - 提交时从表单直接读关键词，与主页/手机端一致 */}
            <div className="hidden md:flex items-center" style={{ position: 'relative' }}>
              <form
                onSubmit={(e) => {
                  e.preventDefault()
                  const form = e.currentTarget
                  const input = form.querySelector<HTMLInputElement>('input[name="nav-search-keyword"]')
                  const kw = (input?.value ?? '').trim()
                  if (kw) {
                    window.location.href = `/map?keyword=${encodeURIComponent(kw)}`
                  } else {
                    window.location.href = '/map'
                  }
                }}
                className="flex items-center gap-2 bg-gray-100 px-4 py-2 rounded-full hover:bg-gray-200 transition-colors"
                style={{
                  backgroundColor: '#f5f5f5',
                  padding: '8px 16px',
                  borderRadius: '9999px',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  minWidth: '200px',
                  cursor: 'text'
                }}
              >
                <Search className="h-4 w-4 shrink-0" style={{ color: '#666666', cursor: 'pointer' }} />
                <input
                  name="nav-search-keyword"
                  type="text"
                  value={searchKeyword}
                  onChange={(e) => setSearchKeyword(e.target.value)}
                  placeholder="搜索"
                  className="bg-transparent border-0 outline-0 flex-1"
                  style={{
                    backgroundColor: 'transparent',
                    border: 'none',
                    outline: 'none',
                    color: '#000000',
                    fontSize: '14px',
                    flex: 1,
                    minWidth: 0
                  }}
                  autoComplete="off"
                />
              </form>
            </div>

            {/* 添加场地按钮 - 仅 md 以上显示，移动端在汉堡菜单内 */}
            <Link 
              href="/admin/add-venue" 
              className="bg-black text-white px-4 py-2 text-sm font-bold uppercase tracking-wider hover:bg-gray-900 transition-colors items-center justify-center rounded hidden md:inline-flex"
              style={{
                backgroundColor: '#000000',
                color: '#ffffff',
                textDecoration: 'none',
                cursor: 'pointer',
                padding: '8px 16px',
                fontWeight: 'bold',
                fontSize: '14px',
                borderRadius: '4px',
                border: 'none',
                outline: 'none',
                minWidth: '120px',
                whiteSpace: 'nowrap'
              }}
            >
              ➕ 添加场地
            </Link>

            {/* 用户菜单 */}
            {authState.isAuthenticated ? (
              <div style={{ position: 'relative', zIndex: 100000 }}>
                <UserMenu user={authState.user!} onLogout={handleLogout} />
              </div>
            ) : (
              <button
                onClick={() => setIsLoginModalOpen(true)}
                className="text-black hover:underline transition-colors hidden md:block"
                style={{ 
                  color: '#000000',
                  fontSize: '14px',
                  fontWeight: '400',
                  background: 'none',
                  border: 'none',
                  cursor: 'pointer',
                  padding: 0
                }}
              >
                登录
              </button>
            )}

            {/* Mobile menu button */}
            <div className="lg:hidden">
              <button
                onClick={() => setIsMenuOpen(!isMenuOpen)}
                className="text-black"
                style={{ background: 'none', border: 'none', cursor: 'pointer', padding: '4px' }}
              >
                <Menu className="h-6 w-6" />
              </button>
            </div>
          </div>
        </div>

        {/* 手机端置顶搜索栏：提交时从表单直接读关键词，避免 state 未同步导致只跳转无 keyword */}
        <div className="md:hidden shrink-0 w-full px-4 pb-3 pt-1" style={{ borderTop: '1px solid #eee' }}>
          <form
            onSubmit={(e) => {
              e.preventDefault()
              const form = e.currentTarget
              const input = form.querySelector<HTMLInputElement>('input[name="mobile-search-keyword"]')
              const kw = (input?.value ?? '').trim()
              if (kw) {
                window.location.href = `/map?keyword=${encodeURIComponent(kw)}`
              } else {
                window.location.href = '/map'
              }
            }}
            className="flex items-center gap-2 bg-gray-100 rounded-full overflow-hidden"
            style={{ minHeight: '44px', padding: '0 16px' }}
          >
            <Search className="h-5 w-5 shrink-0" style={{ color: '#666' }} />
            <input
              name="mobile-search-keyword"
              type="text"
              value={searchKeyword}
              onChange={(e) => setSearchKeyword(e.target.value)}
              placeholder="搜索篮球、足球场地"
              className="flex-1 bg-transparent border-0 outline-0 text-base"
              style={{ minWidth: 0 }}
              autoComplete="off"
            />
            <button type="submit" className="text-black font-medium text-sm shrink-0">
              搜索
            </button>
          </form>
        </div>

        {/* 移动端下拉菜单：独立一块，避免与顶栏重叠 */}
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
              <Link
                href="/admin/add-venue"
                className="block w-full bg-black text-white py-3 text-center text-sm font-bold rounded"
                onClick={() => setIsMenuOpen(false)}
              >
                ➕ 添加场地
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


