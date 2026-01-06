'use client'

import { useEffect, useState } from 'react'

export default function DebugHeroPage() {
  const [info, setInfo] = useState<any>({})

  useEffect(() => {
    // 检查背景图片元素
    const checkBg = () => {
      const section = document.querySelector('section')
      const bgDiv = document.querySelector('.hero-bg-image')
      const computedStyle = bgDiv ? window.getComputedStyle(bgDiv) : null

      setInfo({
        sectionExists: !!section,
        bgDivExists: !!bgDiv,
        bgImage: computedStyle?.backgroundImage || '未找到',
        bgSize: computedStyle?.backgroundSize || '未找到',
        bgPosition: computedStyle?.backgroundPosition || '未找到',
        opacity: computedStyle?.opacity || '未找到',
        visibility: computedStyle?.visibility || '未找到',
        zIndex: computedStyle?.zIndex || '未找到',
        display: computedStyle?.display || '未找到',
        width: computedStyle?.width || '未找到',
        height: computedStyle?.height || '未找到',
      })
    }

    checkBg()
    const interval = setInterval(checkBg, 1000)
    return () => clearInterval(interval)
  }, [])

  return (
    <div style={{ padding: '2rem', fontFamily: 'monospace' }}>
      <h1>Hero 背景图片调试页面</h1>
      
      <div style={{ marginTop: '2rem', background: '#f0f0f0', padding: '1rem', borderRadius: '5px' }}>
        <h2>检查结果：</h2>
        <pre style={{ background: '#fff', padding: '1rem', overflow: 'auto' }}>
          {JSON.stringify(info, null, 2)}
        </pre>
      </div>

      <div style={{ marginTop: '2rem' }}>
        <h2>测试背景图片显示：</h2>
        <div 
          className="hero-bg-image"
          style={{
            width: '100%',
            height: '400px',
            border: '2px solid red',
            position: 'relative'
          }}
        >
          <div style={{ 
            position: 'absolute', 
            top: '50%', 
            left: '50%', 
            transform: 'translate(-50%, -50%)',
            background: 'rgba(255,255,255,0.9)',
            padding: '1rem',
            borderRadius: '5px'
          }}>
            如果看到背景图片，说明样式正确
          </div>
        </div>
      </div>

      <div style={{ marginTop: '2rem' }}>
        <h2>手动测试：</h2>
        <div style={{ background: '#fff', padding: '1rem', border: '1px solid #ccc' }}>
          <div style={{ 
            width: '100%', 
            height: '300px',
            backgroundImage: "url('/hero-background.jpg')",
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            border: '2px solid blue'
          }}></div>
        </div>
      </div>

      <div style={{ marginTop: '2rem' }}>
        <h2>控制台命令：</h2>
        <pre style={{ background: '#f0f0f0', padding: '1rem', overflow: 'auto' }}>
{`// 检查背景图片元素
const bgDiv = document.querySelector('.hero-bg-image');
console.log('背景元素:', bgDiv);
console.log('样式:', window.getComputedStyle(bgDiv));

// 检查背景图片
const bgImage = window.getComputedStyle(bgDiv).backgroundImage;
console.log('背景图片:', bgImage);

// 强制设置背景图片
if (bgDiv) {
  bgDiv.style.backgroundImage = "url('/hero-background.jpg')";
  bgDiv.style.backgroundSize = 'cover';
  bgDiv.style.opacity = '1';
  bgDiv.style.visibility = 'visible';
}`}
        </pre>
      </div>
    </div>
  )
}




















