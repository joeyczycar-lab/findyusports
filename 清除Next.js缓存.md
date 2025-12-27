# 清除 Next.js 缓存解决页面无法加载问题

## 问题症状
- 页面显示 500 错误
- 错误信息：`Cannot find module './682.js'` 或类似
- 页面无法正常加载

## 解决方案

### 方法 1: 清除缓存并重启（推荐）

```bash
cd Web/webapp

# 1. 停止前端服务（在运行前端的终端按 Ctrl+C）

# 2. 清除 Next.js 缓存
rm -rf .next

# 3. 重新启动前端服务
npm run dev
```

### 方法 2: 使用脚本

```bash
cd /Users/Zhuanz/Documents/findyusports/Web/webapp
rm -rf .next && npm run dev
```

## 为什么会出现这个问题？

Next.js 在开发模式下会缓存编译结果以提高性能。但有时：
- 代码更改后缓存没有正确更新
- 模块依赖关系发生变化
- 构建过程中断导致缓存损坏

清除 `.next` 目录可以强制 Next.js 重新编译所有页面。

## 预防措施

如果经常遇到这个问题，可以：
1. 定期清除缓存（特别是在大量代码更改后）
2. 确保正常停止服务（使用 Ctrl+C 而不是强制终止）
3. 检查是否有语法错误或导入错误

