/** @type {import('next').NextConfig} */
const nextConfig = {
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


