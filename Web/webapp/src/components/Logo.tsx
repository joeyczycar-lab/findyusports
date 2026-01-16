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
        zIndex: 10,
        textDecoration: 'none',
        display: 'flex',
        alignItems: 'flex-start',
        transition: 'opacity 0.3s ease',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.opacity = '0.9'
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.opacity = '1'
      }}
    >
      <img
        src="/logo.svg"
        alt="Find遇 Logo"
        style={{
          width: '200px',
          height: 'auto',
          maxWidth: '200px',
          display: 'block',
        }}
      />
    </Link>
  )
}
