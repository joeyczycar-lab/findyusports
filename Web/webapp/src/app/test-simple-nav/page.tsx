'use client'

import { useEffect } from 'react'

export default function TestSimpleNavPage() {
  useEffect(() => {
    // 强制检查并显示导航栏
    const checkNav = () => {
      const header = document.querySelector('#main-nav-header')
      console.log('导航栏元素:', header)
      if (header) {
        const styles = window.getComputedStyle(header)
        console.log('导航栏样式:')
        console.log('  position:', styles.position)
        console.log('  display:', styles.display)
        console.log('  visibility:', styles.visibility)
        console.log('  opacity:', styles.opacity)
        console.log('  z-index:', styles.zIndex)
        console.log('  top:', styles.top)
        console.log('  height:', styles.height)
        
        const rect = header.getBoundingClientRect()
        console.log('导航栏位置:')
        console.log('  top:', rect.top)
        console.log('  left:', rect.left)
        console.log('  width:', rect.width)
        console.log('  height:', rect.height)
        console.log('  是否在视口中:', rect.top >= 0 && rect.top < window.innerHeight)
      } else {
        console.error('❌ 找不到导航栏元素 #main-nav-header')
      }
      
      // 检查按钮
      const button = document.querySelector('a[href="/admin/add-venue"]')
      console.log('添加场地按钮:', button)
      if (button) {
        const btnStyles = window.getComputedStyle(button)
        console.log('按钮样式:')
        console.log('  display:', btnStyles.display)
        console.log('  visibility:', btnStyles.visibility)
        console.log('  opacity:', btnStyles.opacity)
        console.log('  backgroundColor:', btnStyles.backgroundColor)
      }
    }
    
    checkNav()
    setTimeout(checkNav, 500)
    setTimeout(checkNav, 1000)
  }, [])

  return (
    <div style={{ paddingTop: '80px', padding: '20px' }}>
      <h1>简单导航栏测试</h1>
      <p>请打开浏览器控制台（F12）查看调试信息。</p>
      <div style={{ marginTop: '20px', padding: '20px', backgroundColor: '#f0f0f0' }}>
        <h2>检查清单：</h2>
        <ol>
          <li>导航栏应该在页面顶部（白色背景，黑色边框）</li>
          <li>应该能看到"场地发现"文字</li>
          <li>应该能看到"➕ 添加场地"按钮（黑色背景，白色文字）</li>
          <li>如果看不到，请查看控制台输出</li>
        </ol>
      </div>
      <div style={{ marginTop: '20px' }}>
        <button
          onClick={() => {
            const header = document.querySelector('#main-nav-header')
            if (header && header instanceof HTMLElement) {
              // 强制设置为红色以便调试
              header.style.cssText = 'position:fixed!important;top:0!important;left:0!important;right:0!important;width:100%!important;height:64px!important;background-color:red!important;z-index:99999!important;display:flex!important;align-items:center!important;visibility:visible!important;opacity:1!important;border-bottom:2px solid #000000!important;padding:0 1rem!important;'
              alert('导航栏已强制设置为红色！请查看页面顶部。')
            } else {
              alert('找不到导航栏元素！')
            }
          }}
          style={{ padding: '10px 20px', backgroundColor: '#000', color: '#fff', border: 'none', cursor: 'pointer' }}
        >
          强制显示红色导航栏
        </button>
      </div>
    </div>
  )
}









