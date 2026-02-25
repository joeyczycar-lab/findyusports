export default function TicketBannerMobile() {
  return (
    <section className="px-4">
      <div
        className="relative w-full rounded-xl overflow-hidden"
        style={{
          height: 160, // 明显比之前矮
          backgroundImage: "url('/football-player-bg.jpg')",
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
      >
        {/* 左侧文案 */}
        <div
          className="absolute left-4 top-1/2 -translate-y-1/2 text-white"
          style={{ textShadow: "0 1px 2px rgba(0,0,0,0.5)" }}
        >
          <h3 className="font-bold text-lg mb-1">竞彩实体店出票</h3>
          <p className="text-xs mb-0.5">备战世界杯</p>
          <p className="text-xs mb-0">即刻扫码</p>
        </div>

        {/* 右侧二维码 */}
        <div
          className="absolute right-4 top-1/2 -translate-y-1/2 bg-white rounded-lg"
          style={{
            padding: 8,
            boxShadow: "0 4px 12px rgba(0,0,0,0.25)",
          }}
        >
          <img
            src="/wechat-qrcode.jpg"
            alt="扫码添加微信"
            style={{ width: 80, height: 80, objectFit: "contain" }}
          />
        </div>
      </div>
    </section>
  )
}

