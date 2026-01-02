// 测试脚本：直接测试后端 analytics API
// 使用方法：node test-analytics-api.js

const token = process.argv[2] || 'YOUR_TOKEN_HERE'

if (token === 'YOUR_TOKEN_HERE') {
  console.log('❌ 请提供 token 作为参数')
  console.log('使用方法: node test-analytics-api.js YOUR_TOKEN')
  process.exit(1)
}

async function testAPI() {
  try {
    console.log('🧪 测试后端 analytics API...')
    console.log('📍 后端地址: http://localhost:4000')
    console.log('🔐 Token (前30字符):', token.substring(0, 30) + '...')
    
    const response = await fetch('http://localhost:4000/analytics/stats', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    })
    
    console.log('\n📊 响应状态:', response.status, response.statusText)
    console.log('📋 响应头:', Object.fromEntries(response.headers.entries()))
    
    const text = await response.text()
    console.log('\n📄 响应内容:')
    try {
      const json = JSON.parse(text)
      console.log(JSON.stringify(json, null, 2))
    } catch {
      console.log(text)
    }
    
    if (!response.ok) {
      console.error('\n❌ API 调用失败')
      process.exit(1)
    } else {
      console.log('\n✅ API 调用成功')
    }
  } catch (error) {
    console.error('❌ 错误:', error.message)
    if (error.code === 'ECONNREFUSED') {
      console.error('💡 提示: 后端服务可能没有运行，请确保后端服务在 http://localhost:4000 运行')
    }
    process.exit(1)
  }
}

testAPI()

