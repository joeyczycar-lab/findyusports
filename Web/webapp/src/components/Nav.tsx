'use client'

import Link from 'next/link'
import { MapPin, Search, Menu, LogIn } from 'lucide-react'
import { useState, useEffect } from 'react'
import { getAuthState, clearAuthState, User } from '@/lib/auth'
import LoginModal from './LoginModal'
import UserMenu from './UserMenu'

export default function Nav() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())

  useEffect(() => {
    // 检查认证状态
    const state = getAuthState()
    setAuthState(state)
  }, [])

  const handleLoginSuccess = (user: User, token: string) => {
    setAuthState({ user, token, isAuthenticated: true })
  }

  const handleLogout = () => {
    clearAuthState()
    setAuthState({ user: null, token: null, isAuthenticated: false })
  }

  return (
    <>
      <header className="sticky top-0 z-40 bg-white border-b border-border">
        <div className="container-page h-16 flex items-center justify-between">
          <Link href="/" className="font-bold text-xl tracking-tight flex items-center space-x-2">
            <span className="text-black">场地发现</span>
          </Link>
          
          <nav className="hidden md:flex items-center space-x-8">
            <Link href="/map" className="link-nike">地图探索</Link>
            
            {authState.isAuthenticated ? (
              <UserMenu user={authState.user!} onLogout={handleLogout} />
            ) : (
              <button
                onClick={() => setIsLoginModalOpen(true)}
                className="link-nike"
              >
                登录
              </button>
            )}
          </nav>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="text-black"
            >
              <Menu className="h-6 w-6" />
            </button>
          </div>
        </div>

        {/* Mobile Navigation */}
        {isMenuOpen && (
          <div className="md:hidden border-t border-border bg-white">
            <div className="container-page py-4 space-y-4">
              <Link
                href="/map"
                className="block link-nike"
                onClick={() => setIsMenuOpen(false)}
              >
                地图探索
              </Link>
              
              {authState.isAuthenticated ? (
                <div className="pt-4 border-t border-border">
                  <div className="text-sm text-textSecondary mb-3">
                    {authState.user?.nickname || authState.user?.phone}
                  </div>
                  <button
                    onClick={() => {
                      handleLogout()
                      setIsMenuOpen(false)
                    }}
                    className="link-nike"
                  >
                    退出登录
                  </button>
                </div>
              ) : (
                <button
                  onClick={() => {
                    setIsLoginModalOpen(true)
                    setIsMenuOpen(false)
                  }}
                  className="block link-nike"
                >
                  登录/注册
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


