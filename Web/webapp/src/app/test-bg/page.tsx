'use client'

export default function TestBgPage() {
  return (
    <div style={{ padding: '2rem' }}>
      <h1>背景图片测试</h1>
      
      <div style={{ marginTop: '2rem' }}>
        <h2>方法1: 内联样式</h2>
        <div 
          style={{
            width: '100%',
            height: '400px',
            backgroundImage: "url('/hero-background.jpg')",
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            backgroundRepeat: 'no-repeat',
            border: '2px solid red'
          }}
        ></div>
      </div>

      <div style={{ marginTop: '2rem' }}>
        <h2>方法2: CSS 类</h2>
        <div 
          className="bg-cover bg-center bg-no-repeat"
          style={{
            width: '100%',
            height: '400px',
            backgroundImage: "url('/hero-background.jpg')",
            border: '2px solid blue'
          }}
        ></div>
      </div>

      <div style={{ marginTop: '2rem' }}>
        <h2>方法3: img 标签</h2>
        <img 
          src="/hero-background.jpg" 
          alt="测试"
          style={{
            width: '100%',
            height: '400px',
            objectFit: 'cover',
            border: '2px solid green'
          }}
        />
      </div>

      <div style={{ marginTop: '2rem' }}>
        <h2>直接链接测试</h2>
        <a href="/hero-background.jpg" target="_blank">
          点击打开图片: /hero-background.jpg
        </a>
      </div>
    </div>
  )
}

