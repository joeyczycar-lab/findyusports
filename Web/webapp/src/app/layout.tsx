import './globals.css'
import { ReactNode } from 'react'
import Link from 'next/link'
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
            /* Hero 背景图片 - 强制显示（生产环境） */
            section:first-of-type {
              background-color: transparent !important;
            }
            .hero-bg-image {
              position: absolute !important;
              top: 0 !important;
              left: 0 !important;
              right: 0 !important;
              bottom: 0 !important;
              width: 100% !important;
              height: 100% !important;
              background-image: url('/hero-background.jpg') !important;
              background-size: cover !important;
              background-position: center !important;
              background-repeat: no-repeat !important;
              z-index: 0 !important;
              opacity: 1 !important;
              visibility: visible !important;
              display: block !important;
              pointer-events: none !important;
            }
          `
        }} />
        <script
          dangerouslySetInnerHTML={{
            __html: `
              // 在页面加载前就创建导航栏 - 最激进方案
              (function() {
                if (typeof document !== 'undefined') {
                  // 创建最高优先级的样式
                  const style = document.createElement('style');
                  style.id = 'nav-force-visible';
                  style.textContent = 'header#main-nav-header{position:fixed!important;top:0!important;left:0!important;right:0!important;width:100%!important;height:64px!important;max-height:64px!important;min-height:64px!important;z-index:999999!important;display:flex!important;align-items:center!important;visibility:visible!important;opacity:1!important;background-color:#ffffff!important;border-bottom:2px solid #000000!important;box-shadow:0 4px 6px rgba(0,0,0,0.1)!important;margin:0!important;padding:0!important;overflow:visible!important;pointer-events:auto!important;}header#main-nav-header a[href="/admin/add-venue"],header#main-nav-header a[href="/admin/add-venue"]:link,header#main-nav-header a[href="/admin/add-venue"]:visited,header#main-nav-header a[href="/admin/add-venue"]:hover,header#main-nav-header a[href="/admin/add-venue"]:focus,header#main-nav-header a[href="/admin/add-venue"]:active{background-color:#000000!important;color:#ffffff!important;display:inline-flex!important;visibility:visible!important;opacity:1!important;text-decoration:none!important;padding:8px 16px!important;font-weight:bold!important;border-radius:2px!important;-webkit-border-radius:2px!important;-moz-border-radius:2px!important;cursor:pointer!important;pointer-events:auto!important;}header#main-nav-header a,header#main-nav-header a:link,header#main-nav-header a:visited,header#main-nav-header button{border-radius:2px!important;-webkit-border-radius:2px!important;-moz-border-radius:2px!important;visibility:visible!important;opacity:1!important;pointer-events:auto!important;}header#main-nav-header *{visibility:visible!important;opacity:1!important;pointer-events:auto!important;}';
                  document.head.insertBefore(style, document.head.firstChild);
                  
                  // 如果导航栏不存在，直接创建它
                  function createNavIfMissing() {
                    let header = document.querySelector('#main-nav-header');
                    if (!header) {
                      header = document.createElement('header');
                      header.id = 'main-nav-header';
                      // 使用普通链接，避免Next.js路由问题
                      // 创建导航栏内容，使用正确的链接
                      const navContent = document.createElement('div');
                      navContent.style.cssText = 'display:flex;align-items:center;justify-content:space-between;width:100%;max-width:1280px;margin:0 auto;padding:0 1rem;height:100%;';
                      
                      const logo = document.createElement('a');
                      logo.href = '/';
                      logo.textContent = '场地发现';
                      logo.style.cssText = 'font-weight:bold;font-size:20px;color:#000000;text-decoration:none;';
                      
                      const rightDiv = document.createElement('div');
                      rightDiv.style.cssText = 'display:flex;align-items:center;gap:1rem;';
                      
                      const addBtn = document.createElement('a');
                      addBtn.href = '/admin/add-venue';
                      addBtn.textContent = '➕ 添加场地';
                      addBtn.style.cssText = 'background-color:#000000;color:#ffffff;padding:8px 16px;text-decoration:none;font-weight:bold;border-radius:2px;display:inline-flex;align-items:center;cursor:pointer;';
                      
                      const mapLink = document.createElement('a');
                      mapLink.href = '/map';
                      mapLink.textContent = '地图探索';
                      mapLink.style.cssText = 'color:#000000;text-decoration:none;font-weight:500;text-transform:uppercase;font-size:14px;letter-spacing:0.05em;cursor:pointer;';
                      
                      rightDiv.appendChild(addBtn);
                      rightDiv.appendChild(mapLink);
                      navContent.appendChild(logo);
                      navContent.appendChild(rightDiv);
                      header.appendChild(navContent);
                      document.body.insertBefore(header, document.body.firstChild);
                    }
                    return header;
                  }
                  
                  function ensureNavVisible() {
                    const header = createNavIfMissing();
                    if (header && header instanceof HTMLElement) {
                      // 强制设置导航栏样式
                      header.style.setProperty('position', 'fixed', 'important');
                      header.style.setProperty('top', '0', 'important');
                      header.style.setProperty('left', '0', 'important');
                      header.style.setProperty('right', '0', 'important');
                      header.style.setProperty('width', '100%', 'important');
                      header.style.setProperty('height', '64px', 'important');
                      header.style.setProperty('z-index', '999999', 'important');
                      header.style.setProperty('display', 'flex', 'important');
                      header.style.setProperty('align-items', 'center', 'important');
                      header.style.setProperty('visibility', 'visible', 'important');
                      header.style.setProperty('opacity', '1', 'important');
                      header.style.setProperty('background-color', '#ffffff', 'important');
                      header.style.setProperty('border-bottom', '2px solid #000000', 'important');
                      header.style.setProperty('box-shadow', '0 4px 6px rgba(0,0,0,0.1)', 'important');
                      header.style.setProperty('margin', '0', 'important');
                      header.style.setProperty('padding', '0', 'important');
                      
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
                    }
                  }
                  
                  // 立即执行（在body存在之前就尝试）
                  if (document.body) {
                    ensureNavVisible();
                  } else {
                    // 如果body还不存在，等待它
                    const observer = new MutationObserver(function(mutations, obs) {
                      if (document.body) {
                        ensureNavVisible();
                        obs.disconnect();
                      }
                    });
                    observer.observe(document.documentElement, { childList: true, subtree: true });
                  }
                  
                  // 页面加载后立即执行
                  if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', ensureNavVisible);
                  } else {
                    ensureNavVisible();
                  }
                  
                  // 持续监控并修复（每200ms检查一次）
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
                  if (document.body) {
                    observer.observe(document.body, { childList: true, subtree: true });
                  }
                }
              })();
            `,
          }}
        />
      </head>
      <body style={{ margin: 0, padding: 0, paddingTop: 0 }}>
        <Nav />
        {children}
      </body>
    </html>
  )
}


