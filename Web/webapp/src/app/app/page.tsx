import AppDownloadQrImage from '@/components/AppDownloadQrImage'

export const metadata = {
  title: '下载 FY体育 App',
  description: '下载 FY体育 App，在手机上更方便地查找和预定运动场地。',
}

export default function AppDownloadPage() {
  return (
    <main className="bg-white min-h-screen">
      <section className="container-page py-12 lg:py-20">
        <div className="grid gap-10 lg:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)] items-center">
          {/* 左侧文案区域 */}
          <div className="space-y-6">
            <div className="space-y-2">
              <p className="text-sm font-medium text-gray-500 tracking-[0.2em] uppercase">
                FY体育 App
              </p>
              <h1 className="text-3xl lg:text-4xl font-bold tracking-tight text-black">
                在手机上，随时找到你的主场
              </h1>
            </div>
            <p className="text-base text-gray-700 leading-relaxed">
              用 FY体育 App，你可以在通勤路上、临时约球前，随时打开手机快速查看附近的足球场、篮球场。
              支持地图浏览、条件筛选和收藏常用场地，让每一次临时起意都有地方可以去。
            </p>
            <div className="space-y-3 text-sm text-gray-700">
              <p className="font-medium text-black">当前支持：</p>
              <ul className="list-disc list-inside space-y-1">
                <li>安卓版本（APK 安装包）</li>
                <li>iOS 版本正在筹备中，敬请期待</li>
              </ul>
            </div>
            <div className="rounded-xl bg-gray-50 border border-gray-200 px-4 py-3 text-sm text-gray-700">
              <p className="font-medium text-black mb-1">如何使用本页面？</p>
              <p>
                部署到正式域名后，请使用该页面地址（例如
                <span className="mx-1 font-mono text-xs bg-gray-100 px-1 py-0.5 rounded">
                  https://你的域名.com/app
                </span>
                ）生成二维码图片，并命名为
                <span className="mx-1 font-mono text-xs bg-gray-100 px-1 py-0.5 rounded">
                  app-download-qrcode.png
                </span>
                放入
                <span className="mx-1 font-mono text-xs bg-gray-100 px-1 py-0.5 rounded">
                  public
                </span>
                目录。之后，用户扫描任意地方的「下载 App」二维码都会先打开本页面，再从这里进入对应下载入口。
              </p>
            </div>
          </div>

          {/* 右侧二维码区域 */}
          <div className="flex flex-col items-center justify-center gap-4">
            <div className="rounded-2xl border border-gray-200 bg-white p-5 shadow-sm">
              <AppDownloadQrImage />
            </div>
            <p className="text-sm text-gray-600 text-center max-w-[220px]">
              使用手机相机或扫一扫功能，扫描二维码在手机浏览器中打开本页面，再根据提示下载 FY体育 App。
            </p>
          </div>
        </div>
      </section>
    </main>
  )
}

