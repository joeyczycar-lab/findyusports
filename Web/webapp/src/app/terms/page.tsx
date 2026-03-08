import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: '使用条款 - FY体育',
  description: 'FY体育网站使用条款',
}

export default function TermsPage() {
  return (
    <main className="container-page py-12">
      <h1 className="text-2xl font-bold mb-4">使用条款</h1>
      <p className="text-gray-600">本页面为占位，后续可补充完整使用条款内容。</p>
    </main>
  )
}
