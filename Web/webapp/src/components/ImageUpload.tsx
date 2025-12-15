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
      
      console.log('开始上传图片，venueId:', venueId)
      const result = await fetchJson(`/venues/${venueId}/upload`, {
        method: 'POST',
        body: formData
      })

      console.log('上传结果:', result)

      if (result.error) {
        const errorMsg = result.error.message || result.error.code || '上传失败'
        console.error('上传错误:', errorMsg)
        
        // 检查是否是 OSS 配置问题
        if (errorMsg.includes('OSS') || errorMsg.includes('未配置') || errorMsg.includes('未设置')) {
          throw new Error('图片上传功能需要配置阿里云 OSS。\n\n请在后端 .env 文件中配置：\n- OSS_ACCESS_KEY_ID\n- OSS_ACCESS_KEY_SECRET\n- OSS_REGION\n- OSS_BUCKET\n\n详细配置说明请查看：Server/api/OSS_SETUP.md')
        }
        
        // 检查是否是认证问题
        if (errorMsg.includes('401') || errorMsg.includes('Unauthorized') || errorMsg.includes('未登录')) {
          throw new Error('请先登录后再上传图片')
        }
        
        throw new Error(`上传失败：${errorMsg}`)
      }
      
      if (!result.url) {
        throw new Error('上传成功但未返回图片URL')
      }
      
      console.log('上传成功，图片URL:', result.url)
      onSuccess?.(result.url)
      if (fileInputRef.current) fileInputRef.current.value = ''
      setError('') // 清除之前的错误
    } catch (e: any) {
      console.error('上传异常:', e)
      const errorMsg = e.message || '上传失败，请检查网络连接和后端服务'
      setError(errorMsg)
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
          disabled={uploading}
          className="w-full h-10 px-4 border-2 border-dashed border-gray-300 hover:border-gray-900 bg-white text-black font-medium disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          style={{
            display: 'block',
            visibility: 'visible',
            opacity: uploading ? 0.5 : 1,
            borderRadius: '2px'
          }}
        >
          {uploading ? '上传中...' : (authState.isAuthenticated ? '+ 添加图片' : '请先登录')}
        </button>
        
        {error && (
          <div className="text-sm text-red-600 bg-red-50 border border-red-200 rounded p-3 whitespace-pre-line">
            {error}
          </div>
        )}
      </div>

      <LoginModal
        isOpen={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        onSuccess={handleLoginSuccess}
      />
    </>
  )
}
