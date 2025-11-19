import { Injectable } from '@nestjs/common'
import * as sharp from 'sharp'
import * as crypto from 'crypto'

export interface ImageSizes {
  thumbnail: { width: 150, height: 150 }
  medium: { width: 400, height: 300 }
  large: { width: 800, height: 600 }
  original: { width?: number, height?: number }
}

@Injectable()
export class ImageProcessingService {
  private readonly sizes: ImageSizes = {
    thumbnail: { width: 150, height: 150 },
    medium: { width: 400, height: 300 },
    large: { width: 800, height: 600 },
    original: {}
  }

  async processImage(buffer: Buffer, baseKey: string, addWatermark = true): Promise<{ [key: string]: Buffer }> {
    const results: { [key: string]: Buffer } = {}
    
    try {
      // 获取原始图片信息
      const metadata = await sharp(buffer).metadata()
      const { width = 0, height = 0 } = metadata
      
      // 生成不同尺寸
      for (const [sizeName, dimensions] of Object.entries(this.sizes)) {
        if (sizeName === 'original') {
          results[sizeName] = addWatermark ? await this.addWatermark(buffer) : buffer
          continue
        }

        const { width: targetWidth, height: targetHeight } = dimensions
        
        // 计算最佳裁剪/缩放策略
        let processed = await this.resizeAndOptimize(
          buffer, 
          targetWidth, 
          targetHeight, 
          width, 
          height
        )
        
        // 添加水印（除了thumbnail尺寸）
        if (addWatermark && sizeName !== 'thumbnail') {
          processed = await this.addWatermark(processed)
        }
        
        results[sizeName] = processed
      }
      
      return results
    } catch (error) {
      throw new Error(`图片处理失败: ${error.message}`)
    }
  }

  private async resizeAndOptimize(
    buffer: Buffer, 
    targetWidth: number, 
    targetHeight: number,
    originalWidth: number,
    originalHeight: number
  ): Promise<Buffer> {
    // 计算缩放比例，保持宽高比
    const scale = Math.min(targetWidth / originalWidth, targetHeight / originalHeight)
    const newWidth = Math.round(originalWidth * scale)
    const newHeight = Math.round(originalHeight * scale)
    
    return sharp(buffer)
      .resize(newWidth, newHeight, {
        fit: 'cover',
        position: 'center'
      })
      .jpeg({ 
        quality: 85,
        progressive: true,
        mozjpeg: true
      })
      .toBuffer()
  }

  async addWatermark(buffer: Buffer, text: string = '场地分享'): Promise<Buffer> {
    try {
      const metadata = await sharp(buffer).metadata()
      const { width = 0, height = 0 } = metadata
      
      // 计算水印大小（图片宽度的1/20）
      const watermarkSize = Math.max(12, Math.min(width / 20, 48))
      
      // 创建水印SVG
      const watermarkSvg = `
        <svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
              <feDropShadow dx="1" dy="1" stdDeviation="1" flood-color="black" flood-opacity="0.3"/>
            </filter>
          </defs>
          <text 
            x="${width - 10}" 
            y="${height - 10}" 
            font-family="Arial, sans-serif" 
            font-size="${watermarkSize}" 
            fill="white" 
            text-anchor="end" 
            dominant-baseline="baseline"
            filter="url(#shadow)"
            opacity="0.8"
          >
            ${text}
          </text>
        </svg>
      `
      
      return sharp(buffer)
        .composite([{
          input: Buffer.from(watermarkSvg),
          top: 0,
          left: 0
        }])
        .jpeg({ quality: 85 })
        .toBuffer()
    } catch (error) {
      // 水印添加失败时返回原图
      console.warn('水印添加失败:', error.message)
      return buffer
    }
  }

  generateKeys(baseKey: string): { [key: string]: string } {
    const keys: { [key: string]: string } = {}
    const [name, ext] = baseKey.split('.')
    
    for (const sizeName of Object.keys(this.sizes)) {
      keys[sizeName] = `${name}_${sizeName}.${ext}`
    }
    
    return keys
  }

  async getImageInfo(buffer: Buffer): Promise<{ width: number; height: number; size: number; format: string }> {
    const metadata = await sharp(buffer).metadata()
    return {
      width: metadata.width || 0,
      height: metadata.height || 0,
      size: buffer.length,
      format: metadata.format || 'unknown'
    }
  }
}
