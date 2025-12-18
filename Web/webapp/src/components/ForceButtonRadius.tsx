'use client'

import { useEffect } from 'react'

export default function ForceButtonRadius() {
  useEffect(() => {
    // 强制所有按钮使用 2px 圆角 - 最高优先级
    const fixRadius = () => {
      // 更全面的选择器
      const allSelectors = [
        '.btn-primary', 
        '.btn-secondary',
        'button:not(.rounded-full)',
        'a.btn-primary',
        'a.btn-secondary',
        'a[class*="btn"]:not(.rounded-full)',
        'a[href="/map"]', 
        'a[href*="/map"]',
        'a[href="/admin/add-venue"]',
        '[type="button"]', 
        '[type="submit"]',
        '[type="reset"]'
      ]
      
      allSelectors.forEach(selector => {
        try {
          const elements = document.querySelectorAll(selector)
          elements.forEach((el: Element) => {
            if (el instanceof HTMLElement) {
              // 强制设置内联样式，优先级最高
              el.style.setProperty('border-radius', '4px', 'important')
              el.style.setProperty('-webkit-border-radius', '4px', 'important')
              el.style.setProperty('-moz-border-radius', '4px', 'important')
            }
          })
        } catch (e) {
          // 忽略选择器错误
        }
      })
    }
    
    // 创建全局样式 - 插入到最前面确保优先级
    let style = document.getElementById('force-button-radius-global') as HTMLStyleElement
    if (!style) {
      style = document.createElement('style')
      style.id = 'force-button-radius-global'
      style.textContent = `
        /* 强制所有按钮和链接按钮使用 2px 圆角 - 最高优先级 */
        .btn-primary, .btn-primary:link, .btn-primary:visited, .btn-primary:hover, .btn-primary:focus, .btn-primary:active,
        .btn-secondary, .btn-secondary:link, .btn-secondary:visited, .btn-secondary:hover, .btn-secondary:focus, .btn-secondary:active,
        button:not(.rounded-full), button:not(.rounded-full):hover, button:not(.rounded-full):focus, button:not(.rounded-full):active,
        a[class*="btn"]:not(.rounded-full), a[class*="btn"]:not(.rounded-full):hover, a[class*="btn"]:not(.rounded-full):focus,
        a[href="/map"], a[href="/map"]:hover, a[href="/map"]:focus,
        a[href*="/map"], a[href*="/map"]:hover,
        a[href="/admin/add-venue"], a[href="/admin/add-venue"]:hover, a[href="/admin/add-venue"]:focus,
        [type="button"], [type="button"]:hover, [type="submit"], [type="submit"]:hover, [type="reset"] {
          border-radius: 4px !important;
          -webkit-border-radius: 4px !important;
          -moz-border-radius: 4px !important;
        }
      `
      document.head.insertBefore(style, document.head.firstChild)
    }
    
    // 立即执行多次，确保覆盖
    fixRadius()
    setTimeout(fixRadius, 0)
    setTimeout(fixRadius, 50)
    setTimeout(fixRadius, 100)
    setTimeout(fixRadius, 200)
    setTimeout(fixRadius, 500)
    setTimeout(fixRadius, 1000)
    
    // 持续监控 - 更频繁
    const interval = setInterval(fixRadius, 50)
    
    // 监听 DOM 变化
    const observer = new MutationObserver(() => {
      setTimeout(fixRadius, 0)
    })
    if (document.body) {
      observer.observe(document.body, { 
        childList: true, 
        subtree: true, 
        attributes: true,
        attributeFilter: ['class', 'style']
      })
    }
    
    return () => {
      clearInterval(interval)
      observer.disconnect()
    }
  }, [])
  
  return null
}


