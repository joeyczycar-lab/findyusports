import { Injectable } from '@nestjs/common'
import * as crypto from 'crypto'

@Injectable()
export class HotlinkProtectionService {
  private readonly secretKey = process.env.OSS_HOTLINK_SECRET || 'default-secret-key'

  generateSignedUrl(url: string, expiresIn: number = 3600): string {
    const expires = Math.floor(Date.now() / 1000) + expiresIn
    const path = new URL(url).pathname
    const signature = this.generateSignature(path, expires)
    
    return `${url}?x-oss-process=image/watermark,text_${encodeURIComponent('场地分享')},size_20,color_FFFFFF,position_bottom-right&x-oss-expires=${expires}&x-oss-signature=${signature}`
  }

  private generateSignature(path: string, expires: number): string {
    const stringToSign = `GET\n\n\n${expires}\n${path}`
    return crypto
      .createHmac('sha1', this.secretKey)
      .update(stringToSign)
      .digest('base64')
  }

  verifySignature(url: string, signature: string, expires: number): boolean {
    try {
      const path = new URL(url).pathname
      const expectedSignature = this.generateSignature(path, expires)
      return signature === expectedSignature
    } catch {
      return false
    }
  }

  generateTokenizedUrl(originalUrl: string, userId?: string): string {
    const token = this.generateAccessToken(originalUrl, userId)
    return `${originalUrl}?token=${token}`
  }

  private generateAccessToken(url: string, userId?: string): string {
    const payload = {
      url,
      userId,
      timestamp: Date.now(),
      nonce: Math.random().toString(36).substr(2, 9)
    }
    
    const token = Buffer.from(JSON.stringify(payload)).toString('base64')
    const signature = crypto
      .createHmac('sha256', this.secretKey)
      .update(token)
      .digest('hex')
    
    return `${token}.${signature}`
  }

  verifyToken(token: string): { valid: boolean; url?: string; userId?: string } {
    try {
      const [payload, signature] = token.split('.')
      const expectedSignature = crypto
        .createHmac('sha256', this.secretKey)
        .update(payload)
        .digest('hex')
      
      if (signature !== expectedSignature) {
        return { valid: false }
      }
      
      const data = JSON.parse(Buffer.from(payload, 'base64').toString())
      const now = Date.now()
      
      // 检查token是否过期（24小时）
      if (now - data.timestamp > 24 * 60 * 60 * 1000) {
        return { valid: false }
      }
      
      return { valid: true, url: data.url, userId: data.userId }
    } catch {
      return { valid: false }
    }
  }
}
