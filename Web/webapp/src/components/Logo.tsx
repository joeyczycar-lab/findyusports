'use client'

import Link from 'next/link'
import { useState } from 'react'

export default function Logo() {
  // 使用logo.png（手写风格的FY logo）
  const [imgSrc] = useState('/logo.png')

  return (
    <Link 
      href="/" 
      className="logo-container"
      style={{
        position: 'absolute',
        top: '2rem',
        left: '2rem',
        zIndex: 100,
        textDecoration: 'none',
        display: 'flex',
        alignItems: 'flex-start',
        transition: 'opacity 0.3s ease',
        backgroundColor: 'transparent',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.opacity = '0.9'
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.opacity = '1'
      }}
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
        }}
        onError={(e) => {
          console.error('Logo image failed to load:', e)
        }}
      />
    </Link>
  )
}
