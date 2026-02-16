"use client"
import { useState, useRef, useEffect } from 'react'
import { fetchJson } from '@/lib/api'
import { getAuthState, isTokenExpired } from '@/lib/auth'
import { compressImageForUpload } from '@/lib/imageCompress'
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

    const currentAuth = getAuthState()
    if (!currentAuth.token || isTokenExpired()) {
      setAuthState(getAuthState())
      setError('请先登录或登录已过期')
      setIsLoginModalOpen(true)
      return
    }
    if (!authState.isAuthenticated) {
      setAuthState(getAuthState())
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
      // 上传前压缩大图，减小体积、加快上传、降低超时
      const fileToUpload = await compressImageForUpload(file)
      const formData = new FormData()
      formData.append('file', fileToUpload)
      
      console.log('📤 [ImageUpload] 开始上传图片')
      console.log('📤 [ImageUpload] venueId:', venueId)
      console.log('📤 [ImageUpload] 文件信息:', {
        name: file.name,
        size: file.size,
        type: file.type
      })
      console.log('📤 [ImageUpload] 认证状态:', {
        isAuthenticated: authState.isAuthenticated,
        userId: authState.user?.id,
        role: authState.user?.role
      })
      
      const result = await fetchJson(`/venues/${venueId}/upload`, {
        method: 'POST',
        body: formData
      })

      console.log('📥 [ImageUpload] 上传结果:', result)

      if (result.error) {
        const errorMsg = result.error.message || result.error.code || '上传失败'
        console.error('❌ [ImageUpload] 上传错误:', errorMsg)
        console.error('❌ [ImageUpload] 错误详情:', result.error)
        
        // 检查是否是 OSS 配置问题
        if (errorMsg.includes('OSS') || errorMsg.includes('未配置') || errorMsg.includes('未设置') || errorMsg.includes('OSS未配置')) {
          throw new Error(
            '图片上传需要阿里云 OSS 配置。\n\n' +
            '· 本地开发：在 Server/api/.env 中配置 OSS_ACCESS_KEY_ID、OSS_ACCESS_KEY_SECRET、OSS_REGION、OSS_BUCKET，保存后在 Server/api 目录执行 npm run dev 重启后端；前端 .env.local 中设置 NEXT_PUBLIC_API_BASE=http://localhost:4000 并重启前端。\n\n' +
            '· Railway 部署：在 Railway 项目环境变量中配置上述四项。\n\n' +
            '详细说明：Server/api/RAILWAY_OSS_SETUP.md'
          )
        }
        
        // 检查是否是认证问题（401 时 api 已清除 token，刷新本地状态并打开登录）
        if (errorMsg.includes('401') || errorMsg.includes('Unauthorized') || errorMsg.includes('未登录') || errorMsg.includes('请先登录') || errorMsg.includes('登录已过期')) {
          setAuthState(getAuthState())
          setIsLoginModalOpen(true)
          throw new Error('请先登录或重新登录后再上传图片')
        }
        
        // 检查是否是网络问题
        if (errorMsg.includes('fetch') || errorMsg.includes('网络') || errorMsg.includes('连接')) {
          throw new Error(`无法连接到后端服务。\n\n请检查：\n1. 后端服务是否正在运行\n2. 网络连接是否正常\n3. 后端地址是否正确\n\n错误信息：${errorMsg}`)
        }
        
        throw new Error(`上传失败：${errorMsg}\n\n如果问题持续，请查看浏览器控制台（F12）获取更多信息。`)
      }
      
      const imageUrl = result.url ?? (result as any).sizes?.large
      if (!imageUrl) {
        console.error('❌ [ImageUpload] 上传成功但未返回图片URL:', result)
        throw new Error('上传成功但未返回图片URL，请刷新页面查看')
      }
      
      console.log('✅ [ImageUpload] 上传成功，图片URL:', imageUrl)
      onSuccess?.(imageUrl)
      if (fileInputRef.current) fileInputRef.current.value = ''
      setError('') // 清除之前的错误
    } catch (e: any) {
      console.error('❌ [ImageUpload] 上传异常:', e)
      console.error('❌ [ImageUpload] 错误堆栈:', e.stack)
      
      // 提取错误信息
      let errorMsg = e.message || '上传失败，请检查网络连接和后端服务'
      if (errorMsg.includes('登录已过期') || errorMsg.includes('未授权')) {
        setAuthState(getAuthState())
        setIsLoginModalOpen(true)
      }
      // 网络/连接错误：给出可操作建议
      if (errorMsg.includes('fetch failed') || errorMsg.includes('Failed to fetch') || errorMsg.includes('ECONNREFUSED') || errorMsg.includes('网络')) {
        errorMsg = `上传失败（网络异常）。请检查网络后重试；若图片较大，请先缩小到单张 2MB 以内再上传。`
      }
      
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
            borderRadius: '4px'
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
