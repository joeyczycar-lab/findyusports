export default function Reviews({ items }: { items: Array<{ id: number|string; rating: number; content: string; createdAt?: string }> }) {
  if (!items || items.length === 0) return <div className="text-textSecondary text-body-sm uppercase tracking-wide">还没有点评</div>
  return (
    <div className="space-y-6">
      {items.map(r => (
        <div key={r.id} className="border-t border-border pt-6 first:border-t-0 first:pt-0">
          <div className="font-bold text-heading-sm mb-2">
            评分 {r.rating} 分
            {r.createdAt && (
              <span className="text-textSecondary text-body-sm font-normal ml-3 uppercase tracking-wide">
                {new Date(r.createdAt).toLocaleDateString()}
              </span>
            )}
          </div>
          <div className="text-body text-textSecondary leading-relaxed">{r.content}</div>
        </div>
      ))}
    </div>
  )
}


