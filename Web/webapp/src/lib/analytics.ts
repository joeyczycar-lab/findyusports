/**
 * 页面访问统计工具
 */

// 记录页面访问
export async function recordPageView(path: string, pageType?: string) {
  try {
    // 获取来源页面
    const referer = typeof document !== 'undefined' ? document.referrer : undefined
    
    await fetch('/api/analytics/page-view', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        path,
        pageType,
        referer,
      }),
      // 不等待响应，避免阻塞页面加载
      keepalive: true,
    })
  } catch (error) {
    // 静默失败，不影响用户体验
    console.debug('Failed to record page view:', error)
  }
}

// 获取页面类型
export function getPageType(pathname: string): string | undefined {
  if (pathname === '/') return 'home'
  if (pathname === '/map') return 'map'
  if (pathname.startsWith('/venues/')) return 'venue'
  if (pathname.startsWith('/admin/')) return 'admin'
  return undefined
}

