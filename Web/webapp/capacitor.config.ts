import type { CapacitorConfig } from '@capacitor/cli';

// 开发时让模拟器连本地：Android 用 CAP_DEV_SERVER=http://10.0.2.2:3000，iOS 用 CAP_DEV_SERVER=http://127.0.0.1:3000
const config: CapacitorConfig = {
  appId: 'com.findyusports.app',
  appName: 'Find遇体育',
  webDir: 'public',
  // 开发阶段：Android 模拟器固定连本地 3000 端口
  server: {
    url: 'http://10.0.2.2:3000',
    cleartext: true,
  },
};

export default config;
