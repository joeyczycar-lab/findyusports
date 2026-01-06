import { redirect } from 'next/navigation'

export default function VenuesPage() {
  // 重定向到地图探索页面（显示所有场地）
  redirect('/map')
}


