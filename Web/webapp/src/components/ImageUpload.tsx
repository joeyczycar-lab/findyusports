"use client"
import { useState, useRef, useEffect } from 'react'
import { fetchJson } from '@/lib/api'
import { getAuthState } from '@/lib/auth'
import LoginModal from './LoginModal'

type Props = {
  venueId: string
  onSuccess?: (url: string) => void
}

export default function ImageUpload({ venueId, onSuccess }: Props) {
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState('')
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())
  const fileInputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    setAuthState(getAuthState())
  }, [])

  async function handleFileSelect(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (!file) return

    if (!authState.isAuthenticated) {
      setIsLoginModalOpen(true)
      return
    }

    // 校验文件类型和大小
    if (!file.type.startsWith('image/')) {
      setError('请选择图片文件')
      return
    }
    if (file.size > 10 * 1024 * 1024) {
      setError('图片大小不能超过10MB')
      return
    }

    setUploading(true)
    setError('')

    try {
      // 使用新的处理上传接口（自动压缩和多尺寸生成）
      const formData = new FormData()
      formData.append('file', file)
      
      const result = await fetchJson(`/venues/${venueId}/upload`, {
        method: 'POST',
        body: formData
      })

      if (result.error) throw new Error(result.error.message)
      
      onSuccess?.(result.url)
      if (fileInputRef.current) fileInputRef.current.value = ''
    } catch (e: any) {
      setError(e.message || '上传失败')
    } finally {
      setUploading(false)
    }
  }

  const handleLoginSuccess = () => {
    setAuthState(getAuthState())
    setIsLoginModalOpen(false)
  }

  return (
    <>
      <div className="space-y-2">
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          onChange={handleFileSelect}
          disabled={uploading || !authState.isAuthenticated}
          className="hidden"
        />
        
        <button
          onClick={() => {
            if (!authState.isAuthenticated) {
              setIsLoginModalOpen(true)
              return
            }
            fileInputRef.current?.click()
          }}
          disabled={uploading || !authState.isAuthenticated}
          className="w-full h-10 px-4 rounded-card border border-dashed border-border hover:border-primary disabled:opacity-50"
        >
          {uploading ? '上传中...' : (authState.isAuthenticated ? '+ 添加图片' : '请先登录')}
        </button>
        
        {error && <div className="text-sm text-red-600">{error}</div>}
      </div>

      <LoginModal
        isOpen={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        onSuccess={handleLoginSuccess}
      />
    </>
  )
}
