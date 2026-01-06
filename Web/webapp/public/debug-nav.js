// 导航栏调试工具 - 等待元素加载后再查找
(function() {
  console.log('🔍 开始查找导航栏元素...');
  
  // 方法1: 直接查找
  function findNav() {
    const selectors = [
      '#main-nav-header',
      'header#main-nav-header',
      'header[id="main-nav-header"]',
      'header',
      '[id*="nav"]',
      '[id*="header"]'
    ];
    
    for (const selector of selectors) {
      const element = document.querySelector(selector);
      if (element) {
        console.log(`✅ 找到元素 (使用选择器: ${selector}):`, element);
        console.log('元素ID:', element.id);
        console.log('元素标签:', element.tagName);
        console.log('元素类名:', element.className);
        return element;
      }
    }
    
    console.log('❌ 使用所有选择器都找不到导航栏元素');
    return null;
  }
  
  // 方法2: 等待DOM加载完成
  function waitForNav(callback, maxAttempts = 20) {
    let attempts = 0;
    const interval = setInterval(() => {
      attempts++;
      const nav = findNav();
      if (nav) {
        clearInterval(interval);
        callback(nav);
      } else if (attempts >= maxAttempts) {
        clearInterval(interval);
        console.error('❌ 等待超时，找不到导航栏元素');
        console.log('当前页面所有header元素:', document.querySelectorAll('header'));
        console.log('当前页面所有带id的元素:', Array.from(document.querySelectorAll('[id]')).map(el => el.id));
      }
    }, 100);
  }
  
  // 立即尝试
  const nav = findNav();
  if (nav) {
    const styles = window.getComputedStyle(nav);
    console.log('导航栏样式:');
    console.log('  position:', styles.position);
    console.log('  z-index:', styles.zIndex);
    console.log('  display:', styles.display);
    console.log('  visibility:', styles.visibility);
    console.log('  opacity:', styles.opacity);
    console.log('  top:', styles.top);
    console.log('  height:', styles.height);
    
    // 检查按钮
    const button = nav.querySelector('a[href="/admin/add-venue"]');
    if (button) {
      console.log('✅ 找到"添加场地"按钮:', button);
    } else {
      console.log('❌ 找不到"添加场地"按钮');
      console.log('导航栏内所有链接:', Array.from(nav.querySelectorAll('a')).map(a => a.href));
    }
  } else {
    console.log('⏳ 等待元素加载...');
    waitForNav((nav) => {
      console.log('✅ 导航栏已找到:', nav);
    });
  }
})();


























