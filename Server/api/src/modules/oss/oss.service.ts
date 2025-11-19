import { Injectable } from '@nestjs/common'
import * as OSS from 'ali-oss'
import * as crypto from 'crypto'

@Injectable()
export class OssService {
  private client: OSS

  constructor() {
    this.client = new OSS({
      region: process.env.OSS_REGION || 'oss-cn-hangzhou',
      accessKeyId: process.env.OSS_ACCESS_KEY_ID || '',
      accessKeySecret: process.env.OSS_ACCESS_KEY_SECRET || '',
      bucket: process.env.OSS_BUCKET || 'venues-images',
    })
  }

  async generatePresignedUrl(mime: string, ext: string) {
    const key = `venues/${Date.now()}-${crypto.randomBytes(8).toString('hex')}.${ext}`
    const expires = 3600 // 1小时过期
    
    try {
      // 生成预签名URL用于直传
      const url = this.client.signatureUrl(key, {
        expires,
        method: 'PUT',
        'Content-Type': mime,
      })
      
      return {
        uploadUrl: url,
        key,
        expires: Date.now() + expires * 1000,
        publicUrl: `https://${process.env.OSS_BUCKET}.${process.env.OSS_REGION}.aliyuncs.com/${key}`
      }
    } catch (error) {
      throw new Error(`OSS签名生成失败: ${error.message}`)
    }
  }

  async deleteObject(key: string) {
    try {
      await this.client.delete(key)
      return { success: true }
    } catch (error) {
      throw new Error(`OSS删除失败: ${error.message}`)
    }
  }
}
