import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.findyusports.app',
  appName: 'Find遇体育',
  webDir: 'public',
  // 壳内直接加载线上网站，与网页端完全同步
  server: {
    url: 'https://findyusports.com',
    cleartext: false,
  },
};

export default config;
