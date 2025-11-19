export default function Reviews({ items }: { items: Array<{ id: number|string; rating: number; content: string; createdAt?: string }> }) {
  if (!items || items.length === 0) return <div className="text-textMuted text-sm">还没有点评</div>
  return (
    <div className="space-y-4">
      {items.map(r => (
        <div key={r.id} className="text-sm">
          <div className="font-medium">评分 {r.rating}分 <span className="text-textMuted">{r.createdAt ? new Date(r.createdAt).toLocaleDateString() : ''}</span></div>
          <div className="text-textSecondary">{r.content}</div>
        </div>
      ))}
    </div>
  )
}


