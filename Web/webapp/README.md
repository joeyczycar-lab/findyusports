# 前端（Web）

基于 Next.js + TypeScript + Tailwind 的前端骨架。

## 本地开发

1. 安装依赖
```bash
npm install
```

2. 启动开发服务器
```bash
npm run dev
```

3. 访问
```
http://localhost:3000
```

## 环境变量
- 复制 `.env.local.example` 为 `.env.local` 并填写：
```
NEXT_PUBLIC_AMAP_KEY=你的高德Web JS API Key
NEXT_PUBLIC_API_BASE=http://localhost:4000
# 可选：滚动联动阈值（毫秒）
NEXT_PUBLIC_SCROLL_THROTTLE_MS=300
NEXT_PUBLIC_SCROLL_SUPPRESS_MS=800
```

## 目录结构
- src/app：App Router 页面
- src/components：通用组件
- tailwind.config.ts：接入设计令牌

## /map 调试参数
- URL 参数（优先级高于环境变量）：
  - scrollThrottleMs=数字（自动滚动节流阈值）
  - userSuppressMs=数字（用户滚动后抑制时长）
  - follow=0|1（是否开启跟随滚动）
  示例：
```
http://localhost:3000/map?scrollThrottleMs=200&userSuppressMs=1200&follow=1
```


