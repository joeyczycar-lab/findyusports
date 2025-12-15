# 导航栏调试指南

## 在浏览器控制台中执行以下命令：

### 1. 检查导航栏元素是否存在
```javascript
document.querySelector('header')
```

### 2. 检查导航栏的样式
```javascript
const header = document.querySelector('header');
if (header) {
  console.log('导航栏存在');
  console.log('计算后的样式:', window.getComputedStyle(header));
  console.log('位置:', header.getBoundingClientRect());
} else {
  console.log('导航栏不存在！');
}
```

### 3. 临时让导航栏可见（测试用）
```javascript
const header = document.querySelector('header');
if (header) {
  header.style.backgroundColor = 'red';
  header.style.zIndex = '99999';
  header.style.position = 'fixed';
  header.style.top = '0';
  header.style.left = '0';
  header.style.right = '0';
  header.style.width = '100%';
  header.style.display = 'block';
  header.style.visibility = 'visible';
  header.style.opacity = '1';
}
```

### 4. 检查是否有其他元素覆盖导航栏
```javascript
const header = document.querySelector('header');
if (header) {
  const rect = header.getBoundingClientRect();
  const elementAtTop = document.elementFromPoint(rect.left + rect.width/2, 0);
  console.log('页面顶部元素:', elementAtTop);
  console.log('是否为导航栏:', elementAtTop === header || header.contains(elementAtTop));
}
```

### 5. 检查所有 header 元素
```javascript
document.querySelectorAll('header')
```

### 6. 检查 body 的第一个子元素
```javascript
document.body.firstElementChild
```



