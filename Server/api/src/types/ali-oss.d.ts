declare module 'ali-oss' {
  interface PutObjectOptions {
    headers?: Record<string, string>
    meta?: Record<string, string>
    mime?: string
    callback?: any
  }

  interface PutObjectResult {
    name: string
    url: string
    res: {
      status: number
      statusCode: number
      headers: Record<string, string>
    }
  }

  interface GetObjectUrlOptions {
    expires?: number
    method?: string
    headers?: Record<string, string>
    'Content-Type'?: string
  }

  interface ClientConfig {
    region: string
    accessKeyId: string
    accessKeySecret: string
    bucket: string
    secure?: boolean
    endpoint?: string
  }

  class Client {
    constructor(config: ClientConfig)
    put(name: string, file: Buffer | string, options?: PutObjectOptions): Promise<PutObjectResult>
    getObjectUrl(name: string, options?: GetObjectUrlOptions): string
    delete(name: string): Promise<{ res: { status: number } }>
    signatureUrl(name: string, options?: GetObjectUrlOptions): string
  }

  const OSS: typeof Client
  export = OSS
}
