declare module 'ali-oss' {
  export interface PutObjectOptions {
    headers?: Record<string, string>
    meta?: Record<string, string>
    mime?: string
    callback?: any
  }

  export interface PutObjectResult {
    name: string
    url: string
    res: {
      status: number
      statusCode: number
      headers: Record<string, string>
    }
  }

  export interface GetObjectUrlOptions {
    expires?: number
    method?: string
    headers?: Record<string, string>
  }

  export interface ClientConfig {
    region: string
    accessKeyId: string
    accessKeySecret: string
    bucket: string
    secure?: boolean
    endpoint?: string
  }

  export class Client {
    constructor(config: ClientConfig)
    put(name: string, file: Buffer | string, options?: PutObjectOptions): Promise<PutObjectResult>
    getObjectUrl(name: string, options?: GetObjectUrlOptions): string
    delete(name: string): Promise<{ res: { status: number } }>
    signatureUrl(name: string, options?: GetObjectUrlOptions): string
  }

  export default Client
}

