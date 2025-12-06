import { ReactNode } from 'react'
import Nav from '@/components/Nav'

export default function AdminLayout({ children }: { children: ReactNode }) {
  return (
    <>
      <Nav />
      {children}
    </>
  )
}

