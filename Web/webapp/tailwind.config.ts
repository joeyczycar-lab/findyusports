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
        primary: '#16A34A',
        primaryHover: '#15803D',
        brandBlue: '#2563EB',
        accent: '#F97316',
        textPrimary: '#0F172A',
        textSecondary: '#475569',
        textMuted: '#64748B',
        border: '#E2E8F0',
        divider: '#E5E7EB',
      },
      boxShadow: {
        sm: '0 1px 2px rgba(0,0,0,.05)',
        md: '0 4px 10px rgba(0,0,0,.08)'
      },
      borderRadius: {
        card: '8px',
        modal: '12px'
      }
    },
  },
  plugins: [],
}
export default config


