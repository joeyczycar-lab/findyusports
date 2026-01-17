export default function TicketBanner() {
  return (
    <section 
      className="relative w-full overflow-hidden"
      style={{
        width: '100%',
        margin: 0,
        padding: 0,
      }}
    >
      {/* 足球运动员橙色背景图片层 - 使用内联样式确保SSR和CSR一致 */}
      <div 
        className="absolute inset-0"
        style={{
          backgroundImage: "url('/football-player-bg.jpg')",
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          backgroundRepeat: 'no-repeat',
          zIndex: 0,
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
        }}
      />
      {/* 如果football-player-bg.jpg不存在，显示橙色渐变作为后备 */}
      <div 
        className="absolute inset-0"
        style={{
          background: 'linear-gradient(135deg, #ff6b35 0%, #f7931e 100%)',
          zIndex: 0,
          opacity: 0.3,
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
        }}
      />
      
      {/* 内容容器 - 与 container-page 对齐，但横向拉满 */}
      <div 
        className="relative z-10 px-4 sm:px-6 lg:px-8"
        style={{
          maxWidth: '1280px',
          margin: '0 auto',
          paddingTop: '2rem',
          paddingBottom: '2rem',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '2rem',
          flexWrap: 'wrap',
          position: 'relative',
          zIndex: 10,
        }}
      >
        {/* 左侧文字 */}
        <div 
          className="flex-1 min-w-[200px]"
          style={{
            color: '#ffffff',
            display: 'flex',
            flexDirection: 'column',
            gap: '0.5rem',
            flex: '1 1 300px',
          }}
        >
          <h3 
            className="text-lg sm:text-xl font-bold mb-2"
            style={{
              fontSize: 'clamp(0.625rem, 2vw, 0.9375rem)',
              fontWeight: 'bold',
              marginBottom: '0.5rem',
              lineHeight: '1.2',
            }}
          >
            实体店在线打票
          </h3>
          <p 
            className="text-sm sm:text-base"
            style={{
              fontSize: 'clamp(0.5rem, 1.5vw, 0.625rem)',
              lineHeight: '1.5',
              opacity: 0.95,
            }}
          >
            安全快速，扫码添加微信，在线打票
          </p>
        </div>
        
        {/* 右侧二维码 */}
        <div 
          className="flex-shrink-0"
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '0.75rem',
            flexShrink: 0,
          }}
        >
          <div
            className="qrcode-container"
            style={{
              width: 'clamp(120px, 20vw, 160px)',
              height: 'clamp(120px, 20vw, 160px)',
              backgroundColor: '#ffffff',
              padding: '12px',
              borderRadius: '8px',
              boxShadow: '0 4px 12px rgba(0, 0, 0, 0.2)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            <img 
              src="/wechat-qrcode.jpg" 
              alt="微信二维码"
              style={{
                width: '100%',
                height: '100%',
                objectFit: 'contain',
                display: 'block',
              }}
            />
          </div>
          <p 
            className="text-white text-sm font-medium"
            style={{
              color: '#ffffff',
              fontSize: 'clamp(0.75rem, 2vw, 0.875rem)',
              fontWeight: '500',
              textAlign: 'center',
            }}
          >
            扫码添加微信
          </p>
        </div>
      </div>
    </section>
  )
}
