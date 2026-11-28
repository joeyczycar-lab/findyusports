/**
 * 无首图场地的分类占位图兜底。
 * 占位图为通用球类线稿，不对应任何具体场馆；真实场地照片补齐后优先使用首图。
 */
export type SportType = 'basketball' | 'football'

export function fallbackImage(sportType?: string | null): string {
  return sportType === 'football' ? '/placeholders/football.svg' : '/placeholders/basketball.svg'
}
