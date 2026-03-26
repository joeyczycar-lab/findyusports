import type { CapacitorConfig } from '@capacitor/cli';

// 开发时让模拟器连本地：npm run cap:sync:dev 会注入 10.0.2.2:3000（Android）或 127.0.0.1:3000（iOS）
// 默认加载线上站，避免未开 dev 时打开 App 空白
const config: CapacitorConfig = {
  appId: 'com.findyusports.app',
  appName: 'FY体育',
  webDir: 'public',
  server: {
    url: 'https://findyusports.com',
    cleartext: true,
  },
};

export default config;
