export default function TicketBanner() {
  return (
    <>
      <style dangerouslySetInnerHTML={{
        __html: `
          .ticket-banner-bg {
            background-image: url('/football-player-bg.jpg') !important;
            background-size: cover !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            position: absolute !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            width: 100% !important;
            height: 100% !important;
            z-index: 0 !important;
            opacity: 1 !important;
            visibility: visible !important;
            display: block !important;
          }
        `
      }} />
      <section 
        className="relative w-full overflow-hidden"
        style={{
          width: '100%',
          margin: 0,
          padding: 0,
          minHeight: '200px',
          position: 'relative',
        }}
      >
      {/* 足球运动员橙色背景图片层 - 使用CSS类和内联样式双重保障 */}
      <div 
        className="ticket-banner-bg absolute inset-0"
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
          width: '100%',
          height: '100%',
          minHeight: '200px',
          opacity: 1,
          visibility: 'visible',
          display: 'block',
        }}
      />
      {/* 轻微遮罩层增强文字可读性 - 降低透明度让背景更明显 */}
      <div 
        className="absolute inset-0"
        style={{
          backgroundColor: 'rgba(0, 0, 0, 0.05)',
          zIndex: 1,
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          width: '100%',
          height: '100%',
          pointerEvents: 'none',
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
              minWidth: '120px',
              minHeight: '120px',
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
                maxWidth: '100%',
                maxHeight: '100%',
                aspectRatio: '1 / 1',
              }}
              onError={(e) => {
                console.error('二维码图片加载失败:', e)
                const target = e.target as HTMLImageElement
                target.style.display = 'none'
              }}
              onLoad={() => {
                console.log('二维码图片加载成功')
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
    </>
  )
}
