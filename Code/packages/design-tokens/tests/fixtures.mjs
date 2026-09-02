export const minimalTokens = () => ({
  $meta: { name: 'test', version: '0.0.0', source: 'fixture', targets: [] },
  color: {
    brand: { 500: '#3B6FE0' },
    neutral: { 0: '#FFFFFF', 900: '#141A24' },
    success: { 500: '#1E7F4C' },
    warning: { 500: '#A9640A' },
    danger: { 500: '#D93B3B' },
    info: { 500: '#2C7BE5' },
    semantic: {
      light: { background: '{color.neutral.0}', accent: '{color.brand.500}' },
      dark: { background: '{color.neutral.900}', accent: '{color.brand.500}' },
    },
  },
  spacing: { md: '12px' },
  radius: { md: '10px' },
  typography: {
    family: { latin: 'Manrope', arabic: 'Noto Kufi Arabic', mono: 'JetBrains Mono' },
    weight: { regular: 400, bold: 700 },
    scale: { body: { size: '15px', lineHeight: '22px', weight: 400, tracking: '0' } },
  },
  elevation: {
    light: {
      none: [],
      sm: [{ x: '0px', y: '1px', blur: '2px', spread: '0px', color: 'rgba(20, 26, 36, 0.06)' }],
    },
    dark: {
      none: [],
      sm: [{ x: '0px', y: '1px', blur: '2px', spread: '0px', color: 'rgba(0, 0, 0, 0.32)' }],
    },
  },
  motion: {
    duration: { fast: '120ms', base: '200ms', slow: '320ms' },
    easing: { standard: 'cubic-bezier(0.2, 0, 0, 1)', decelerate: 'cubic-bezier(0, 0, 0, 1)' },
  },
  layout: { touchTarget: '48px', containerMax: '1200px', breakpoint: { sm: '480px' } },
});
