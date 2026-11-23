import type { Config } from 'tailwindcss';
import preset from '@repo/design-tokens/tailwind-preset';

const config: Config = {
  presets: [preset as Config],
  content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'],
  darkMode: 'class',
  theme: {
    extend: {},
  },
  plugins: [],
};

export default config;
