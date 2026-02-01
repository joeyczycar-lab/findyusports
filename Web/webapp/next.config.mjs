/** @type {import('next').NextConfig} */
const nextConfig = {
  // 部署后让浏览器尽快拿到新版本，避免电脑改了网页、手机端仍显示旧版（findyusports.com）
  async headers() {
    return [
      {
        source: '/',
        headers: [{ key: 'Cache-Control', value: 'public, max-age=0, must-revalidate' }],
      },
      {
        source: '/map',
        headers: [{ key: 'Cache-Control', value: 'public, max-age=0, must-revalidate' }],
      },
      {
        source: '/user',
        headers: [{ key: 'Cache-Control', value: 'public, max-age=0, must-revalidate' }],
      },
    ]
  },
  images: {
    remotePatterns: [
      { protocol: 'https', hostname: '**' },
      { protocol: 'https', hostname: '*.aliyuncs.com' },
      { protocol: 'https', hostname: 'venues-images.oss-cn-hangzhou.aliyuncs.com' }
    ],
    unoptimized: false, // 保持优化，但允许所有 HTTPS 域名
  },
  experimental: {
    optimizePackageImports: ['react']
  },
  // 修复构建错误 - 禁用严格模式检查
  typescript: {
    ignoreBuildErrors: false,
  },
  eslint: {
    ignoreDuringBuilds: false,
  },
};

export default nextConfig;


