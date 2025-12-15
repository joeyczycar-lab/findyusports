"use client"
import { useState, useEffect } from 'react'
import StarRating from './StarRating'
import { fetchJson } from '@/lib/api'
import { getAuthState } from '@/lib/auth'
import LoginModal from './LoginModal'

type Props = {
  venueId: string
  onSuccess?: () => void
}

export default function ReviewForm({ venueId, onSuccess }: Props) {
  const [rating, setRating] = useState(0)
  const [content, setContent] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false)
  const [authState, setAuthState] = useState(getAuthState())

  useEffect(() => {
    setAuthState(getAuthState())
  }, [])

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    
    if (!authState.isAuthenticated) {
      setIsLoginModalOpen(true)
      return
    }

    if (rating === 0) {
      setError('请选择评分')
      return
    }
    if (content.trim().length < 5) {
      setError('点评内容至少5个字符')
      return
    }
    
    setSubmitting(true)
    setError('')
    
    try {
      await fetchJson(`/venues/${venueId}/reviews`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ rating, content: content.trim() })
      })
      setRating(0)
      setContent('')
      onSuccess?.()
    } catch (e: any) {
      setError(e.message || '提交失败')
    } finally {
      setSubmitting(false)
    }
  }

  const handleLoginSuccess = () => {
    setAuthState(getAuthState())
    setIsLoginModalOpen(false)
  }

  return (
    <>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium mb-2">评分</label>
          <StarRating value={rating} onChange={setRating} />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">点评内容</label>
          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder={authState.isAuthenticated ? "分享你的体验..." : "请先登录后再点评"}
            className="w-full h-24 px-3 py-2 border border-border resize-none"
            style={{ borderRadius: '2px' }}
            maxLength={500}
            disabled={!authState.isAuthenticated}
          />
          <div className="text-xs text-textMuted mt-1">{content.length}/500</div>
        </div>
        
        {error && <div className="text-sm text-red-600">{error}</div>}
        
        <button
          type="submit"
          disabled={submitting || rating === 0 || content.trim().length < 5 || !authState.isAuthenticated}
          className="w-full h-10 px-4 bg-primary text-white disabled:opacity-50 disabled:cursor-not-allowed"
          style={{ borderRadius: '2px' }}
        >
          {submitting ? '提交中...' : (authState.isAuthenticated ? '提交点评' : '请先登录')}
        </button>
      </form>

      <LoginModal
        isOpen={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        onSuccess={handleLoginSuccess}
      />
    </>
  )
}
