import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: '隐私政策 - FY体育',
  description: 'FY体育隐私政策',
}

export default function PrivacyPage() {
  return (
    <main className="container-page py-12">
      <h1 className="text-2xl font-bold mb-4">隐私政策</h1>
      <p className="text-gray-600">本页面为占位，后续可补充完整隐私政策内容。</p>
    </main>
  )
}
