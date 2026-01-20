'use client'

import Link from 'next/link'
import { useState } from 'react'

export default function Logo() {
  // 使用logo.png（手写风格的FY logo）
  const [imgSrc] = useState('/logo.png')
  const [isHovered, setIsHovered] = useState(false)

  return (
    <Link 
      href="/" 
      className="logo-container"
      style={{
        position: 'absolute',
        top: '2rem',
        left: '2rem',
        zIndex: 1000,
        textDecoration: 'none',
        display: 'flex',
        alignItems: 'flex-start',
        flexDirection: 'column',
        gap: '0.5rem',
        backgroundColor: 'transparent',
      }}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <img
        src={imgSrc}
        alt="Find遇 Logo"
        className="logo-image"
        style={{
          width: '200px',
          height: 'auto',
          maxWidth: '200px',
          display: 'block',
          backgroundColor: 'transparent',
          background: 'transparent',
          border: 'none',
          outline: 'none',
          visibility: 'visible',
          opacity: 1,
          transition: 'opacity 0.3s ease',
        }}
        onError={(e) => {
          console.error('Logo image failed to load:', e)
        }}
        onLoad={() => {
          console.log('Logo image loaded successfully')
        }}
      />
      {/* 悬浮时显示的文字 */}
      <span
        style={{
          color: '#ffffff',
          fontSize: '18px',
          fontWeight: 'bold',
          fontFamily: 'sans-serif',
          opacity: isHovered ? 1 : 0,
          transition: 'opacity 0.3s ease',
          pointerEvents: 'none',
          whiteSpace: 'nowrap',
          textShadow: '0 2px 4px rgba(0, 0, 0, 0.3)',
        }}
      >
        Find遇
      </span>
    </Link>
  )
}
