'use client'

import { useState } from 'react'
import { getAuthState } from '@/lib/auth'
import { fetchJson } from '@/lib/api'

const TIME_SLOTS = [
  '06:00-08:00',
  '08:00-10:00',
  '10:00-12:00',
  '12:00-14:00',
  '14:00-16:00',
  '16:00-18:00',
  '18:00-20:00',
  '20:00-22:00',
]

type Props = {
  venueId: string
  venueName: string
  onClose: () => void
  onSuccess?: () => void
}

export default function BookingModal({ venueId, venueName, onClose, onSuccess }: Props) {
  const [bookingDate, setBookingDate] = useState('')
  const [timeSlot, setTimeSlot] = useState('')
  const [note, setNote] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const auth = getAuthState()
  const isLoggedIn = auth.isAuthenticated && auth.token

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!isLoggedIn) {
      setError('请先登录')
      return
    }
    if (!bookingDate.trim() || !timeSlot.trim()) {
      setError('请选择日期和时段')
      return
    }
    setError('')
    setLoading(true)
    try {
      await fetchJson('/bookings', {
        method: 'POST',
        body: JSON.stringify({
          venueId: Number(venueId),
          bookingDate: bookingDate.trim(),
          timeSlot: timeSlot.trim(),
          note: note.trim() || undefined,
        }),
      })
      onSuccess?.()
      onClose()
    } catch (err: any) {
      setError(err?.message || '提交失败')
    } finally {
      setLoading(false)
    }
  }

  const today = new Date().toISOString().slice(0, 10)

  return (
    <div className="fixed inset-0 z-[99999] flex items-end sm:items-center justify-center bg-black/50" onClick={onClose}>
      <div
        className="bg-white w-full max-w-md rounded-t-2xl sm:rounded-2xl max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="sticky top-0 bg-white border-b border-gray-200 px-4 py-3 flex items-center justify-between">
          <h3 className="text-lg font-semibold">在线预订 · {venueName}</h3>
          <button type="button" onClick={onClose} className="p-2 text-gray-500 hover:text-black">
            ✕
          </button>
        </div>
        <form onSubmit={handleSubmit} className="p-4 space-y-4">
          {!isLoggedIn && (
            <p className="text-amber-600 text-sm">请先登录后再预订。</p>
          )}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">预订日期</label>
            <input
              type="date"
              min={today}
              value={bookingDate}
              onChange={(e) => setBookingDate(e.target.value)}
              className="w-full h-11 px-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-black"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">时段</label>
            <select
              value={timeSlot}
              onChange={(e) => setTimeSlot(e.target.value)}
              className="w-full h-11 px-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-black"
            >
              <option value="">请选择</option>
              {TIME_SLOTS.map((slot) => (
                <option key={slot} value={slot}>{slot}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">备注（选填）</label>
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="人数、需求等"
              rows={2}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-black resize-none"
            />
          </div>
          {error && <p className="text-red-600 text-sm">{error}</p>}
          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 h-11 border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50"
            >
              取消
            </button>
            <button
              type="submit"
              disabled={loading || !isLoggedIn}
              className="flex-1 h-11 bg-black text-white rounded-lg font-medium hover:bg-gray-800 disabled:opacity-50"
            >
              {loading ? '提交中…' : '提交预订'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
