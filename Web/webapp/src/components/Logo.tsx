'use client'

import Link from 'next/link'
import { useState } from 'react'

export default function Logo() {
  const [imgSrc, setImgSrc] = useState('/logo.png')

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
        onError={() => {
          // 如果logo.png不存在，回退到logo.svg
          if (imgSrc === '/logo.png') {
            setImgSrc('/logo.svg')
          }
        }}
      />
    </Link>
  )
}
