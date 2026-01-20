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
          minHeight: '300px',
          position: 'relative',
        }}
      >
      {/* 背景图片层 */}
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
          minHeight: '300px',
          opacity: 1,
          visibility: 'visible',
          display: 'block',
        }}
      />
      
      {/* 内容容器 - 居中显示二维码 */}
      <div 
        className="relative z-10 px-4 sm:px-6 lg:px-8"
        style={{
          maxWidth: '1280px',
          margin: '0 auto',
          paddingTop: '3rem',
          paddingBottom: '3rem',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '1.5rem',
          position: 'relative',
          zIndex: 10,
          textAlign: 'center',
        }}
      >
        {/* 二维码 - 居中显示 */}
        <div 
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '0.75rem',
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
            />
          </div>
          <p 
            style={{
              color: '#ffffff',
              fontSize: 'clamp(0.875rem, 2vw, 1rem)',
              fontWeight: '500',
              textAlign: 'center',
              margin: 0,
              textShadow: '0 1px 2px rgba(0, 0, 0, 0.3)',
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
