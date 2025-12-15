'use client'

import { useEffect } from 'react'

export default function ForceNavPage() {
  useEffect(() => {
    // 强制显示导航栏和按钮
    const forceShow = () => {
      const header = document.querySelector('#main-nav-header') || document.querySelector('header')
      if (header && header instanceof HTMLElement) {
        // 强制导航栏样式
        header.style.cssText = 'position:fixed!important;top:0!important;left:0!important;right:0!important;width:100%!important;height:64px!important;background-color:#ff0000!important;z-index:99999!important;display:flex!important;align-items:center!important;visibility:visible!important;opacity:1!important;border-bottom:2px solid #000000!important;box-shadow:0 4px 6px rgba(0,0,0,0.1)!important;padding:0 1rem!important;'
        
        // 强制按钮样式
        const button = header.querySelector('a[href="/admin/add-venue"]')
        if (button && button instanceof HTMLElement) {
          button.style.cssText = 'background-color:#000000!important;color:#ffffff!important;display:inline-flex!important;visibility:visible!important;opacity:1!important;text-decoration:none!important;padding:8px 16px!important;font-weight:bold!important;border-radius:2px!important;margin-left:auto!important;'
        }
        
        console.log('✅ 导航栏已强制显示为红色')
        console.log('按钮:', button ? '找到' : '未找到')
      } else {
        console.log('❌ 找不到导航栏元素')
      }
    }
    
    forceShow()
    const interval = setInterval(forceShow, 200)
    
    return () => clearInterval(interval)
  }, [])

  return (
    <div style={{ paddingTop: '80px', padding: '20px' }}>
      <h1>强制显示导航栏测试</h1>
      <p>如果导航栏是红色的，说明脚本正在工作。</p>
      <p>如果看不到，请检查浏览器控制台（F12）。</p>
      <div style={{ marginTop: '20px', padding: '20px', backgroundColor: '#f0f0f0' }}>
        <h2>调试信息：</h2>
        <p>打开浏览器控制台（F12）查看日志。</p>
        <button
          onClick={() => {
            const header = document.querySelector('#main-nav-header')
            if (header && header instanceof HTMLElement) {
              const rect = header.getBoundingClientRect()
              alert(`导航栏位置:\nTop: ${rect.top}\nLeft: ${rect.left}\nWidth: ${rect.width}\nHeight: ${rect.height}\n可见: ${rect.top >= 0 && rect.top < window.innerHeight}`)
            } else {
              alert('找不到导航栏元素')
            }
          }}
          style={{ padding: '10px 20px', backgroundColor: '#000', color: '#fff', border: 'none', cursor: 'pointer', marginTop: '10px' }}
        >
          检查导航栏位置
        </button>
      </div>
    </div>
  )
}

