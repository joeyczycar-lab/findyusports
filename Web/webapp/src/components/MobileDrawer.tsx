"use client"
import { useEffect } from 'react'

type Props = {
  open: boolean
  onClose: () => void
  children: React.ReactNode
}

export default function MobileDrawer({ open, onClose, children }: Props) {
  useEffect(() => {
    if (open) document.body.style.overflow = 'hidden'
    return () => { document.body.style.overflow = '' }
  }, [open])

  return (
    <>
      <div
        className={`fixed inset-0 bg-black/30 transition-opacity lg:hidden ${open ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'}`}
        onClick={onClose}
      />
      <div
        className={`fixed left-0 right-0 bottom-0 bg-white border-t border-border shadow-md lg:hidden transition-transform ${open ? 'translate-y-0' : 'translate-y-full'}`}
        style={{ 
          minHeight: open ? '40vh' : undefined,
          borderTopLeftRadius: '2px',
          borderTopRightRadius: '2px'
        }}
      >
        <div className="mx-auto w-12 h-1.5 bg-gray-300 rounded-full my-2" />
        <div className="p-3">
          {children}
        </div>
      </div>
    </>
  )
}


