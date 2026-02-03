/**
 * 上传前压缩图片，减小体积、避免 fetch failed（Vercel 等有 body 限制）。
 * 最大边长 1920px，质量 0.85；若仍 > 2MB 则二次压缩到 1280px、0.6，目标单张 < 2MB。
 */
const MAX_DIMENSION = 1920
const JPEG_QUALITY = 0.85
const COMPRESS_IF_LARGER_THAN_BYTES = 300 * 1024 // 300KB 以上就压缩
const TARGET_MAX_BYTES = 2 * 1024 * 1024 // 2MB，超过则二次压缩
const FALLBACK_DIMENSION = 1280
const FALLBACK_QUALITY = 0.6

function drawToBlob(
  img: HTMLImageElement,
  maxDim: number,
  quality: number
): Promise<Blob | null> {
  return new Promise((resolve) => {
    const { width, height } = img
    let w = width
    let h = height
    if (w > maxDim || h > maxDim) {
      if (w > h) {
        h = Math.round((h * maxDim) / w)
        w = maxDim
      } else {
        w = Math.round((w * maxDim) / h)
        h = maxDim
      }
    }
    const canvas = document.createElement('canvas')
    canvas.width = w
    canvas.height = h
    const ctx = canvas.getContext('2d')
    if (!ctx) {
      resolve(null)
      return
    }
    ctx.drawImage(img, 0, 0, w, h)
    canvas.toBlob((blob) => resolve(blob), 'image/jpeg', quality)
  })
}

export function compressImageForUpload(file: File): Promise<File> {
  if (!file.type.startsWith('image/')) return Promise.resolve(file)
  if (file.size <= COMPRESS_IF_LARGER_THAN_BYTES) return Promise.resolve(file)

  return new Promise((resolve, reject) => {
    const img = new Image()
    const url = URL.createObjectURL(file)
    img.onload = async () => {
      URL.revokeObjectURL(url)
      let blob = await drawToBlob(img, MAX_DIMENSION, JPEG_QUALITY)
      if (!blob) {
        resolve(file)
        return
      }
      // 若仍超过 2MB，二次压缩以降低 fetch failed 概率
      if (blob.size > TARGET_MAX_BYTES) {
        const smaller = await drawToBlob(img, FALLBACK_DIMENSION, FALLBACK_QUALITY)
        if (smaller && smaller.size < blob.size) blob = smaller
      }
      const name = file.name.replace(/\.[^.]+$/, '.jpg')
      resolve(new File([blob], name, { type: 'image/jpeg' }))
    }
    img.onerror = () => {
      URL.revokeObjectURL(url)
      resolve(file)
    }
    img.src = url
  })
}
