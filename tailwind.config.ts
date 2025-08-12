import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        // Softer, more Zen Habits-like colors
        'text': '#2c2c2c',
        'text-light': '#666666',
        'text-lighter': '#888888',
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}

export default config
