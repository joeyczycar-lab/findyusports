"use client"
import { useState } from 'react'

type Props = {
  value?: number
  onChange?: (rating: number) => void
  readonly?: boolean
}

export default function StarRating({ value = 0, onChange, readonly = false }: Props) {
  const [hover, setHover] = useState(0)
  const display = hover || value

  return (
    <div className="flex gap-1">
      {[1, 2, 3, 4, 5].map((star) => (
        <button
          key={star}
          type="button"
          disabled={readonly}
          onClick={() => onChange?.(star)}
          onMouseEnter={() => setHover(star)}
          onMouseLeave={() => setHover(0)}
          className={`text-2xl ${readonly ? 'cursor-default' : 'cursor-pointer hover:scale-110'} transition-transform ${
            star <= display ? 'text-yellow-400' : 'text-gray-300'
          }`}
        >
          ★
        </button>
      ))}
    </div>
  )
}
