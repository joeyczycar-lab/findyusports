'use client'

import { useState } from 'react'
import { User, LogOut, Settings, ChevronDown } from 'lucide-react'
import { User as UserType } from '@/lib/auth'

interface UserMenuProps {
  user: UserType
  onLogout: () => void
}

export default function UserMenu({ user, onLogout }: UserMenuProps) {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 text-gray-700 hover:text-gray-900"
      >
        {user.avatar ? (
          <img
            src={user.avatar}
            alt={user.nickname || user.phone}
            className="w-8 h-8 rounded-full object-cover"
          />
        ) : (
          <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
            <User size={16} className="text-blue-600" />
          </div>
        )}
        <span className="hidden sm:block text-sm font-medium">
          {user.nickname || user.phone}
        </span>
        <ChevronDown size={16} className="text-gray-400" />
      </button>

      {isOpen && (
        <>
          <div
            className="fixed inset-0 z-10"
            onClick={() => setIsOpen(false)}
          />
          <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border z-20">
            <div className="p-3 border-b">
              <div className="text-sm font-medium text-gray-900">
                {user.nickname || '用户'}
              </div>
              <div className="text-xs text-gray-500">{user.phone}</div>
            </div>
            
            <div className="py-1">
              <button
                onClick={() => {
                  setIsOpen(false)
                  // TODO: 实现个人设置页面
                }}
                className="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
              >
                <Settings size={16} className="mr-3" />
                个人设置
              </button>
              
              <button
                onClick={() => {
                  setIsOpen(false)
                  onLogout()
                }}
                className="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
              >
                <LogOut size={16} className="mr-3" />
                退出登录
              </button>
            </div>
          </div>
        </>
      )}
    </div>
  )
}
