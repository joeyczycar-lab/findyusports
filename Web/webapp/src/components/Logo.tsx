'use client'

import Link from 'next/link'

export default function Logo() {
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
        src="/logo.png"
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
          // 如果logo.png不存在，回退到logo.svg
          const target = e.target as HTMLImageElement;
          if (target.src && !target.src.includes('logo.svg')) {
            target.src = '/logo.svg';
          }
        }}
      />
    </Link>
  )
}
