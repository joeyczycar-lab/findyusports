import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // Nike 风格：黑白灰为主
        primary: '#000000', // 黑色主色
        primaryHover: '#1a1a1a',
        brandBlue: '#000000', // 统一使用黑色
        accent: '#000000',
        // 文本颜色
        textPrimary: '#111111', // 接近黑色
        textSecondary: '#707072', // 灰色
        textMuted: '#8D8D8D', // 浅灰
        // 背景色
        bg: '#FFFFFF',
        bgMuted: '#F5F5F5', // 浅灰背景
        // 边框
        border: '#E5E5E5', // 浅灰边框
        divider: '#E5E5E5',
      },
      fontFamily: {
        sans: [
          '"Helvetica Neue"',
          'Helvetica',
          'Arial',
          '"PingFang SC"',
          '"Microsoft YaHei"',
          'sans-serif',
        ],
      },
      fontSize: {
        'display': ['48px', { lineHeight: '1.1', fontWeight: '700' }],
        'display-sm': ['36px', { lineHeight: '1.2', fontWeight: '700' }],
        'heading': ['24px', { lineHeight: '1.3', fontWeight: '600' }],
        'heading-sm': ['20px', { lineHeight: '1.4', fontWeight: '600' }],
        'body': ['16px', { lineHeight: '1.5', fontWeight: '400' }],
        'body-sm': ['14px', { lineHeight: '1.5', fontWeight: '400' }],
        'caption': ['12px', { lineHeight: '1.5', fontWeight: '400' }],
      },
      boxShadow: {
        sm: '0 1px 3px rgba(0,0,0,0.1)',
        md: '0 4px 6px rgba(0,0,0,0.1)',
        lg: '0 10px 15px rgba(0,0,0,0.1)',
      },
      borderRadius: {
        card: '2px', // Nike 风格：小圆角
        modal: '2px',
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
      },
    },
  },
  plugins: [],
}
export default config


