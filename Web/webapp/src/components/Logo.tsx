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
        flexDirection: 'column',
        alignItems: 'flex-start',
        transition: 'all 0.3s ease',
        padding: '1rem 1.5rem',
        borderRadius: '8px',
        background: 'rgba(255, 255, 255, 0.85)',
        backdropFilter: 'blur(10px)',
        WebkitBackdropFilter: 'blur(10px)',
        boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.background = 'rgba(255, 255, 255, 0.95)'
        e.currentTarget.style.transform = 'scale(1.02)'
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.background = 'rgba(255, 255, 255, 0.85)'
        e.currentTarget.style.transform = 'scale(1)'
      }}
    >
      {/* 大号 FY 字母 */}
      <div 
        className="logo-fy"
        style={{
          fontSize: '72px',
          fontWeight: 'bold',
          fontFamily: 'system-ui, -apple-system, sans-serif',
          color: '#1a237e', // 深蓝色
          lineHeight: '1',
          letterSpacing: '-2px',
          background: 'linear-gradient(135deg, #1a237e 0%, #283593 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          backgroundClip: 'text',
          position: 'relative',
        }}
      >
        FY
      </div>
      
      {/* Find遇 文字 */}
      <div 
        className="logo-text"
        style={{
          marginTop: '8px',
          fontSize: '24px',
          fontStyle: 'italic',
          fontFamily: 'system-ui, -apple-system, sans-serif',
          color: '#283593', // 稍浅的深蓝色
          lineHeight: '1.2',
          position: 'relative',
          display: 'flex',
          alignItems: 'center',
          gap: '4px',
        }}
      >
        <span style={{ fontWeight: '600' }}>Find</span>
        <span style={{ fontWeight: '500' }}>遇</span>
      </div>
      
      {/* 淡色反射效果 */}
      <div 
        className="logo-reflection"
        style={{
          marginTop: '4px',
          fontSize: '24px',
          fontStyle: 'italic',
          fontFamily: 'system-ui, -apple-system, sans-serif',
          color: 'rgba(40, 53, 147, 0.15)', // 非常淡的蓝色
          lineHeight: '1.2',
          transform: 'scaleY(-1)',
          transformOrigin: 'top',
          opacity: 0.4,
          display: 'flex',
          alignItems: 'center',
          gap: '4px',
          height: '20px',
          overflow: 'hidden',
        }}
      >
        <span style={{ fontWeight: '600' }}>Find</span>
        <span style={{ fontWeight: '500' }}>遇</span>
      </div>
    </Link>
  )
}
