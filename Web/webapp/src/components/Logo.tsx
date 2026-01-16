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
      <svg 
        width="200" 
        height="120" 
        xmlns="http://www.w3.org/2000/svg"
        className="logo-image"
        style={{
          width: '200px',
          height: 'auto',
          maxWidth: '200px',
          display: 'block',
        }}
      >
        <defs>
          <linearGradient id="fyGradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style={{stopColor:'#1a237e', stopOpacity:1}} />
            <stop offset="100%" style={{stopColor:'#283593', stopOpacity:1}} />
          </linearGradient>
        </defs>
        
        <text 
          x="10" 
          y="70" 
          fontFamily="system-ui, -apple-system, sans-serif" 
          fontSize="72" 
          fontWeight="bold" 
          fill="url(#fyGradient)" 
          letterSpacing="-2"
        >
          FY
        </text>
        
        <text 
          x="10" 
          y="95" 
          fontFamily="system-ui, -apple-system, sans-serif" 
          fontSize="24" 
          fontStyle="italic" 
          fill="#283593"
        >
          <tspan fontWeight="600">Find</tspan>
          <tspan fontWeight="500">遇</tspan>
        </text>
        
        <text 
          x="10" 
          y="115" 
          fontFamily="system-ui, -apple-system, sans-serif" 
          fontSize="24" 
          fontStyle="italic" 
          fill="rgba(40, 53, 147, 0.15)" 
          transform="scale(1, -1) translate(0, -230)"
        >
          <tspan fontWeight="600">Find</tspan>
          <tspan fontWeight="500">遇</tspan>
        </text>
      </svg>
    </Link>
  )
}
