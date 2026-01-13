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
    const region = process.env.OSS_REGION || 'oss-cn-hangzhou'
    const bucket = process.env.OSS_BUCKET || 'venues-images'
    
    console.log('🔐 [OSS] 初始化 OSS 服务...')
    console.log('🔐 [OSS] OSS_ACCESS_KEY_ID:', accessKeyId ? `${accessKeyId.substring(0, 8)}...` : '未设置')
    console.log('🔐 [OSS] OSS_ACCESS_KEY_SECRET:', accessKeySecret ? '已设置' : '未设置')
    console.log('🔐 [OSS] OSS_REGION:', region)
    console.log('🔐 [OSS] OSS_BUCKET:', bucket)
    
    // 只有在配置了 OSS 密钥时才初始化客户端
    if (accessKeyId && accessKeySecret) {
      try {
        console.log('🔐 [OSS] 开始创建 OSS 客户端实例...')
        console.log('🔐 [OSS] 配置参数:', {
          region,
          bucket,
          accessKeyIdLength: accessKeyId.length,
          accessKeySecretLength: accessKeySecret.length
        })
        
        this.client = new OSS({
          region,
          accessKeyId,
          accessKeySecret,
          bucket,
        })
        
        // 验证客户端是否真的创建成功
        if (this.client) {
          console.log('✅ [OSS] OSS 客户端初始化成功')
          console.log('✅ [OSS] OSS 客户端类型:', typeof this.client)
          console.log('✅ [OSS] OSS 客户端方法:', Object.keys(this.client).slice(0, 5).join(', '))
        } else {
          console.error('❌ [OSS] OSS 客户端创建失败：返回值为 null 或 undefined')
          this.client = null
        }
      } catch (error) {
        console.error('❌ [OSS] OSS 客户端初始化失败:', error)
        if (error instanceof Error) {
          console.error('❌ [OSS] 错误信息:', error.message)
          console.error('❌ [OSS] 错误堆栈:', error.stack)
        }
        this.client = null
      }
    } else {
      console.warn('⚠️ [OSS] OSS 未配置：缺少 OSS_ACCESS_KEY_ID 或 OSS_ACCESS_KEY_SECRET')
      console.warn('⚠️ [OSS] accessKeyId:', accessKeyId ? `存在 (长度: ${accessKeyId.length})` : '不存在')
      console.warn('⚠️ [OSS] accessKeySecret:', accessKeySecret ? `存在 (长度: ${accessKeySecret.length})` : '不存在')
    }
    
    // 最终状态检查
    console.log('🔐 [OSS] 初始化完成，客户端状态:', this.client ? '✅ 已初始化' : '❌ 未初始化')
  }

  async generatePresignedUrl(mime: string, ext: string, key?: string) {
    if (!this.client) {
      throw new Error('OSS未配置，请设置 OSS_ACCESS_KEY_ID 和 OSS_ACCESS_KEY_SECRET')
    }
    
    // 如果提供了 key，使用提供的 key；否则生成新的
    const finalKey = key || `venues/${Date.now()}-${crypto.randomBytes(8).toString('hex')}.${ext}`
    const expires = 3600 // 1小时过期
    
    const bucket = process.env.OSS_BUCKET || 'venues-images'
    const region = process.env.OSS_REGION || 'oss-cn-hangzhou'
    
    console.log(`🔐 [OSS] Generating presigned URL for key: ${key}`)
    console.log(`🔐 [OSS] Bucket: ${bucket}, Region: ${region}`)
    
    try {
      // 生成预签名URL用于直传
      const url = this.client.signatureUrl(finalKey, {
        expires,
        method: 'PUT',
        'Content-Type': mime,
      })
      
      // 构建公共访问URL
      const publicUrl = `https://${bucket}.${region}.aliyuncs.com/${finalKey}`
      console.log(`🔐 [OSS] Generated presigned URL for key: ${finalKey}`)
      console.log(`🔐 [OSS] Generated presigned URL: ${url.substring(0, 100)}...`)
      console.log(`🔐 [OSS] Public URL: ${publicUrl}`)
      
      return {
        uploadUrl: url,
        key: finalKey,
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
