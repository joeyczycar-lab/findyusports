'use client'

import Link from 'next/link'

const CURRENT_YEAR = new Date().getFullYear()

export default function SiteFooter() {
  return (
    <footer className="bg-white border-t border-gray-200 mt-auto">
      {/* 上方多列链接区（仅桌面端显示，可选） */}
      <div className="container-page py-10 hidden md:block">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div>
            <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wide mb-3">快速入口</h4>
            <ul className="space-y-2 text-sm text-gray-600">
              <li><Link href="/map" className="hover:text-black transition-colors">地图探索</Link></li>
              <li><Link href="/map?sport=basketball" className="hover:text-black transition-colors">篮球场地</Link></li>
              <li><Link href="/map?sport=football" className="hover:text-black transition-colors">足球场地</Link></li>
              <li><Link href="/venues" className="hover:text-black transition-colors">场地列表</Link></li>
              <li><Link href="/admin/add-venue" className="hover:text-black transition-colors">添加场地</Link></li>
            </ul>
          </div>
          <div>
            <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wide mb-3">获得帮助</h4>
            <ul className="space-y-2 text-sm text-gray-600">
              <li><Link href="/map" className="hover:text-black transition-colors">如何搜索场地</Link></li>
              <li><Link href="/app" className="hover:text-black transition-colors">下载 APP</Link></li>
            </ul>
          </div>
          <div>
            <h4 className="text-sm font-bold text-gray-900 uppercase tracking-wide mb-3">关于 FY体育</h4>
            <p className="text-sm text-gray-600">分享与发现身边的篮球、足球场地，不辜负每一片热爱。</p>
          </div>
        </div>
      </div>

      {/* 底部状态栏（Nike 风格：版权 + 条款 + 备案） */}
      <div className="border-t border-gray-200">
        <div className="container-page py-4">
          <div className="flex flex-wrap items-center justify-between gap-x-6 gap-y-2 text-xs text-gray-500">
            <span>© {CURRENT_YEAR} FY体育 保留所有权利</span>
            <div className="flex flex-wrap items-center gap-x-4 gap-y-1">
              <Link href="/terms" className="hover:text-black transition-colors">使用条款</Link>
              <Link href="/privacy" className="hover:text-black transition-colors">隐私政策</Link>
              {/* 备案号：有则填写，无则留空或删除此行 */}
              <a
                href="https://beian.miit.gov.cn/"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-black transition-colors"
              >
                备案号
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}
