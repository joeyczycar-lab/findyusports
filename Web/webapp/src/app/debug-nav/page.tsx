'use client'

import { useEffect, useState } from 'react'
import Nav from '@/components/Nav'

export default function DebugNavPage() {
  const [navExists, setNavExists] = useState(false)
  const [navStyles, setNavStyles] = useState<any>(null)

  useEffect(() => {
    const checkNav = () => {
      const header = document.querySelector('#main-nav-header') || document.querySelector('header')
      if (header) {
        setNavExists(true)
        const styles = window.getComputedStyle(header)
        setNavStyles({
          position: styles.position,
          top: styles.top,
          display: styles.display,
          visibility: styles.visibility,
          opacity: styles.opacity,
          zIndex: styles.zIndex,
          height: styles.height,
          backgroundColor: styles.backgroundColor
        })
        
        // 强制显示
        if (header instanceof HTMLElement) {
          header.style.cssText = 'position:fixed!important;top:0!important;left:0!important;right:0!important;width:100%!important;height:64px!important;background-color:red!important;z-index:99999!important;display:flex!important;align-items:center!important;visibility:visible!important;opacity:1!important;border-bottom:2px solid #000000!important;'
        }
      } else {
        setNavExists(false)
      }
    }
    
    checkNav()
    setTimeout(checkNav, 100)
    setTimeout(checkNav, 500)
  }, [])

  return (
    <div style={{ paddingTop: '80px', padding: '20px' }}>
      <h1>导航栏调试页面</h1>
      
      <div style={{ marginTop: '20px', padding: '20px', backgroundColor: '#f0f0f0', borderRadius: '8px' }}>
        <h2>检查结果：</h2>
        <p>导航栏元素存在: {navExists ? '✅ 是' : '❌ 否'}</p>
        
        {navStyles && (
          <div style={{ marginTop: '10px' }}>
            <h3>当前样式：</h3>
            <pre style={{ backgroundColor: '#fff', padding: '10px', overflow: 'auto' }}>
              {JSON.stringify(navStyles, null, 2)}
            </pre>
          </div>
        )}
        
        <div style={{ marginTop: '20px' }}>
          <h3>操作：</h3>
          <button
            onClick={() => {
              const header = document.querySelector('#main-nav-header') || document.querySelector('header')
              if (header && header instanceof HTMLElement) {
                header.style.cssText = 'position:fixed!important;top:0!important;left:0!important;right:0!important;width:100%!important;height:64px!important;background-color:red!important;z-index:99999!important;display:flex!important;align-items:center!important;visibility:visible!important;opacity:1!important;border-bottom:2px solid #000000!important;'
                alert('导航栏已强制显示为红色！请查看页面顶部。')
              } else {
                alert('找不到导航栏元素！')
              }
            }}
            style={{ padding: '10px 20px', backgroundColor: '#000', color: '#fff', border: 'none', cursor: 'pointer' }}
          >
            强制显示导航栏（红色背景）
          </button>
        </div>
      </div>
      
      <div style={{ marginTop: '20px', padding: '20px', backgroundColor: '#fff3cd', borderRadius: '8px' }}>
        <h3>说明：</h3>
        <p>如果导航栏元素存在但看不到，可能是：</p>
        <ul>
          <li>被其他元素遮挡（z-index 问题）</li>
          <li>样式被覆盖</li>
          <li>位置不对（可能在页面下方）</li>
        </ul>
        <p>点击上面的按钮可以强制显示导航栏（红色背景）。</p>
      </div>
      
      <Nav />
    </div>
  )
}

