import { Injectable } from '@nestjs/common'
import * as OSS from 'ali-oss'
import * as crypto from 'crypto'

type OSSClient = InstanceType<typeof OSS>

@Injectable()
export class OssService {
  private client: OSSClient | null = null

  constructor() {
    const accessKeyId = process.env.OSS_ACCESS_KEY_ID
    const accessKeySecret = process.env.OSS_ACCESS_KEY_SECRET
    
    // 只有在配置了 OSS 密钥时才初始化客户端
    if (accessKeyId && accessKeySecret) {
      this.client = new OSS({
        region: process.env.OSS_REGION || 'oss-cn-hangzhou',
        accessKeyId,
        accessKeySecret,
        bucket: process.env.OSS_BUCKET || 'venues-images',
      })
    }
  }

  async generatePresignedUrl(mime: string, ext: string) {
    if (!this.client) {
      throw new Error('OSS未配置，请设置 OSS_ACCESS_KEY_ID 和 OSS_ACCESS_KEY_SECRET')
    }
    
    const key = `venues/${Date.now()}-${crypto.randomBytes(8).toString('hex')}.${ext}`
    const expires = 3600 // 1小时过期
    
    const bucket = process.env.OSS_BUCKET || 'venues-images'
    const region = process.env.OSS_REGION || 'oss-cn-hangzhou'
    
    console.log(`🔐 [OSS] Generating presigned URL for key: ${key}`)
    console.log(`🔐 [OSS] Bucket: ${bucket}, Region: ${region}`)
    
    try {
      // 生成预签名URL用于直传
      const url = this.client.signatureUrl(key, {
        expires,
        method: 'PUT',
        'Content-Type': mime,
      })
      
      // 构建公共访问URL
      const publicUrl = `https://${bucket}.${region}.aliyuncs.com/${key}`
      console.log(`🔐 [OSS] Generated presigned URL: ${url.substring(0, 100)}...`)
      console.log(`🔐 [OSS] Public URL: ${publicUrl}`)
      
      return {
        uploadUrl: url,
        key,
        expires: Date.now() + expires * 1000,
        publicUrl
      }
    } catch (error) {
      console.error('❌ [OSS] Failed to generate presigned URL:', error)
      throw new Error(`OSS签名生成失败: ${error instanceof Error ? error.message : String(error)}`)
    }
  }

  async deleteObject(key: string) {
    if (!this.client) {
      throw new Error('OSS未配置，请设置 OSS_ACCESS_KEY_ID 和 OSS_ACCESS_KEY_SECRET')
    }
    
    try {
      await this.client.delete(key)
      return { success: true }
    } catch (error) {
      throw new Error(`OSS删除失败: ${error instanceof Error ? error.message : String(error)}`)
    }
  }
}
