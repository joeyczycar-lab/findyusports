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
      <header className="sticky top-0 z-40 backdrop-blur bg-white/70 border-b border-divider">
        <div className="container-page h-14 flex items-center justify-between">
          <Link href="/" className="font-bold flex items-center space-x-2">
            <MapPin className="h-6 w-6 text-blue-600" />
            <span>场地分享</span>
          </Link>
          
          <nav className="hidden md:flex items-center space-x-6">
            <Link href="/map" className="text-sm hover:text-blue-600">地图</Link>
            
            {authState.isAuthenticated ? (
              <UserMenu user={authState.user!} onLogout={handleLogout} />
            ) : (
              <button
                onClick={() => setIsLoginModalOpen(true)}
                className="flex items-center space-x-1 text-sm text-gray-700 hover:text-blue-600"
              >
                <LogIn size={16} />
                <span>登录</span>
              </button>
            )}
          </nav>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="text-gray-700 hover:text-blue-600"
            >
              <Menu className="h-6 w-6" />
            </button>
          </div>
        </div>

        {/* Mobile Navigation */}
        {isMenuOpen && (
          <div className="md:hidden border-t border-divider">
            <div className="container-page py-4 space-y-3">
              <Link
                href="/map"
                className="block text-sm hover:text-blue-600"
                onClick={() => setIsMenuOpen(false)}
              >
                地图
              </Link>
              
              {authState.isAuthenticated ? (
                <div className="pt-2 border-t border-divider">
                  <div className="text-sm text-gray-600 mb-2">
                    欢迎，{authState.user?.nickname || authState.user?.phone}
                  </div>
                  <button
                    onClick={() => {
                      handleLogout()
                      setIsMenuOpen(false)
                    }}
                    className="text-sm text-blue-600 hover:text-blue-700"
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
                  className="block text-sm text-gray-700 hover:text-blue-600"
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


