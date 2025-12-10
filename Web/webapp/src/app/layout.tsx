import './globals.css'
import { ReactNode } from 'react'
import Nav from '@/components/Nav'

export const metadata = {
  title: '运动场地分享 | 篮球·足球',
  description: '分享与发现中国各地的篮球、足球场地，地图导航、点评与上传',
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="zh-CN">
      <head>
        <style dangerouslySetInnerHTML={{
          __html: `
            header#main-nav-header {
              position: fixed !important;
              top: 0 !important;
              left: 0 !important;
              right: 0 !important;
              width: 100% !important;
              height: 64px !important;
              max-height: 64px !important;
              min-height: 64px !important;
              display: flex !important;
              align-items: center !important;
              background-color: #ffffff !important;
              border-bottom: 2px solid #000000 !important;
              box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1) !important;
              z-index: 999999 !important;
              overflow: visible !important;
              margin: 0 !important;
              padding: 0 !important;
              visibility: visible !important;
              opacity: 1 !important;
              pointer-events: auto !important;
            }
          `
        }} />
        <script
          dangerouslySetInnerHTML={{
            __html: `
              // 在页面加载前就确保导航栏样式 - 增强版
              (function() {
                if (typeof document !== 'undefined') {
                  // 创建最高优先级的样式
                  const style = document.createElement('style');
                  style.id = 'nav-force-visible';
                  style.textContent = 'header#main-nav-header{position:fixed!important;top:0!important;left:0!important;right:0!important;width:100%!important;height:64px!important;max-height:64px!important;min-height:64px!important;z-index:999999!important;display:flex!important;align-items:center!important;visibility:visible!important;opacity:1!important;background-color:#ffffff!important;border-bottom:2px solid #000000!important;box-shadow:0 4px 6px rgba(0,0,0,0.1)!important;margin:0!important;padding:0 1rem!important;overflow:visible!important;pointer-events:auto!important;}header#main-nav-header a[href="/admin/add-venue"]{background-color:#000000!important;color:#ffffff!important;display:inline-flex!important;visibility:visible!important;opacity:1!important;text-decoration:none!important;padding:8px 16px!important;font-weight:bold!important;border-radius:2px!important;cursor:pointer!important;pointer-events:auto!important;}header#main-nav-header *{visibility:visible!important;opacity:1!important;pointer-events:auto!important;}';
                  document.head.insertBefore(style, document.head.firstChild);
                  
                  function ensureNavVisible() {
                    const header = document.querySelector('#main-nav-header') || document.querySelector('header');
                    if (header && header instanceof HTMLElement) {
                      // 强制设置导航栏样式
                      header.style.setProperty('position', 'fixed', 'important');
                      header.style.setProperty('top', '0', 'important');
                      header.style.setProperty('left', '0', 'important');
                      header.style.setProperty('right', '0', 'important');
                      header.style.setProperty('width', '100%', 'important');
                      header.style.setProperty('height', '64px', 'important');
                      header.style.setProperty('z-index', '99999', 'important');
                      header.style.setProperty('display', 'flex', 'important');
                      header.style.setProperty('align-items', 'center', 'important');
                      header.style.setProperty('visibility', 'visible', 'important');
                      header.style.setProperty('opacity', '1', 'important');
                      header.style.setProperty('background-color', '#ffffff', 'important');
                      header.style.setProperty('border-bottom', '2px solid #000000', 'important');
                      header.style.setProperty('box-shadow', '0 4px 6px rgba(0,0,0,0.1)', 'important');
                      header.style.setProperty('margin', '0', 'important');
                      header.style.setProperty('padding', '0 1rem', 'important');
                      
                      // 强制设置按钮样式
                      const button = header.querySelector('a[href="/admin/add-venue"]');
                      if (button && button instanceof HTMLElement) {
                        button.style.setProperty('background-color', '#000000', 'important');
                        button.style.setProperty('color', '#ffffff', 'important');
                        button.style.setProperty('display', 'inline-flex', 'important');
                        button.style.setProperty('visibility', 'visible', 'important');
                        button.style.setProperty('opacity', '1', 'important');
                        button.style.setProperty('text-decoration', 'none', 'important');
                        button.style.setProperty('padding', '8px 16px', 'important');
                        button.style.setProperty('font-weight', 'bold', 'important');
                        button.style.setProperty('border-radius', '2px', 'important');
                        button.style.setProperty('cursor', 'pointer', 'important');
                      }
                      
                      // 确保所有子元素可见
                      const children = header.querySelectorAll('*');
                      children.forEach(child => {
                        if (child instanceof HTMLElement) {
                          child.style.setProperty('visibility', 'visible', 'important');
                          child.style.setProperty('opacity', '1', 'important');
                        }
                      });
                    }
                  }
                  
                  // 页面加载后立即执行
                  if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', ensureNavVisible);
                  } else {
                    ensureNavVisible();
                  }
                  
                  // 持续监控并修复（每200ms检查一次，更频繁）
                  setInterval(ensureNavVisible, 200);
                  
                  // 多个延迟执行，确保React已完全渲染
                  setTimeout(ensureNavVisible, 50);
                  setTimeout(ensureNavVisible, 100);
                  setTimeout(ensureNavVisible, 200);
                  setTimeout(ensureNavVisible, 500);
                  setTimeout(ensureNavVisible, 1000);
                  setTimeout(ensureNavVisible, 2000);
                  
                  // 监听DOM变化
                  const observer = new MutationObserver(ensureNavVisible);
                  observer.observe(document.body, { childList: true, subtree: true });
                }
              })();
            `,
          }}
        />
      </head>
      <body style={{ margin: 0, padding: 0, paddingTop: 0 }}>
        {/* 后备导航栏 - 确保即使Nav组件未加载也能显示 */}
        <noscript>
          <header id="main-nav-header" style={{
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            width: '100%',
            height: '64px',
            display: 'flex',
            alignItems: 'center',
            backgroundColor: '#ffffff',
            borderBottom: '2px solid #000000',
            zIndex: 999999,
            padding: '0 1rem'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%', maxWidth: '1280px', margin: '0 auto' }}>
              <span style={{ fontWeight: 'bold', fontSize: '20px', color: '#000000' }}>场地发现</span>
              <a href="/admin/add-venue" style={{
                backgroundColor: '#000000',
                color: '#ffffff',
                padding: '8px 16px',
                textDecoration: 'none',
                fontWeight: 'bold',
                borderRadius: '2px'
              }}>➕ 添加场地</a>
            </div>
          </header>
        </noscript>
        <Nav />
        {children}
      </body>
    </html>
  )
}


